<script setup>
  import { ref, onMounted, computed } from 'vue';
  import SeanceService from '@/services/SeanceService';
  import TypeSeanceService from '@/services/TypeSeanceService';
  import { Seance } from '@/models/seance';
  import { TypeSeance } from '@/models/typeSeance';

  // Data
  const typesSeance = ref([]);
  const seances = ref([]);
  const filteredSeances = ref([]);
  const showForm = ref(false);
  const filterType = ref('');
  const filterDate = ref('');
  const isLoading = ref(false);
  const error = ref(null);
  const clubId = ref(1); 
  const statutId = ref(1); 

  // Form data
  const currentSeance = ref(Seance.getDefaultSeance());

  // Fetch all necessary data
  const fetchInitialData = async () => {
    isLoading.value = true;
    error.value = null;
    
    try {
      // Fetch type seances first since they're working
      const typeSeancesData = await TypeSeanceService.getAllTypeSeances();
      typesSeance.value = TypeSeance.formatTypeSeances(typeSeancesData);
      
      // Then fetch seances
      const seancesData = await SeanceService.getAllSeances();
      seances.value = Seance.formatSeances(seancesData);
      filteredSeances.value = [...seances.value];
      
    } catch (err) {
      error.value = err.message || 'Erreur lors du chargement des données';
      console.error('Fetch error:', err);
      // Show error in UI (you'll see it since error ref is bound)
    } finally {
      isLoading.value = false;
    }
  };

  // Filter function remains the same
  const filterSeances = () => {
    filteredSeances.value = seances.value.filter(seance => {
      const typeMatch = !filterType.value || seance.idTypeSeance == filterType.value;
      const dateMatch = !filterDate.value || seance.dateSeance === filterDate.value;
      return typeMatch && dateMatch;
    });
  };

  // Form functions
  const editSeance = (seance) => {
    currentSeance.value = { ...seance };
    showForm.value = true;
  };

  const confirmDelete = async (id) => {
    if (confirm('Voulez-vous vraiment supprimer cette séance ?')) {
      try {
        await SeanceService.deleteSeance(id);
        await fetchInitialData(); // Refresh data
      } catch (err) {
        error.value = err.message || 'Erreur lors de la suppression';
        console.error(err);
      }
    }
  };

  // Helper functions
  const getTypeName = (id) => {
    const type = typesSeance.value.find(t => t.idTypeSeance === id);
    return type ? type.libelle : 'Inconnu';
  };

  const formatDate = (dateStr) => {
    const options = { year: 'numeric', month: 'short', day: 'numeric' };
    return new Date(dateStr).toLocaleDateString('fr-FR', options);
  };

  const truncateText = (text, length) => {
    if (!text) return '';
    return text.length > length ? text.substring(0, length) + '...' : text;
  };

  // Initialization
  onMounted(() => {
    fetchInitialData();
  });
</script>


<template>
  <div class="seance-list-container">
    <h1>Liste des séances</h1>
    <div class="filter-controls">
      <select v-model="filterType" @change="filterSeances">
        <option value="">Tous les types</option>
        <option v-for="type in typesSeance" :key="type.idTypeSeance" :value="type.idTypeSeance">
          {{ type.libelle }}
        </option>
      </select>
      <input type="date" v-model="filterDate" @change="filterSeances" placeholder="Filtrer par date">
    </div>
    <table>
      <thead>
        <tr>
          <th>Type</th>
          <th>Date</th>
          <th>Heures</th>
          <th>Lieu</th>
          <th>Objectif</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="seance in filteredSeances" :key="seance.idSeance">
          <td>{{ getTypeName(seance.idTypeSeance) }}</td>
          <td>{{ formatDate(seance.dateSeance) }}</td>
          <td>{{ seance.heureDebut }} - {{ seance.heureFin }}</td>
          <td>{{ seance.lieu }}</td>
          <td>{{ truncateText(seance.objectif, 30) }}</td>
          <td>
            <button @click="editSeance(seance)" class="btn-edit">✏️</button>
            <button @click="confirmDelete(seance.idSeance)" class="btn-delete">🗑️</button>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<style scoped>
.seance-list-container {
  padding: 20px;
  max-width: 1200px;
  margin: 0 auto;
}

.filter-controls {
  display: flex;
  gap: 15px;
  margin-bottom: 15px;
}

.filter-controls select,
.filter-controls input {
  padding: 8px;
  border: 1px solid #ddd;
  border-radius: 4px;
}

table {
  width: 100%;
  border-collapse: collapse;
}

th, td {
  padding: 12px 15px;
  text-align: left;
  border-bottom: 1px solid #ddd;
}

th {
  background-color: #f2f2f2;
}

tr:hover {
  background-color: #f5f5f5;
}

.btn-edit, .btn-delete {
  border: none;
  background: none;
  cursor: pointer;
  font-size: 16px;
  padding: 5px;
}

.btn-edit {
  color: #3498db;
}

.btn-delete {
  color: #e74c3c;
}
</style>
