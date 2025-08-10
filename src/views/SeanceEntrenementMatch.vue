<script setup>
import { ref, computed, onMounted } from 'vue';
import { useRouter } from 'vue-router';

const router = useRouter();

// Données
const seances = ref([]);
const typesSeance = ref([]);
const loading = ref(true);
const selectedType = ref('');
const selectedDate = ref('');
const showModal = ref(false);
const seanceToDelete = ref(null);
const sortField = ref('dateSeance');
const sortDirection = ref('desc');

// Chargement initial
onMounted(async () => {
  try {
    // Simulation d'appel API
    await fetchTypesSeance();
    await fetchSeances();
  } catch (error) {
    console.error("Erreur de chargement:", error);
  } finally {
    loading.value = false;
  }
});

// Fonctions API (simulées)
const fetchTypesSeance = async () => {
  // Simule un appel API
  typesSeance.value = [
    { idTypeSeance: 1, libelle: 'Entrainement', description: 'Séance d entraînement régulière' },
    { idTypeSeance: 2, libelle: 'Match amical', description: 'Match sans enjeu compétitif' },
    { idTypeSeance: 3, libelle: 'Match officiel', description: 'Match de championnat ou coupe' },
    { idTypeSeance: 4, libelle: 'Seance physique', description: 'Séance axée sur la condition physique' },
    { idTypeSeance: 5, libelle: 'Seance tactique', description: 'Séance axée sur la tactique d équipe' }
  ];
};

const fetchSeances = async () => {
  // Simule un appel API
  seances.value = [
    { 
      idSeance: 1, 
      dateSeance: '2023-06-15', 
      heureDebut: '18:00', 
      heureFin: '20:00',
      idTypeSeance: 1,
      lieu: 'Terrain principal',
      objectif: 'Amélioration des passes',
      joueursPresents: [1, 2, 3]
    },
    // Ajoutez d'autres séances de test...
  ];
};

// Fonctions utilitaires
const formatDate = (dateString) => {
  const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
  return new Date(dateString).toLocaleDateString('fr-FR', options);
};

const getTypeLabel = (idType) => {
  const type = typesSeance.value.find(t => t.idTypeSeance === idType);
  return type ? type.libelle : 'Inconnu';
};

const getTypeColor = (idType) => {
  const colors = {
    1: '#3498db',  // Entrainement
    2: '#2ecc71',  // Match amical
    3: '#e74c3c',  // Match officiel
    4: '#f39c12',  // Seance physique
    5: '#9b59b6'   // Seance tactique
  };
  return colors[idType] || '#95a5a6';
};

// Filtrage et tri
const filteredSeances = computed(() => {
  let result = [...seances.value];
  
  // Filtrage par type
  if (selectedType.value) {
    result = result.filter(s => s.idTypeSeance == selectedType.value);
  }
  
  // Filtrage par date
  if (selectedDate.value) {
    result = result.filter(s => s.dateSeance === selectedDate.value);
  }
  
  // Tri
  result.sort((a, b) => {
    const valA = a[sortField.value];
    const valB = b[sortField.value];
    
    if (valA < valB) return sortDirection.value === 'asc' ? -1 : 1;
    if (valA > valB) return sortDirection.value === 'asc' ? 1 : -1;
    return 0;
  });
  
  return result;
});

const sortSeances = (field) => {
  if (sortField.value === field) {
    sortDirection.value = sortDirection.value === 'asc' ? 'desc' : 'asc';
  } else {
    sortField.value = field;
    sortDirection.value = 'asc';
  }
};

// Actions
const editSeance = (id) => {
  router.push(`/seances/editer/${id}`);
};

const confirmDelete = (id) => {
  seanceToDelete.value = id;
  showModal.value = true;
};

const deleteSeance = async () => {
  try {
    // Simule une suppression API
    seances.value = seances.value.filter(s => s.idSeance !== seanceToDelete.value);
    showModal.value = false;
  } catch (error) {
    console.error("Erreur de suppression:", error);
  }
};

const filterSeances = () => {
  // Le computed filteredSeances se mettra à jour automatiquement
};
</script>

