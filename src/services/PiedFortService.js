import { BASE_URL } from './config';
// 💡 Import de la fonction générique pour la récupération de données
import { genericGet, fetchAllPages } from './api'; 

// Chemin de base pour les ressources PiedsForts
const PIEDFORT_URL = `${BASE_URL}/piedforts`;


export async function getAllPiedsFort() {
    // 🔔 Choix 1 : Si l'endpoint n'est pas paginé (liste de référence)
    // const response = await genericGet(PIEDFORT_URL);
    // return response.data.content; // Assumer qu'il y a data.content

    // 🔔 Choix 2 : Si l'endpoint est paginé et vous voulez toutes les pages (le plus sûr)
    const response = await fetchAllPages(PIEDFORT_URL);
    
    // Le contenu retourné par fetchAllPages est déjà fusionné.
    // fetchAllPages retourne { ..., data: { content: allContent, ... } }
    return response.data.content;
}
