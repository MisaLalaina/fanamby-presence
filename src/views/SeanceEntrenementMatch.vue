<template>
  <div class="seance-container">
    <h2>Gestion des Séances et Matchs</h2>
    
    <!-- Bouton pour ajouter une nouvelle séance -->
    <button @click="showAddForm" class="btn-add">+ Ajouter Séance/Match</button>

    <!-- Formulaire d'ajout/modification -->
    <div v-if="showForm" class="form-container">
      <h3>{{ currentSeance.idSeance ? 'Modifier' : 'Ajouter' }} Séance/Match</h3>
      <form @submit.prevent="submitForm">
        <div class="form-row">
          <div class="form-group">
            <label>Type:</label>
            <select v-model="currentSeance.idTypeSeance" required>
              <option v-for="type in typesSeance" :key="type.idTypeSeance" :value="type.idTypeSeance">
                {{ type.libelle }}
              </option>
            </select>
          </div>

          <div class="form-group">
            <label>Date:</label>
            <input type="date" v-model="currentSeance.dateSeance" required>
          </div>
        </div>

        <div class="form-row">
          <div class="form-group">
            <label>Heure début:</label>
            <input type="time" v-model="currentSeance.heureDebut" required>
          </div>

          <div class="form-group">
            <label>Heure fin:</label>
            <input type="time" v-model="currentSeance.heureFin" required>
          </div>
        </div>

        <div class="form-group">
          <label>Lieu:</label>
          <input type="text" v-model="currentSeance.lieu" required>
        </div>

        <div class="form-group">
          <label>Objectif:</label>
          <textarea v-model="currentSeance.objectif"></textarea>
        </div>

        <div class="form-group">
          <label>Bilan:</label>
          <textarea v-model="currentSeance.bilan"></textarea>
        </div>

        <div class="form-actions">
          <button type="button" @click="cancelForm" class="btn-cancel">Annuler</button>
          <button type="submit" class="btn-submit">
            {{ currentSeance.idSeance ? 'Modifier' : 'Ajouter' }}
          </button>
        </div>
      </form>
    </div>

    <!-- Liste des séances -->
    <div class="seance-list">
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
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue';

// Données
const typesSeance = ref([
  { idTypeSeance: 1, libelle: 'Entrainement', description: 'Séance d entraînement régulière' },
  { idTypeSeance: 2, libelle: 'Match amical', description: 'Match sans enjeu compétitif' },
  { idTypeSeance: 3, libelle: 'Match officiel', description: 'Match de championnat ou coupe' },
  { idTypeSeance: 4, libelle: 'Seance physique', description: 'Séance axée sur la condition physique' },
  { idTypeSeance: 5, libelle: 'Seance tactique', description: 'Séance axée sur la tactique d équipe' }
]);

const seances = ref([]);
const filteredSeances = ref([]);
const showForm = ref(false);
const filterType = ref('');
const filterDate = ref('');

// Données du formulaire
const currentSeance = ref({
  idSeance: null,
  idTypeSeance: 1,
  dateSeance: '',
  heureDebut: '',
  heureFin: '',
  lieu: '',
  objectif: '',
  bilan: ''
});

// Fonctions
const fetchSeances = async () => {
  // Simuler un appel API
  seances.value = [
    {
      idSeance: 1,
      idTypeSeance: 1,
      dateSeance: '2023-10-15',
      heureDebut: '08:00',
      heureFin: '10:00',
      lieu: 'Terrain principal',
      objectif: 'Amélioration des passes et du jeu collectif',
      bilan: 'Bonne séance, participation active de tous'
    },
    {
      idSeance: 2,
      idTypeSeance: 2,
      dateSeance: '2023-10-20',
      heureDebut: '15:00',
      heureFin: '17:00',
      lieu: 'Stade municipal',
      objectif: 'Tester de nouvelles combinaisons offensives',
      bilan: 'Match équilibré, nouvelles stratégies efficaces'
    }
  ];
  filteredSeances.value = [...seances.value];
};

const filterSeances = () => {
  filteredSeances.value = seances.value.filter(seance => {
    const typeMatch = !filterType.value || seance.idTypeSeance == filterType.value;
    const dateMatch = !filterDate.value || seance.dateSeance === filterDate.value;
    return typeMatch && dateMatch;
  });
};

const showAddForm = () => {
  currentSeance.value = {
    idSeance: null,
    idTypeSeance: 1,
    dateSeance: '',
    heureDebut: '',
    heureFin: '',
    lieu: '',
    objectif: '',
    bilan: ''
  };
  showForm.value = true;
};

const editSeance = (seance) => {
  currentSeance.value = { ...seance };
  showForm.value = true;
};

const cancelForm = () => {
  showForm.value = false;
};

const submitForm = () => {
  if (currentSeance.value.idSeance) {
    // Mise à jour
    const index = seances.value.findIndex(s => s.idSeance === currentSeance.value.idSeance);
    if (index !== -1) {
      seances.value[index] = { ...currentSeance.value };
    }
  } else {
    // Ajout
    const newId = Math.max(...seances.value.map(s => s.idSeance), 0) + 1;
    seances.value.push({
      ...currentSeance.value,
      idSeance: newId
    });
  }
  
  filterSeances();
  showForm.value = false;
};

const confirmDelete = (id) => {
  if (confirm('Voulez-vous vraiment supprimer cette séance ?')) {
    seances.value = seances.value.filter(s => s.idSeance !== id);
    filterSeances();
  }
};

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

// Initialisation
onMounted(() => {
  fetchSeances();
});
</script>

<style scoped>
.seance-container {
  padding: 20px;
  max-width: 1200px;
  margin: 0 auto;
}

.btn-add {
  background-color: #3498db;
  color: white;
  padding: 10px 15px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  margin-bottom: 20px;
}

.form-container {
  background-color: #f5f5f5;
  padding: 20px;
  border-radius: 8px;
  margin-bottom: 20px;
}

.form-row {
  display: flex;
  gap: 20px;
  margin-bottom: 15px;
}

.form-group {
  flex: 1;
  margin-bottom: 15px;
}

.form-group label {
  display: block;
  margin-bottom: 5px;
  font-weight: bold;
}

.form-group input,
.form-group select,
.form-group textarea {
  width: 100%;
  padding: 8px;
  border: 1px solid #ddd;
  border-radius: 4px;
}

.form-group textarea {
  min-height: 80px;
}

.form-actions {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
}

.btn-submit {
  background-color: #2ecc71;
  color: white;
  padding: 8px 15px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.btn-cancel {
  background-color: #e74c3c;
  color: white;
  padding: 8px 15px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
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