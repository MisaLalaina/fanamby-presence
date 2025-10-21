import { BASE_URL } from './config';
// 💡 Import de la fonction générique pour la récupération de données
import { genericGet, fetchAllPages } from './api'; 
import { PiedFort } from '@/models/piedFort';

// Chemin de base pour les ressources PiedsForts
const PIEDFORT_URL = `${BASE_URL}/piedforts`;


export async function getAllPiedsFort() {
    const response = await fetchAllPages(PIEDFORT_URL);
    return PiedFort.listFromApiData(response);
}
