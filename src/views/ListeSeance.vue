<script setup>
  import { ref, onMounted, computed } from 'vue';
  import SeanceService from '@/services/SeanceService';
  import TypeSeanceService from '@/services/TypeSeanceService';
  import { Seance } from '@/models/seance';
  import { TypeSeance } from '@/models/typeSeance';
  import SeanceEdit from './SeanceEdit.vue'; // Assurez-vous d'avoir le bon chemin

  const currentEditId = ref(null); // Stocke l'ID de la séance à modifier
// Form functions
const editSeance = (seance) => {
    currentEditId.value = seance.idSeance; // Définit l'ID pour afficher le formulaire d'édition
};

const handleCancel = () => {
    currentEditId.value = null; // Masque le formulaire
};

const handleUpdate = () => {
    currentEditId.value = null; // Masque le formulaire
    fetchInitialData(); // Recharge les données mises à jour
};

  // Data
  const typesSeance = ref([]);
  const seances = ref([]);
  const filteredSeances = ref([]);
  const showForm = ref(false);
  const filterType = ref('');
  const filterDate = ref('');
  const isLoading = ref(false);
  const error = ref(null);

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
  <SeanceEdit 
    v-if="currentEditId"
    :seanceId="currentEditId"
    @updated="handleUpdate"
    @cancel="handleCancel"
  />

  <div v-else class="seance-list-container">
    <div class="header-controls">
      <h1>Liste des séances</h1>
      <button class="btn-primary" disabled>
        + Ajouter une Séance
      </button>
    </div>

    <div class="filter-controls">
      <select v-model="filterType" @change="filterSeances" class="filter-select">
        <option value="">Tous les types</option>
        <option v-for="type in typesSeance" :key="type.idTypeSeance" :value="type.idTypeSeance">
          {{ type.libelle }}
        </option>
      </select>
      <input type="date" v-model="filterDate" @change="filterSeances" class="filter-input" placeholder="Filtrer par date">
    </div>

    <div v-if="isLoading" class="loading-message">Chargement des séances... 🔄</div>
    <div v-else-if="error" class="error-message">Erreur : {{ error }}</div>
    <div v-else-if="filteredSeances.length === 0" class="empty-message">
      Aucune séance trouvée avec les filtres actuels.
    </div>

    <table v-else>
      <thead>
        <tr>
          <th>Type</th>
          <th>Date</th>
          <th>Heures</th>
          <th>Lieu</th>
          <th>Status</th>
          <th>Objectif</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <tr 
          v-for="seance in filteredSeances" 
          :key="seance.idSeance"
          :class="{ 'status-Planned-row': seance.statut === 'Planifié' }"
        >
          <td>{{ getTypeName(seance.idTypeSeance) }}</td>
          <td>{{ formatDate(seance.dateSeance) }}</td>
          <td>{{ seance.heureDebut }} - {{ seance.heureFin }}</td>
          <td>{{ seance.lieu }}</td>
          <td>
            <span :class="['status-badge', 'status-' + seance.statut.replace('é', 'e')]">
              {{ seance.statut }}
            </span>
          </td>
          <td>{{ truncateText(seance.objectif, 30) }}</td>
          <td>
            <button @click="editSeance(seance)" class="btn-action btn-edit" title="Modifier">✏️</button>
            <button @click="confirmDelete(seance.idSeance)" class="btn-action btn-delete" title="Supprimer">🗑️</button>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<style scoped>
.seance-list-container {
  max-width: 1500px;
  margin: 0 auto;
  padding: 20px; /* Ajout d'un padding pour un meilleur espacement général */
  font-family: Arial, sans-serif;
}

h1 {
  color: #3498db;
  margin-bottom: 20px;
}

/* Contrôles du haut (Titre et bouton) */
.header-controls {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
}

/* Bouton d'action principal */
.btn-primary {
    background-color: #2ecc71; /* Vert pour une action positive (créer) */
    color: white;
    border: none;
    padding: 10px 20px;
    border-radius: 5px;
    cursor: pointer;
    font-weight: bold;
    transition: background-color 0.3s;
}

.btn-primary:hover {
    background-color: #27ae60;
}


/* Filtres */
.filter-controls {
  display: flex;
  gap: 15px;
  margin-bottom: 20px;
}

.filter-select,
.filter-input {
  padding: 10px;
  border: 1px solid #ccc;
  border-radius: 5px;
  min-width: 150px;
  appearance: none; /* Améliore l'apparence des select */
}

/* Affichage des états (Chargement/Erreur/Vide) */
.loading-message, .error-message, .empty-message {
    padding: 15px;
    margin-top: 10px;
    border-radius: 5px;
    font-weight: bold;
}

.loading-message {
    background-color: #f9f9e8;
    color: #8b8b00;
}

.error-message {
    background-color: #f8d7da;
    color: #721c24;
    border: 1px solid #f5c6cb;
}

.empty-message {
    text-align: center;
    color: #7f8c8d;
    padding: 30px;
    border: 1px dashed #ccc;
}


/* Tableau */
table {
  width: 100%;
  border-collapse: collapse;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); /* Petite ombre pour un effet de carte */
  border-radius: 8px;
  overflow: hidden; /* Important pour que l'ombre et le border-radius s'appliquent */
}

th, td {
  padding: 15px 15px;
  text-align: left;
  border-bottom: 1px solid #eee; /* Lignes plus légères */
}

th {
  background-color: #f2f6f9; /* Légèrement plus clair */
  color: #2c3e50;
  font-weight: 600;
  text-transform: uppercase;
  font-size: 0.9em;
}

/* Ligne "Planifié" */
.status-Planned-row {
    background-color: #fffacd; /* Jaune pâle pour la ligne entière */
}

tr:hover:not(.status-Planned-row) {
  background-color: #f5f5f5;
}

/* Badges de statut */
.status-badge {
    display: inline-block;
    padding: 4px 10px;
    border-radius: 12px; /* Pill shape */
    font-size: 0.8em;
    font-weight: bold;
    text-transform: uppercase;
    min-width: 80px; /* Taille minimale pour l'uniformité */
    text-align: center;
}

/* Couleurs spécifiques aux statuts */
.status-Planifie {
    background-color: #f1c40f; /* Jaune */
    color: #8e44ad; /* Texte violet foncé pour un bon contraste */
}

.status-Effectue {
    background-color: #2ecc71; /* Vert */
    color: white;
}

.status-Annule {
    background-color: #e74c3c; /* Rouge */
    color: white;
}

.status-EnCours {
    background-color: #3498db; /* Bleu */
    color: white;
}

/* Boutons d'action */
.btn-action {
  border: none;
  background: none;
  cursor: pointer;
  font-size: 18px;
  padding: 5px 8px;
  transition: transform 0.1s;
}

.btn-action:hover {
    transform: scale(1.1);
}

.btn-edit {
  color: #3498db;
}

.btn-delete {
  color: #e74c3c;
}
</style>
