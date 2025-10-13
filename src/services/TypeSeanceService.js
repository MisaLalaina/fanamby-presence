import { BASE_URL } from './config';
// 💡 Import de la fonction générique appropriée
import { genericGet, fetchAllPages } from './api'; 

// Chemin de base pour les ressources TypeSeances
const TYPESEANCE_URL = `${BASE_URL}/typeseances`;

export default {
    /** * Récupère tous les types de séances. 
     * Utilise fetchAllPages pour s'assurer que même les listes paginées sont récupérées entièrement.
     * 💡 Remplace toute la logique de fetch, de gestion d'erreur HTTP et de returnCode.
     */
    async getAllTypeSeances() {
        // fetchAllPages gère la boucle de pagination, les erreurs et la fusion des données.
        const response = await fetchAllPages(TYPESEANCE_URL);
        
        // Retourne le contenu complet (le tableau d'objets)
        return response.data.content;
    },

    /** * Récupère un type de séance par son ID.
     * 💡 Utilise genericGet.
     */
    async getTypeSeanceById(id) {
        // genericGet gère la requête GET et la vérification des erreurs (HTTP et returnCode).
        const response = await genericGet(`${TYPESEANCE_URL}/${id}`);

        // Retourne l'objet typeSeance brut de l'API (contenu dans la propriété 'data' de la réponse).
        return response.data;
    }
};