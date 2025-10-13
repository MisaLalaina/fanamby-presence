import { BASE_URL } from './config';
// 💡 Import des fonctions génériques depuis l'API
import { fetchAllPages } from './api'; 
import { Poste } from '@/models/poste';

// Chemin de base pour les ressources Postes
const POSTES_URL = `${BASE_URL}/postes`;

/**
 * Récupère tous les postes.
 * Utilise fetchAllPages pour s'assurer que même si l'endpoint est paginé
 * (ce qui est souvent le cas dans les API Spring Data), toutes les données sont collectées.
 * 💡 Remplace la logique fetch manuelle et la gestion d'erreur.
 * * @returns {Promise<Array<object>>} La liste complète des postes.
 */
export async function getAllPostes() {
    // fetchAllPages gère la boucle, les erreurs HTTP/API et la fusion des pages.
    const response = await fetchAllPages(POSTES_URL);
    return Poste.listFromApiData(response);
}