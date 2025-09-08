import { BASE_URL } from './config';

export default {
  async getAllTypeSeances() {
    try {
      const response = await fetch(`${BASE_URL}/typeseances`);
      if (!response.ok) {
        throw new Error('Failed to fetch type seances');
      }
      const data = await response.json();
      
      if (data.returnCode !== 1) {
        throw new Error(data.message || 'Error retrieving type seances');
      }
      
      return data.data.content;
    } catch (error) {
      console.error('Error fetching type seances:', error);
      throw error;
    }
  },

  async getTypeSeanceById(id) {
    try {
      const response = await fetch(`${BASE_URL}/typeseances/${id}`);
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      const data = await response.json();

      if (data.returnCode !== 1) {
        throw new Error(data.message || 'Error retrieving type seance');
      }

      // Retourne directement l'objet typeSeance
      return data.data;
      
    } catch (error) {
      console.error(`Error fetching type seance with ID ${id}:`, error);
      throw error;
    }
  }
};