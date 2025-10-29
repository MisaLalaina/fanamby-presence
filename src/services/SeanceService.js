import { BASE_URL } from './config';
import { 
    genericCreate, 
    genericUpdate, 
    genericDelete, 
    genericGet, 
    genericSearch,
    fetchAllPages 
} from './api'; 
import { Seance, SeanceSpecification } from '@/models/seance';

const parseTime = (timeStr) => {
    if (!timeStr) return null;
    const [hour, minute] = timeStr.split(':').map(Number);
    return `${hour.toString().padStart(2, '0')}:${minute.toString().padStart(2, '0')}:00`;
};

const createSeancePayload = (seanceData, id = null) => ({
    ...(id && { idseance: id }), 
    idtypeseanceTypeseance: { idtypeseance: seanceData.idTypeSeance },
    idclubClub: { idclub: seanceData.idclubClub.idclub },
    dateseance: seanceData.dateSeance,
    heuredebut: parseTime(seanceData.heureDebut),
    heurefin: parseTime(seanceData.heureFin),
    lieu: seanceData.lieu,
    objectif: seanceData.objectif || '',
    bilan: seanceData.bilan || '',
    idstatutseanceStatutseance: { idstatutseance: seanceData.idstatutseanceStatutseance.idstatutseance }
});

export default {
    async getAllSeances() {
        const data = await fetchAllPages(`${BASE_URL}/seances?sortParam=dateseance,desc`);
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

    async searchSeance(data, pageRequest) {
        const spec = new SeanceSpecification({
            status: data.idstatutseanceStatutseance.idstatutseance
        })
        const response = await genericSearch(`${BASE_URL}/seances/search`, spec.getSearchPayload(), pageRequest)
        return { data: Seance.formatSeances(response.data.content), page: response.data.page}
    },

    async getAllPlanifiedSeance(){
        const { data } = await this.searchSeance({
            idstatutseanceStatutseance:{
                idstatutseance : 1
            }
        })
        return data
    },

    async getSeanceById(id) {
        // genericGet retourne la réponse complète (qui contient response.data)
        const response = await genericGet(`${BASE_URL}/seances/${id}`);
        const seance = response.data; 
        
        return new Seance(seance);
    },
};