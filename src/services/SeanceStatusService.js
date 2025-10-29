import { BASE_URL } from './config';
// 💡 Import de la fonction générique pour la récupération de données
import { genericGet } from './api'; 

// Chemin de base pour les ressources StatutPresences
const STATUT_SEANCE_URL = `${BASE_URL}/statutseances`;

export default {
    async getAllSeanceStatus() {
        // genericGet gère le fetch, la vérification HTTP, et le returnCode.
        const response = await genericGet(STATUT_SEANCE_URL);
        const rawStatuses = response.data?.content || response.data || [];
        return rawStatuses.map(s => ({
            idStatutSeance: s.idstatutseance,
            libelle: s.libelle,
        }));
    }
} 