<template>
  <div class="seances-container">
    <h1>GESTION DES SÉANCES</h1>
    
    <div class="controls">
      <router-link to="/seances/ajouter" class="btn-add">
        <i class="fas fa-plus"></i> Nouvelle Séance
      </router-link>
      
      <div class="filter-group">
        <select v-model="selectedType" @change="filterSeances">
          <option value="">Tous les types</option>
          <option v-for="type in typesSeance" :value="type.idTypeSeance">{{ type.libelle }}</option>
        </select>
        
        <input 
          type="date" 
          v-model="selectedDate" 
          @change="filterSeances"
          placeholder="Filtrer par date"
        >
      </div>
    </div>

    <div v-if="loading" class="loading">
      <i class="fas fa-spinner fa-spin"></i> Chargement...
    </div>

    <div v-else>
      <table class="seances-table">
        <thead>
          <tr>
            <th @click="sortSeances('dateSeance')">Date <i class="fas fa-sort"></i></th>
            <th @click="sortSeances('heureDebut')">Heure <i class="fas fa-sort"></i></th>
            <th>Type</th>
            <th>Lieu</th>
            <th>Objectif</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="seance in filteredSeances" :key="seance.idSeance">
            <td>{{ formatDate(seance.dateSeance) }}</td>
            <td>{{ seance.heureDebut }} - {{ seance.heureFin }}</td>
            <td>
              <span class="type-badge" :style="{ backgroundColor: getTypeColor(seance.idTypeSeance) }">
                {{ getTypeLabel(seance.idTypeSeance) }}
              </span>
            </td>
            <td>{{ seance.lieu }}</td>
            <td>{{ seance.objectif }}</td>
            <td class="actions">
              <button @click="editSeance(seance.idSeance)" class="btn-edit">
                <i class="fas fa-edit"></i>
              </button>
              <button @click="confirmDelete(seance.idSeance)" class="btn-delete">
                <i class="fas fa-trash"></i>
              </button>
            </td>
          </tr>
        </tbody>
      </table>

      <div v-if="filteredSeances.length === 0" class="no-results">
        Aucune séance trouvée
      </div>
    </div>

    <!-- Modal de confirmation -->
    <div v-if="showModal" class="modal">
      <div class="modal-content">
        <p>Êtes-vous sûr de vouloir supprimer cette séance ?</p>
        <div class="modal-actions">
          <button @click="deleteSeance" class="btn-confirm">Confirmer</button>
          <button @click="showModal = false" class="btn-cancel">Annuler</button>
        </div>
      </div>
    </div>
  </div>
</template>



<style scoped>
.seances-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

h1 {
  text-align: center;
  color: #2c3e50;
  margin-bottom: 30px;
}

.controls {
  display: flex;
  justify-content: space-between;
  margin-bottom: 20px;
  flex-wrap: wrap;
  gap: 15px;
}

.btn-add {
  padding: 10px 15px;
  background-color: #2ecc71;
  color: white;
  border: none;
  border-radius: 4px;
  text-decoration: none;
  display: flex;
  align-items: center;
  gap: 8px;
}

.filter-group {
  display: flex;
  gap: 10px;
}

.filter-group select, 
.filter-group input {
  padding: 8px 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
}

.seances-table {
  width: 100%;
  border-collapse: collapse;
  margin-top: 20px;
}

.seances-table th, 
.seances-table td {
  padding: 12px 15px;
  text-align: left;
  border-bottom: 1px solid #ddd;
}

.seances-table th {
  background-color: #f8f9fa;
  cursor: pointer;
  user-select: none;
}

.seances-table th:hover {
  background-color: #e9ecef;
}

.type-badge {
  padding: 4px 8px;
  border-radius: 12px;
  color: white;
  font-size: 0.8rem;
  font-weight: bold;
}

.actions {
  display: flex;
  gap: 8px;
}

.btn-edit, .btn-delete {
  padding: 6px 10px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.btn-edit {
  background-color: #3498db;
  color: white;
}

.btn-delete {
  background-color: #e74c3c;
  color: white;
}

.loading, .no-results {
  text-align: center;
  padding: 20px;
  color: #7f8c8d;
}

/* Modal */
.modal {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0,0,0,0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.modal-content {
  background-color: white;
  padding: 20px;
  border-radius: 8px;
  max-width: 400px;
  width: 90%;
}

.modal-actions {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  margin-top: 20px;
}

.btn-confirm, .btn-cancel {
  padding: 8px 16px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.btn-confirm {
  background-color: #e74c3c;
  color: white;
}

.btn-cancel {
  background-color: #95a5a6;
  color: white;
}

@media (max-width: 768px) {
  .controls {
    flex-direction: column;
  }
  
  .filter-group {
    width: 100%;
  }
  
  .seances-table {
    display: block;
    overflow-x: auto;
  }
}
</style>