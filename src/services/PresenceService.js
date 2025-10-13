import { BASE_URL } from './config.js';
// 💡 Import des fonctions génériques depuis l'API
import {
    genericCreate,
    genericUpdate, // Ajout de l'update pour la complétude
    genericSearch // Assurez-vous d'utiliser le nom exact de votre fonction générique POST Search
} from './api'; 

// Chemin de base pour les ressources Présences
const PRESENCES_URL = `${BASE_URL}/presences`;
const stat_general = `${BASE_URL}/presences`

// --- Fonctions utilitaires de Mapping ---

/**
 * Construit le corps de la requête (payload) pour une création/mise à jour de présence.
 * @param {object} presenceData - Les données de présence du front-end.
 * @returns {object} Le payload prêt pour l'API.
 */
const createPresencePayload = (presenceData) => ({
    idseanceSeance: {
        idseance: presenceData.idSeance,
    },
    idjoueurJoueur: {
        idjoueur: presenceData.idJoueur,
    },
    idstatutpresenceStatutpresence: {
        idstatutpresence: presenceData.idStatutPresence,
    },
    commentaires: presenceData.commentaire || '',
    // Ajouter d'autres champs si le service gère l'update ou plus de détails
    // idpresence: presenceData.idPresence, // Pour l'update
    heurearrivee: presenceData.heureArrivee || null,
    motifabsence: presenceData.motifAbsence || null,
    signature: presenceData.signature || null,
});

/**
 * Mappe un objet présence brut de l'API vers le modèle du front-end.
 * @param {object} p - L'objet présence brut de l'API.
 * @returns {object} La présence formatée pour le front-end.
 */
const mapPresenceFromApi = (p) => ({
    idPresence: p.idpresence,
    idJoueur: p.idjoueurJoueur?.idjoueur,
    nom: p.idjoueurJoueur?.nom,
    prenom: p.idjoueurJoueur?.prenom,
    poste: p.idjoueurJoueur?.idpostePoste?.libelle || '',
    presenceStatus: p.idstatutpresenceStatutpresence?.libelle || null,
    idStatutPresence: p.idstatutpresenceStatutpresence?.idstatutpresence || null,
    dateSeance : p.idseanceSeance?.dateseance, 
    typeSeance : p.idseanceSeance?.idtypeseanceTypeseance?.libelle, 
    commentaire: p.commentaires || '',
    heureArrivee: p.heurearrivee || null,
    motifAbsence: p.motifabsence || null,
    signature: p.signature || null,
});



// --- Fonctions de Service ---

/** * Crée un enregistrement de présence. Utilise genericCreate.
 * 💡 Remplacement de la logique POST manuelle par `genericCreate`.
 */
export async function createPresence(presenceData) {
    const payload = createPresencePayload(presenceData);
    
    // genericCreate gère la requête POST, les headers, le JSON.stringify et la gestion des erreurs complète.
    return genericCreate(PRESENCES_URL, payload); // Retourne json.data (l'objet créé)
}

/** * Recherche des présences via un POST complexe avec pagination.
 * 💡 Remplacement de la logique fetch/fetchAllPages manuelle par `genericSearchPost`.
 */
export async function searchPresence(payload) {
    const url = `${PRESENCES_URL}/search`;
    
    // genericSearchPost (qui utilise fetchAllPages pour le POST) gère la requête et les erreurs.
    const response = await genericSearch(url, payload);

    // genericSearchPost retourne la réponse fusionnée { ..., data: { content: [...] } }
    return response.data.content;
}

/** * Récupère les présences par ID de séance en utilisant la fonction de recherche.
 * 💡 Simplification de la logique de recherche et de l'encapsulation try/catch.
 */
export async function getPresencesByIdSeance(idSeance) {
    try {
        // Préparation du payload de recherche
        const searchPayload = {
            idseanceSeance: {
                idseance: idSeance,
            },
        };
        // La fonction searchPresence est désormais propre et retourne le tableau de données brutes
        const allPresencesRaw = await searchPresence(searchPayload);

        // Mapping final vers le modèle simplifié
        return allPresencesRaw.map(mapPresenceFromApi);

    } catch (error) {
        // Le throw error de searchPresence est propagé.
        console.error('Error fetching presences:', error);
        throw error;
    }
}

export async function getPresencesByPlayerId(playerId){
    try {
        // Préparation du payload de recherche
        const searchPayload = {
          idjoueurJoueur: {
            idjoueur: playerId,
          }
        };
        
        const response = await genericSearch(stat_general+'/search', searchPayload);

        // La fonction searchPresence est désormais propre et retourne le tableau de données brutes
        const allPresencesRaw = response.data.content;

        // Mapping final vers le modèle simplifié
        return allPresencesRaw.map(mapPresenceFromApi);

    } catch (error) {
        // Le throw error de searchPresence est propagé.
        console.error('Error fetching presences:', error);
        throw error;
    }
}
// ------------------------------------------------------------------------
// Compléments : Update (si nécessaire)
// ------------------------------------------------------------------------

/** * Met à jour un enregistrement de présence.
 * @param {number} id - L'ID de la présence à modifier.
 * @param {object} presenceData - Les données à mettre à jour.
 */
export async function updatePresence(id, presenceData) {
    const payload = { idpresence: id, ...createPresencePayload(presenceData) };
    return genericUpdate(`${PRESENCES_URL}/${id}`, payload);
}