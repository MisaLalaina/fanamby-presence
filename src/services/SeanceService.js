import { BASE_URL } from './config';

const parseTime = (timeStr) => {
  if (!timeStr) return null;
  const [hour, minute] = timeStr.split(':').map(Number);
  return `${hour.toString().padStart(2, '0')}:${minute.toString().padStart(2, '0')}:00`;
};

export default {
  async getAllSeances() {
    try {
      const response = await fetch(`${BASE_URL}/seances`);
      if (!response.ok) {
        throw new Error('Failed to fetch seances');
      }
      const data = await response.json();

      if (data.returnCode !== 1) {
        throw new Error(data.message || 'Error retrieving seances');
      }

      return data.data.content;
    } catch (error) {
      console.error('Error fetching seances:', error);
      throw error;
    }
  },

  async createSeance(seanceData) {
    try {
      const payload = {
        idtypeseanceTypeseance: { idtypeseance: seanceData.idTypeSeance },
        idclubClub: { idclub: seanceData.clubId },
        dateseance: seanceData.dateSeance,
        heuredebut: parseTime(seanceData.heureDebut),
        heurefin: parseTime(seanceData.heureFin),
        lieu: seanceData.lieu,
        objectif: seanceData.objectif || '',
        bilan: seanceData.bilan || '',
        idstatutseanceStatutseance: { idstatutseance: seanceData.statutId }
      };

      const response = await fetch(`${BASE_URL}/seances`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload)
      });

      if (!response.ok) throw new Error('Failed to create seance');
      const data = await response.json();

      if (data.returnCode !== 1) {
        throw new Error(data.message || 'Error creating seance');
      }

      return data.data;
    } catch (error) {
      console.error('Error creating seance:', error);
      throw error;
    }
  },

  // Mbola tsy mandeha
  async updateSeance(id, seanceData) {
    try {
      const payload = {
        idseance: id,
        idtypeseanceTypeseance: { idtypeseance: seanceData.idTypeSeance },
        idclubClub: { idclub: seanceData.clubId },
        dateseance: seanceData.dateSeance,
        heuredebut: parseTime(seanceData.heureDebut),
        heurefin: parseTime(seanceData.heureFin),
        lieu: seanceData.lieu,
        objectif: seanceData.objectif || '',
        bilan: seanceData.bilan || '',
        idstatutseanceStatutseance: { idstatutseance: seanceData.statutId }
      };
  
      const response = await fetch(`${BASE_URL}/seances/${id}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload)
      });
  
      if (!response.ok) throw new Error('Failed to update seance');
      const data = await response.json();
  
      if (data.returnCode !== 1) {
        throw new Error(data.message || 'Error updating seance');
      }
  
      return data.data;
    } catch (error) {
      console.error('Error updating seance:', error);
      throw error;
    }
  },
  
  async deleteSeance(id) {
    try {
      const response = await fetch(`${BASE_URL}/seances/${id}`, {
        method: 'DELETE'
      });
  
      if (!response.ok) throw new Error('Failed to delete seance');
      const data = await response.json();
  
      if (data.returnCode !== 1) {
        throw new Error(data.message || 'Error deleting seance');
      }
  
      return data.data;
    } catch (error) {
      console.error('Error deleting seance:', error);
      throw error;
    }
  },
  
  async getSeanceById(id) {
    try {
      const response = await fetch(`${BASE_URL}/seances/${id}`);
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      const data = await response.json();

      if (data.returnCode !== 1) {
        throw new Error(data.message || 'Error retrieving seance');
      }

      // Formatage des données de la séance pour une utilisation plus facile
      const seance = data.data;
      return {
        idSeance: seance.idseance,
        idTypeSeance: seance.idtypeseanceTypeseance?.idtypeseance,
        clubId: seance.idclubClub?.idclub,
        dateSeance: seance.dateseance,
        heureDebut: seance.heuredebut?.substring(0, 5), // Format HH:mm
        heureFin: seance.heurefin?.substring(0, 5),     // Format HH:mm
        lieu: seance.lieu,
        objectif: seance.objectif,
        bilan: seance.bilan,
        statutId: seance.idstatutseanceStatutseance?.idstatutseance
      };
    } catch (error) {
      console.error(`Error fetching seance with ID ${id}:`, error);
      throw error;
    }
  }
};
