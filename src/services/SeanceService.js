import { BASE_URL } from './config';
import { 
    genericCreate, 
    genericUpdate, 
    genericDelete, 
    genericGet, 
    fetchAllPages 
} from './api'; 

const parseTime = (timeStr) => {
    if (!timeStr) return null;
    const [hour, minute] = timeStr.split(':').map(Number);
    return `${hour.toString().padStart(2, '0')}:${minute.toString().padStart(2, '0')}:00`;
};

const createSeancePayload = (seanceData, id = null) => ({
    ...(id && { idseance: id }), 
    idtypeseanceTypeseance: { idtypeseance: seanceData.idTypeSeance },
    idclubClub: { idclub: seanceData.clubId },
    dateseance: seanceData.dateSeance,
    heuredebut: parseTime(seanceData.heureDebut),
    heurefin: parseTime(seanceData.heureFin),
    lieu: seanceData.lieu,
    objectif: seanceData.objectif || '',
    bilan: seanceData.bilan || '',
    idstatutseanceStatutseance: { idstatutseance: seanceData.statutId }
});

export default {
    async getAllSeances() {
        const data = await fetchAllPages(`${BASE_URL}/seances`);
        return data.data.content;
    },

    async createSeance(seanceData) {
        const payload = createSeancePayload(seanceData);
        return genericCreate(`${BASE_URL}/seances`, payload);
    },

    async updateSeance(id, seanceData) {
        const payload = createSeancePayload(seanceData, id);
        return genericUpdate(`${BASE_URL}/seances/${id}`, payload);
    },
    
    async deleteSeance(id) {
        return genericDelete(`${BASE_URL}/seances/${id}`);
    },

    async getSeanceById(id) {
        // genericGet retourne la réponse complète (qui contient response.data)
        const response = await genericGet(`${BASE_URL}/seances/${id}`);
        const seance = response.data; 
        
        return {
            idSeance: seance.idseance,
            idTypeSeance: seance.idtypeseanceTypeseance?.idtypeseance,
            clubId: seance.idclubClub?.idclub,
            dateSeance: seance.dateseance,
            heureDebut: seance.heuredebut?.substring(0, 5),
            heureFin: seance.heurefin?.substring(0, 5),
            lieu: seance.lieu,
            objectif: seance.objectif,
            bilan: seance.bilan,
            statutId: seance.idstatutseanceStatutseance?.idstatutseance
        };
    },
};