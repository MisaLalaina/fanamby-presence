import { BASE_URL } from './config.js';
import MatchFoot from '../models/matchFoot.js';
// 💡 Import des fonctions génériques depuis l'API
import {
    genericCreate,
    genericUpdate,
    genericDelete,
    genericGet,
    fetchAllPages 
} from './api'; 

// Chemin de base pour cette ressource
const MATCHFOOT_URL = `${BASE_URL}/matchfoots`;

/**
 * Construit le corps de la requête (payload) pour une création ou mise à jour de match.
 * Cette fonction contient toute la logique métier de mapping des champs.
 */
const createMatchPayload = (matchData) => {
    // Note: L'ID est géré par l'URL (pour l'update) ou par l'absence d'ID (pour la création)
    return {
        idseanceSeance: {
            idseance: matchData.idSeance,
        },
        idtypematchTypematch:{
            idtypematch: matchData.idTypeMatch,
        },
        competition: matchData.competition || '',
        adversaire: matchData.adversaire || '',
        domicile: Boolean(matchData.domicile),
        scoreequipe: matchData.scoreEquipe || 0,
        scoreadversaire: matchData.scoreAdversaire || 0,
        // Ces champs sont définis par défaut à 0 dans le payload de la fonction originale
        tempsadditionnel1: matchData.tempsAdditionnel1 || 0, 
        tempsadditionnel2: matchData.tempsAdditionnel2 || 0,
        incidents: matchData.incidents || '',
        observations: matchData.observations || '',
    };
};

/**
 * Récupère tous les matchs. Utilise fetchAllPages pour gérer la pagination.
 * 💡 Remplacement de la logique fetch manuelle par `fetchAllPages`.
 */
export async function getAllMatches() {
    // fetchAllPages gère la boucle, les erreurs HTTP/API, et retourne le résultat complet.
    const response = await fetchAllPages(MATCHFOOT_URL);
    
    // Le mapping vers le modèle métier reste ici (bonne pratique).
    const rawMatches = response.data.content || [];
    return rawMatches.map(rawMatch => MatchFoot.fromApi(rawMatch));
}

/**
 * Crée un match. Utilise genericCreate.
 * 💡 Remplacement de la logique POST manuelle par `genericCreate`.
 */
export async function createMatch(matchData) {
    const payload = createMatchPayload(matchData);
    const createdRawMatch = await genericCreate(MATCHFOOT_URL, payload);
    return MatchFoot.fromApi(createdRawMatch);
}

/**
 * Récupère un match par ID. Utilise genericGet.
 * 💡 Remplacement de la logique GET manuelle par `genericGet`.
 */
export async function getMatchById(id) {
    // genericGet gère la requête GET et la vérification des erreurs.
    const response = await genericGet(`${MATCHFOOT_URL}/${id}`);
    
    // genericGet retourne l'objet complet { data: { content: ... } }, donc on accède à .data.
    const rawMatch = response.data || {};
    
    // Mapping du résultat brut vers le modèle du front-end.
    return MatchFoot.fromApi(rawMatch);
}

/**
 * Met à jour un match. Utilise genericUpdate.
 * 💡 Remplacement de la logique PUT manuelle par `genericUpdate`.
 */
export async function updateMatch(id, matchData) {
    const payload = createMatchPayload(matchData);
    
    // genericUpdate gère la requête PUT, les headers, le JSON.stringify et la vérification des erreurs.
    const updatedRawMatch = await genericUpdate(`${MATCHFOOT_URL}/${id}`, payload);
    
    // Mapping du résultat brut vers le modèle du front-end.
    return MatchFoot.fromApi(updatedRawMatch);
}

export async function deleteMatch(id) {
    // genericDelete gère la requête DELETE et la vérification des erreurs.
    // L'API ne renvoie généralement pas de données, juste un statut de succès.
    return genericDelete(`${MATCHFOOT_URL}/${id}`);
}