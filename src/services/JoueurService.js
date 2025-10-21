// JoueurService.js
import { BASE_URL } from './config';
import { Joueur, JoueurSpecification } from '@/models/joueur';
// Import des fonctions génériques depuis api.js
import { 
    genericCreate, 
    genericUpdate, 
    genericDelete, 
    genericGet, 
    fetchAllPages,
    genericSearch,
    // genericSearchPost // Ajoutez-le si vous avez une recherche complexe par POST
} from './api'; 

// Le chemin de base pour les ressources Joueurs
const JOUEUR_URL = `${BASE_URL}/joueurs`;
const JOUEUR_CPL_URL = `${BASE_URL}/joueurcpl`;

/**
 * Crée un nouveau joueur.
 * Délégué entièrement à genericCreate.
 * @param {object} joueur - Les données du joueur à créer.
 * @returns {Promise<object>} Le joueur créé.
 */
export async function createJoueur(joueur) {
    // Utilise genericCreate pour la requête POST, la gestion des erreurs HTTP/API.
    return genericCreate(JOUEUR_URL, joueur);
}

/**
 * Récupère tous les joueurs.
 * Délégué entièrement à fetchAllPages pour gérer la pagination.
 * @returns {Promise<Array<object>>} La liste complète des joueurs.
 */
export async function getAllJoueurs() {
    // Utilise fetchAllPages pour récupérer toutes les pages de l'endpoint /joueurs.
    const response = await fetchAllPages(JOUEUR_URL);
    return Joueur.listFromApiData(response);
}

// ------------------------------------------------------------------------
// Ajout des opérations CRUD/Read complémentaires pour un service complet :
// ------------------------------------------------------------------------

/**
 * Récupère un joueur par son ID.
 * @param {number} id - L'ID du joueur.
 * @returns {Promise<object>} Le joueur trouvé.
 */
export async function getJoueurById(id) {
    // genericGet retourne la réponse complète, y compris l'objet data (le joueur)
    const response = await genericGet(`${JOUEUR_URL}/${id}`);
    const joueur = Joueur.fromApiData(response.data)
    return joueur;
}

/**
 * Met à jour un joueur existant.
 * @param {number} id - L'ID du joueur.
 * @param {object} joueurData - Les données à mettre à jour.
 * @returns {Promise<object>} Le joueur mis à jour.
 */
export async function updateJoueur(id, joueurData) {
    return await genericUpdate(`${JOUEUR_URL}/${id}`, joueurData);
}

/**
 * Supprime un joueur par son ID.
 * @param {number} id - L'ID du joueur.
 * @returns {Promise<any>} Le résultat de l'opération (souvent un message de succès).
 */
export async function deleteJoueur(id) {
    // genericDelete gère la requête DELETE.
    return genericDelete(`${JOUEUR_URL}/${id}`);
}

export async function  searchJoueurs(data, pageRequest) {
    const spec = new JoueurSpecification(data)
    const response = await genericSearch(`${JOUEUR_URL}/search`, spec.getSearchPayload(), pageRequest)
    return { data: Joueur.listFromApiData(response), page: response.data.page}
}