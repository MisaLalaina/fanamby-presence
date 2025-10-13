import { BASE_URL } from './config';
// 💡 Import de la fonction générique pour la récupération de données
import { genericGet } from './api'; 

// Chemin de base pour les ressources StatutPresences
const STATUT_PRESENCES_URL = `${BASE_URL}/statutpresences`;

/**
 * Récupère tous les statuts de présence.
 * 💡 Utilise genericGet pour gérer la requête HTTP et la vérification des erreurs API.
 * @returns {Promise<Array<object>>} La liste des statuts de présence formatés.
 */
export async function getAllPresenceStatus() {
    // genericGet gère le fetch, la vérification HTTP, et le returnCode.
    const response = await genericGet(STATUT_PRESENCES_URL);
    const rawStatuses = response.data?.content || response.data || [];
    return rawStatuses.map(s => ({
        idStatutPresence: s.idstatutpresence,
        libelle: s.libelle,
    }));
}