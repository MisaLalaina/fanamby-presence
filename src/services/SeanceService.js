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
  },

  // Fonctions pour modifier la liste des séances
  async updateSeancesList(seancesData) {
    try {
      const payload = seancesData.map(seance => ({
        idseance: seance.idSeance,
        idtypeseanceTypeseance: { idtypeseance: seance.idTypeSeance },
        idclubClub: { idclub: seance.clubId },
        dateseance: seance.dateSeance,
        heuredebut: parseTime(seance.heureDebut),
        heurefin: parseTime(seance.heureFin),
        lieu: seance.lieu,
        objectif: seance.objectif || '',
        bilan: seance.bilan || '',
        idstatutseanceStatutseance: { idstatutseance: seance.statutId }
      }));

      const response = await fetch(`${BASE_URL}/seances/batch`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload)
      });

      if (!response.ok) throw new Error('Failed to update seances list');
      const data = await response.json();

      if (data.returnCode !== 1) {
        throw new Error(data.message || 'Error updating seances list');
      }

      return data.data;
    } catch (error) {
      console.error('Error updating seances list:', error);
      throw error;
    }
  },

  async updateMultipleSeances(updates) {
    try {
      const results = {
        successful: [],
        failed: []
      };

      for (const update of updates) {
        try {
          const updatedSeance = await this.updateSeance(update.id, update.data);
          results.successful.push({
            id: update.id,
            data: updatedSeance
          });
        } catch (error) {
          results.failed.push({
            id: update.id,
            error: error.message
          });
        }
      }

      return results;
    } catch (error) {
      console.error('Error in batch update:', error);
      throw error;
    }
  },

  async bulkUpdateSeances(seancesData) {
    try {
      const payload = seancesData.map(seance => ({
        idseance: seance.idSeance,
        idtypeseanceTypeseance: { idtypeseance: seance.idTypeSeance },
        idclubClub: { idclub: seance.clubId },
        dateseance: seance.dateSeance,
        heuredebut: parseTime(seance.heureDebut),
        heurefin: parseTime(seance.heureFin),
        lieu: seance.lieu,
        objectif: seance.objectif || '',
        bilan: seance.bilan || '',
        idstatutseanceStatutseance: { idstatutseance: seance.statutId }
      }));

      const response = await fetch(`${BASE_URL}/seances/bulk-update`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload)
      });

      if (!response.ok) throw new Error('Failed to bulk update seances');
      const data = await response.json();

      if (data.returnCode !== 1) {
        throw new Error(data.message || 'Error in bulk update seances');
      }

      return data.data;
    } catch (error) {
      console.error('Error bulk updating seances:', error);
      throw error;
    }
  },

  async reorderSeances(seanceIds) {
    try {
      const payload = seanceIds.map((id, index) => ({
        idseance: id,
        ordre: index + 1
      }));

      const response = await fetch(`${BASE_URL}/seances/reorder`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload)
      });

      if (!response.ok) throw new Error('Failed to reorder seances');
      const data = await response.json();

      if (data.returnCode !== 1) {
        throw new Error(data.message || 'Error reordering seances');
      }

      return data.data;
    } catch (error) {
      console.error('Error reordering seances:', error);
      throw error;
    }
  },

  async bulkDeleteSeances(ids) {
    try {
      const response = await fetch(`${BASE_URL}/seances/bulk-delete`, {
        method: 'DELETE',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ ids })
      });

      if (!response.ok) throw new Error('Failed to delete seances');
      const data = await response.json();

      if (data.returnCode !== 1) {
        throw new Error(data.message || 'Error deleting seances');
      }

      return data.data;
    } catch (error) {
      console.error('Error bulk deleting seances:', error);
      throw error;
    }
  },

  async filterSeances(filters) {
    try {
      const queryParams = new URLSearchParams();
      
      Object.keys(filters).forEach(key => {
        if (filters[key] !== null && filters[key] !== undefined && filters[key] !== '') {
          queryParams.append(key, filters[key]);
        }
      });

      const response = await fetch(`${BASE_URL}/seances/filter?${queryParams}`);
      if (!response.ok) {
        throw new Error('Failed to filter seances');
      }
      const data = await response.json();

      if (data.returnCode !== 1) {
        throw new Error(data.message || 'Error filtering seances');
      }

      return data.data.content;
    } catch (error) {
      console.error('Error filtering seances:', error);
      throw error;
    }
  },

  async searchSeances(searchTerm) {
    try {
      const response = await fetch(`${BASE_URL}/seances/search?q=${encodeURIComponent(searchTerm)}`);
      if (!response.ok) {
        throw new Error('Failed to search seances');
      }
      const data = await response.json();

      if (data.returnCode !== 1) {
        throw new Error(data.message || 'Error searching seances');
      }

      return data.data.content;
    } catch (error) {
      console.error('Error searching seances:', error);
      throw error;
    }
  },

  async duplicateSeance(id, newDate = null) {
    try {
      const originalSeance = await this.getSeanceById(id);
      
      const duplicatedSeance = {
        ...originalSeance,
        dateSeance: newDate || originalSeance.dateSeance,
        idSeance: null // Pour créer une nouvelle séance
      };

      return await this.createSeance(duplicatedSeance);
    } catch (error) {
      console.error('Error duplicating seance:', error);
      throw error;
    }
  },

  async updateSeancesStatus(ids, newStatusId) {
    try {
      const updates = ids.map(id => ({
        id: id,
        data: { statutId: newStatusId }
      }));

      return await this.updateMultipleSeances(updates);
    } catch (error) {
      console.error('Error updating seances status:', error);
      throw error;
    }
  }
};