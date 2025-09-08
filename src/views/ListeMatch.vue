<script setup>
  import { ref, computed, onMounted } from 'vue';
  import { getAllMatches } from '@/services/MatchFootService.js';

  // Données
  const matches = ref([]);
  const competitions = ref([]);
  const filterCompetition = ref('');
  const filterLocation = ref('');
  const filterDateFrom = ref('');
  const filterDateTo = ref('');
  const currentPage = ref(1);
  const itemsPerPage = 10;

  // Récupération des matchs
  const fetchMatches = async () => {
    matches.value = await getAllMatches();
    // Extraire les compétitions uniques
    competitions.value = [...new Set(matches.value.map(m => m.competition))];
  };

  // Filtrage et pagination
  const filteredMatches = computed(() => {
    let result = matches.value;

    if (filterCompetition.value) {
      result = result.filter(m => m.competition === filterCompetition.value);
    }

    if (filterLocation.value) {
      const isHome = filterLocation.value === 'domicile';
      result = result.filter(m => m.domicile === isHome);
    }

    if (filterDateFrom.value) {
      result = result.filter(m => m.dateMatch >= filterDateFrom.value);
    }

    if (filterDateTo.value) {
      result = result.filter(m => m.dateMatch <= filterDateTo.value);
    }

    // Pagination
    const start = (currentPage.value - 1) * itemsPerPage;
    return result.slice(start, start + itemsPerPage);
  });

  const totalPages = computed(() => {
    return Math.ceil(matches.value.length / itemsPerPage);
  });

  // Fonctions utilitaires
  const formatDate = (dateStr) => {
    const options = { year: 'numeric', month: 'short', day: 'numeric' };
    return new Date(dateStr).toLocaleDateString('fr-FR', options);
  };

  const applyFilters = () => {
    currentPage.value = 1; // Reset à la première page quand les filtres changent
  };

  const prevPage = () => {
    if (currentPage.value > 1) currentPage.value--;
  };

  const nextPage = () => {
    if (currentPage.value < totalPages.value) currentPage.value++;
  };

  const confirmDelete = (id) => {
    if (confirm('Voulez-vous vraiment supprimer ce match ?')) {
      // Simuler la suppression - remplacer par un appel API
      matches.value = matches.value.filter(m => m.idMatch !== id);
    }
  };

  // Initialisation
  onMounted(async () => {
    try {
     await fetchMatches();
    } catch (error) {
      console.error('Failed to load matches:', error);
    }
  });
</script>




<template>
  <div class="match-container">
    <div class="header">
      <h2>Liste des Matchs</h2>
      <router-link to="/match/ajouter" class="btn-add">
        <i class="fas fa-plus"></i> Ajouter un match
      </router-link>
    </div>

    <!-- Filtres -->
    <div class="filters">
      <div class="filter-group">
        <label>Compétition :</label>
        <select v-model="filterCompetition" @change="applyFilters">
          <option value="">Toutes</option>
          <option v-for="comp in competitions" :key="comp" :value="comp">{{ comp }}</option>
        </select>
      </div>

      <div class="filter-group">
        <label>Lieu :</label>
        <select v-model="filterLocation" @change="applyFilters">
          <option value="">Tous</option>
          <option value="domicile">Domicile</option>
          <option value="exterieur">Extérieur</option>
        </select>
      </div>

      <div class="filter-group">
        <label>Période :</label>
        <input type="date" v-model="filterDateFrom" @change="applyFilters" placeholder="De">
        <input type="date" v-model="filterDateTo" @change="applyFilters" placeholder="À">
      </div>
    </div>

    <!-- Liste des matchs -->
    <div class="match-list">
      <table>
        <thead>
          <tr>
            <th>Date</th>
            <th>Compétition</th>
            <th>Adversaire</th>
            <th>Lieu</th>
            <th>Score</th>
            <th>Public</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="match in filteredMatches" :key="match.idMatch">
            <td>{{ formatDate(match.dateMatch) }}</td>
            <td>{{ match.competition }}</td>
            <td>{{ match.adversaire }}</td>
            <td>{{ match.domicile ? 'Domicile' : 'Extérieur' }}</td>
            <td>
              <span :class="{'win': match.scoreEquipe > match.scoreAdversaire, 'draw': match.scoreEquipe === match.scoreAdversaire, 'loss': match.scoreEquipe < match.scoreAdversaire}">
                {{ match.scoreEquipe }} - {{ match.scoreAdversaire }}
              </span>
            </td>
            <td>{{ match.public ? match.public.toLocaleString() : '-' }}</td>
            <td class="actions">
              <router-link :to="'/feuille-match/' + match.idMatch" class="btn-details" title="Détails">
                <i class="fas fa-eye"></i>
              </router-link>
              <router-link :to="'/match/modifier/' + match.idMatch" class="btn-edit" title="Modifier">
                <i class="fas fa-edit"></i>
              </router-link>
              <button @click="confirmDelete(match.idMatch)" class="btn-delete" title="Supprimer">
                <i class="fas fa-trash"></i>
              </button>
            </td>
          </tr>
        </tbody>
      </table>

      <!-- Pagination -->
      <div class="pagination" v-if="totalPages > 1">
        <button @click="prevPage" :disabled="currentPage === 1">
          <i class="fas fa-chevron-left"></i>
        </button>
        <span>Page {{ currentPage }} sur {{ totalPages }}</span>
        <button @click="nextPage" :disabled="currentPage === totalPages">
          <i class="fas fa-chevron-right"></i>
        </button>
      </div>
    </div>
  </div>
</template>



<style scoped>
.match-container {
  padding: 20px;
  max-width: 1200px;
  margin: 0 auto;
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.btn-add {
  background-color: #3498db;
  color: white;
  padding: 10px 15px;
  border-radius: 4px;
  text-decoration: none;
  display: flex;
  align-items: center;
  gap: 8px;
}

.filters {
  display: flex;
  gap: 20px;
  margin-bottom: 20px;
  flex-wrap: wrap;
  background-color: #f5f5f5;
  padding: 15px;
  border-radius: 8px;
}

.filter-group {
  display: flex;
  align-items: center;
  gap: 10px;
}

.filter-group label {
  font-weight: bold;
}

.filter-group select, 
.filter-group input {
  padding: 8px;
  border: 1px solid #ddd;
  border-radius: 4px;
}

.match-list {
  overflow-x: auto;
}

table {
  width: 100%;
  border-collapse: collapse;
  margin-bottom: 20px;
}

th, td {
  padding: 12px 15px;
  text-align: left;
  border-bottom: 1px solid #ddd;
}

th {
  background-color: #f2f2f2;
  font-weight: bold;
}

tr:hover {
  background-color: #f5f5f5;
}

.win {
  color: #2ecc71;
  font-weight: bold;
}

.draw {
  color: #f39c12;
  font-weight: bold;
}

.loss {
  color: #e74c3c;
  font-weight: bold;
}

.actions {
  display: flex;
  gap: 10px;
}

.btn-details, .btn-edit, .btn-delete {
  padding: 5px 10px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  color: white;
}

.btn-details {
  background-color: #3498db;
}

.btn-edit {
  background-color: #f39c12;
}

.btn-delete {
  background-color: #e74c3c;
}

.pagination {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 20px;
  margin-top: 20px;
}

.pagination button {
  padding: 5px 10px;
  border: 1px solid #ddd;
  border-radius: 4px;
  background-color: white;
  cursor: pointer;
}

.pagination button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

@media (max-width: 768px) {
  .filters {
    flex-direction: column;
  }
  
  .filter-group {
    flex-direction: column;
    align-items: flex-start;
  }
}
</style>