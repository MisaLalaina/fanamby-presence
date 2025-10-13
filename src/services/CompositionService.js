import { BASE_URL } from './config';
// 💡 Import des fonctions génériques depuis l'API
import {
    genericCreate,
    genericUpdate,
    genericDelete,
    genericGet,
    genericSearch,
    fetchAllPages 
} from './api'; 

// Chemin de base pour les ressources Compositions
const COMPOSITION_URL = `${BASE_URL}/compositions`;
const STATUT_COMPOSITION_URL = `${BASE_URL}/statutcompositions`;

// --- Fonctions utilitaires de Mapping ---

/**
 * Mappe un objet composition brut de l'API vers le modèle du front-end.
 * @param {object} c - L'objet composition brut de l'API.
 * @returns {object} La composition formatée pour le front-end.
 */
const mapCompositionFromApi = (c) => ({
    idComposition: c.idcomposition,
    idMatch: c.idmatchMatchfoot?.idmatch || null,
    idJoueur: c.idjoueurJoueur?.idjoueur || null,
    idStatutComposition: c.idstatutcompositionStatutcomposition?.idstatutcomposition || null,
    numeroMaillot: c.numeromaillot || null,
    position: c.position || null,
    isCapitaine: Boolean(c.iscapitaine),
    commentaire: c.commentaire || '',

    nom: c.idjoueurJoueur?.nom || '',
    prenom: c.idjoueurJoueur?.prenom || '',
    poste: c.idjoueurJoueur?.idpostePoste?.libelle || ''
});

/**
 * Construit le payload (corps de requête) pour la création ou la mise à jour d'une composition.
 * @param {object} form - Les données du front-end (camelCase).
 * @returns {object} Le payload formaté pour l'API (snake_case/imbriqué).
 */
const createCompositionPayload = (form) => ({
    idmatchMatchfoot: {
        idmatch: form.idMatch
    },
    idjoueurJoueur: {
        idjoueur: form.idJoueur
    },
    idstatutcompositionStatutcomposition: {
        idstatutcomposition: form.idStatutComposition
    },
    numeromaillot: form.numeroMaillot || null,
    position: form.position || null,
    iscapitaine: !!form.isCapitaine,
    commentaire: form.commentaire || ''
    // Note: Ajouter l'idcomposition ici si vous prévoyez une fonction updateComposition
});


// --- Fonctions de Service ---

/** * Récupère TOUTES les compositions. Utilise fetchAllPages.
 * 💡 Remplacement de la logique fetch manuelle et suppression de la pagination manuelle.
 */
export async function getAllCompositions() {
    // fetchAllPages gère la récupération de toutes les pages et la gestion des erreurs.
    const response = await fetchAllPages(COMPOSITION_URL);
    // Retourne le tableau de contenu brut de l'API.
    return response.data.content;
}

/** * Récupère toutes les compositions puis filtre par ID de match et mappe.
 * Cette logique de filtrage client est conservée.
 * Note : Idéalement, l'API devrait proposer un endpoint de filtrage (ex: /compositions/match/{matchId}).
 */
export async function getAllCompositionsByMatchId(matchId) {
    const payload = {
      idmatchMatchfoot:{
        idmatch: matchId
      }
    }
    const compositions = await genericSearch(COMPOSITION_URL+'/search', payload);
    console.log(compositions);
    

    return compositions.data.content.map(mapCompositionFromApi); 
}

/** * Récupère tous les statuts de composition.
 * 💡 Remplacement de la logique fetch manuelle par `genericGet` (ou `fetchAllPages` si paginé).
 */
export async function getAllStatutCompositions() {
    const response = await fetchAllPages(STATUT_COMPOSITION_URL);
    const statusesArray = Array.isArray(response.data?.content) ? response.data.content : [];
    
    // Mapping des statuts (logique métier spécifique à ce service)
    return statusesArray.map(s => ({
        idStatutComposition: s.idstatutcomposition,
        libelle: s.libelle
    }));
}

/** * Crée une nouvelle composition. Utilise genericCreate.
 * 💡 Remplacement de la logique POST manuelle par `genericCreate`.
 */
export async function createComposition(form) {
    const payload = createCompositionPayload(form);
    
    // genericCreate gère la requête POST, les headers, le JSON.stringify, et la gestion d'erreur complète (HTTP + API returnCode).
    const createdRawComposition = await genericCreate(COMPOSITION_URL, payload);
    
    // Retourne l'objet créé (vous pouvez choisir de le mapper ici si nécessaire)
    // Ici, nous supposons que l'API renvoie l'objet créé, donc nous le retournons.
    return createdRawComposition;
}

// ------------------------------------------------------------------------
// Compléments : DELETE et UPDATE
// ------------------------------------------------------------------------

/** * Met à jour une composition (si l'API utilise PUT /compositions/{id}).
 * @param {number} id - L'ID de la composition.
 * @param {object} form - Les données de la composition à mettre à jour.
 */
export async function updateComposition(id, form) {
    // Assurez-vous que le payload inclut l'ID si votre API le requiert.
    const payload = { idcomposition: id, ...createCompositionPayload(form) };
    return genericUpdate(`${COMPOSITION_URL}/${id}`, payload);
}

/** * Supprime une composition par ID.
 * @param {number} id - L'ID de la composition à supprimer.
 */
export async function deleteComposition(id) {
    return genericDelete(`${COMPOSITION_URL}/${id}`);
}