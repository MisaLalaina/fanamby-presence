<script setup>
import { ref, computed, onMounted } from 'vue';
// Assurez-vous que searchJoueurs peut prendre 'page' et 'limit' en paramètres
import { searchJoueurs } from '@/services/JoueurService'; 
import { getAllPostes } from '@/services/PosteService';
import JoueurProfile from '@/views/joueur/JoueurProfile.vue';
import usePagination from '@/composables/usePagination';

// --- Gestion de la Fiche Détaillée ---
const selectedPlayer = ref(null);

const viewPlayerProfile = (joueur) => {
    selectedPlayer.value = joueur;
};

const closePlayerProfile = () => {
    selectedPlayer.value = null; 
    applySearch(); // Au retour, on s'assure que la liste est à jour
};

// --- Données de Base ---
const postes = ref([]);
const joueurs = ref([]);

// --- PARAMÈTRES DE PAGINATION ---
const paginationUse = usePagination()

// --- FILTRES DE RECHERCHE CONSOLIDÉS ---
const searchFilters = ref({
    nom: '',
    prenom: '',
    poste: '', 
    dateInscriptionMin: '',
    dateInscriptionMax: '',
});

// État pour le chargement
const isLoading = ref(false);

const nextPageHandler = () => {
  paginationUse.nextPage()
  searchData()
}

const searchData = async () => {
  isLoading.value = true;
  // 1. Déterminer les paramètres de recherche
  const params = {
      nom: searchFilters.value.nom,
      prenom: searchFilters.value.prenom,
      dateInscriptionMin: searchFilters.value.dateInscriptionMin,
      dateInscriptionMax: searchFilters.value.dateInscriptionMax,
      poste: searchFilters.value.poste,
  };

  try {
      // 2. Appeler la fonction search du service
      // On suppose que searchJoueurs retourne un objet de ce type: { data: [...], total: 100 }
      const response = await searchJoueurs(params, paginationUse.getPageRequest()); 
      
      // 3. Mettre à jour la liste des joueurs et le total
      joueurs.value = response.data; // Assurez-vous que l'API renvoie les données sous 'data' ou 'joueurs'
      paginationUse.setPagination(response.page)
  } catch (err) {
      console.error('Erreur lors de la recherche des joueurs:', err);
      joueurs.value = [];
  } finally {
      isLoading.value = false;
  }
}

// --- FONCTION DE RECHERCHE PRINCIPALE ---
const applySearch = (page = 1) => {
  paginationUse.resetPagination()
  searchData()
};



// Applique la recherche au submit du formulaire, en revenant toujours à la première page
const handleSearchSubmit = () => {
  applySearch(1); 
};


// --- Calcul de la liste affichée ---
const filteredJoueurs = computed(() => joueurs.value);


// --- CHARGEMENT INITIAL DES DONNÉES ---
const loadInitialData = async () => {
    try {
        // Fetch postes
        const postesList = await getAllPostes();
        // On insère l'option 'Tous' au début de la liste des postes
        postes.value = [{ id: '', libelle: 'Tous' }, ...postesList];
        
        // Charger la première page des joueurs
        await applySearch(1);
    } catch (err) {
        console.error('Erreur chargement données initiales:', err);
    }
};

onMounted(() => {
    loadInitialData();
});

// --- Gestion d'erreur d'image ---
const onImageError = (event) => {
    event.target.src = '/logo/logofotsy.jpg'; 
    event.target.classList.add('default-avatar');
};

// Fonction pour réinitialiser les filtres du formulaire
const resetSearchFilters = () => {
    searchFilters.value = { 
        nom: '', 
        prenom: '', 
        poste: '', // Réinitialisation du select
        dateInscriptionMin: '', 
        dateInscriptionMax: '' 
    };
    applySearch(1); // Relance la recherche depuis la première page
};
</script>

<template>
  <JoueurProfile 
    v-if="selectedPlayer" 
    :player="selectedPlayer" 
    @close="closePlayerProfile" 
  />
  <div v-else class="joueurs-container">
    <div @click="nextPageHandler()">
      Next
    </div>
    <h1>Liste de joueurs ({{ joueurs.length }})</h1>
    
    <form @submit.prevent="handleSearchSubmit()" class="search-form">
      <input type="text" v-model="searchFilters.nom" placeholder="Nom du joueur" class="filter-input">
      <input type="text" v-model="searchFilters.prenom" placeholder="Prénom du joueur" class="filter-input">
      
      <div class="select-group">
        <label>Poste</label>
        <select v-model="searchFilters.poste" class="filter-input select-input">
          <option v-for="poste in postes" :key="poste.id || 'all'" :value="poste.id">{{ poste.libelle }}</option>
        </select>
      </div>

      <div class="date-group">
        <label>Inscrit Min</label>
        <input type="date" v-model="searchFilters.dateInscriptionMin" class="filter-input">
      </div>
      
      <div class="date-group">
        <label>Inscrit Max</label>
        <input type="date" v-model="searchFilters.dateInscriptionMax" class="filter-input">
      </div>
      
      <button type="submit" class="btn-search" :disabled="isLoading">
        {{ isLoading ? 'Recherche...' : 'Rechercher 🔎' }}
      </button>
      
      <button type="button" @click="resetSearchFilters()" class="btn-reset" :disabled="isLoading">
        Effacer
      </button>
    </form>
    
    <div v-if="isLoading" class="loading-overlay">
        <div class="loader"></div>
        <p>Chargement des joueurs...</p>
    </div>
    
    <div v-else-if="filteredJoueurs.length === 0" class="empty-results">
        <p>Aucun joueur ne correspond aux critères de recherche actuels.</p>
    </div>

    <div v-else class="joueurs-grid">
      <div 
        v-for="joueur in filteredJoueurs" 
        :key="joueur.id" 
        class="joueur-card"
        @click="viewPlayerProfile(joueur)" 
      >
        <div class="joueur-media-section">
          <img 
            :src="'joueurs/'+joueur.id+'.jpg'" 
            :alt="'Photo de ' + joueur.nom" 
            class="joueur-avatar"
            @error="onImageError"
          >
          <div class="joueur-numero">{{ joueur.numero }}</div>
        </div>

        <div class="joueur-details-section">
          <div class="status-container">
            <div class="joueur-poste-tag">{{ joueur.poste }}</div>
            <div :class="'status-'+String(joueur.status).toLowerCase()"></div>
          </div>
          <div class="joueur-nom">{{ joueur.prenom }} <span class="joueur-nom-bold">{{ joueur.nom }}</span></div>
          
          <div class="joueur-meta-info">
            <span class="icon">🎂</span> Né le <span class="meta-value">{{ joueur.dateNaissance }}</span>
          </div>
          <div class="joueur-meta-info">
            <span class="icon">🌍</span> Nationalité <span class="meta-value">{{ joueur.nationalite }}</span>
          </div>
          
          <div class="joueur-meta-info activity-line">
            <span class="icon">📅</span> Inscrit depuis <span class="meta-value">{{ joueur.dateInscription }}</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
/* Styles de la pagination */
.pagination {
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 20px;
    margin-top: 30px;
    padding: 10px 0;
}

.pagination-btn {
    padding: 10px 15px;
    border: 1px solid #2A88C8;
    background-color: white;
    color: #2A88C8;
    border-radius: 6px;
    font-weight: 600;
    cursor: pointer;
    transition: background-color 0.3s, color 0.3s;
}

.pagination-btn:hover:not(:disabled) {
    background-color: #2A88C8;
    color: white;
}

.pagination-btn:disabled {
    border-color: #ccc;
    color: #ccc;
    cursor: not-allowed;
    background-color: #f9f9f9;
}

.page-info {
    font-weight: 600;
    color: #333;
    font-size: 16px;
}

/* ------------------------------------- */
/* COHÉRENCE GLOBALE ET FORMULAIRE EXISTANTS */
/* ------------------------------------- */

* {
   font-family: 'InterTight', sans-serif;
   box-sizing: border-box; 
}

.status-actif {
     width: 10px;
     height: 10px;
     border-radius: 50%;
     background-color: #27ae60; /* Vert pour Actif */
}

.status-inactif {
    /* Je suppose que status-inactif doit être un point de couleur différente, ajustons le style pour être cohérent */
    width: 10px;
     height: 10px;
     border-radius: 50%;
     background-color: #e74c3c; /* Rouge pour Inactif */
}

.status-container{
   display: flex;
   align-items: center;
   justify-content: space-between;
}

.joueurs-container {
   max-width: 1200px;
   margin: 0 auto;
   padding: 30px 20px;
}

h1 {
   text-align: center;
   color: #2A88C8; 
   margin-bottom: 25px;
   font-size: 32px;
   font-weight: 700;
}

/* --- FORMULAIRE DE RECHERCHE --- */
.search-form {
       display: flex;
       flex-wrap: wrap;
       gap: 15px;
       align-items: flex-end; 
       padding: 20px;
       background-color: #f7f9fa; 
       border-radius: 10px;
       margin-bottom: 30px;
       box-shadow: inset 0 1px 3px rgba(0,0,0,0.05);
}

.search-form .filter-input {
       flex: 1 1 180px; 
       padding: 10px 15px;
       border: 1px solid #ddd;
       border-radius: 6px;
       font-size: 14px;
       transition: border-color 0.3s;
}

.search-form .filter-input:focus {
       border-color: #2A88C8;
       outline: none;
       box-shadow: 0 0 5px rgba(42, 136, 200, 0.2);
}

.search-form .date-group, .search-form .select-group {
       flex: 1 1 180px; 
}

.search-form .date-group label, .search-form .select-group label {
       display: block;
       font-size: 12px;
       color: #7f8c8d;
       margin-bottom: 5px;
       font-weight: 600;
}

.search-form .date-group .filter-input, .search-form .select-group .filter-input {
       width: 100%;
}

.search-form .select-input {
     appearance: none; 
     background-image: url('data:image/svg+xml;charset=US-ASCII,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%22292.4%22%20height%3D%22292.4%22%3E%3Cpath%20fill%3D%22%232A88C8%22%20d%3D%22M287%2069.4a17.6%2017.6%200%200%200-13%205.1L146.2%20205.9%2018.3%2074.5a17.6%2017.6%200%200%200-24.7%2024.7l130.4%20130.4c6.8%206.8%2017.7%206.8%2024.7%200l130.4-130.4a17.6%2017.6%200%200%200-12.9-29.6z%22%2F%3E%3C%2Fsvg%3E');
     background-repeat: no-repeat;
     background-position: right 10px center;
     background-size: 12px;
     padding-right: 30px; 
}

.btn-search, .btn-reset {
       padding: 10px 20px;
       border: none;
       border-radius: 6px;
       font-weight: bold;
       cursor: pointer;
       transition: background-color 0.3s, transform 0.1s;
       font-size: 14px;
       min-width: 120px;
}

.btn-search {
       background-color: #2A88C8; 
       color: white;
}

.btn-search:hover:not(:disabled) {
       background-color: #1a78b8;
}

.btn-reset {
       background-color: #e0e0e0;
       color: #555;
}

.btn-reset:hover:not(:disabled) {
       background-color: #ccc;
}

.btn-search:disabled, .btn-reset:disabled {
       opacity: 0.6;
       cursor: not-allowed;
}

/* GRILLE & CARTES */
.joueurs-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); 
    gap: 25px; 
}

.joueur-card {
    background-color: white;
    border-radius: 12px; 
    overflow: hidden; 
    box-shadow: 0 6px 15px rgba(0, 0, 0, 0.1);
    transition: transform 0.3s, box-shadow 0.3s;
    display: flex;
    flex-direction: column;
    cursor: pointer;
}

.joueur-card:hover {
    transform: translateY(-8px); 
    box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
}

/* SECTION MEDIA (IMAGE & NUMÉRO) */
.joueur-media-section {
         position: relative;
         height: 180px; 
         overflow: hidden;
}

.joueur-avatar {
         width: 100%;
         height: 100%;
         object-fit: cover; 
         transition: transform 0.5s;
}

.joueur-card:hover .joueur-avatar {
         transform: scale(1.05); 
}

.joueur-numero {
         position: absolute;
         top: 10px;
         right: 10px;
         background-color: #2A88C8; 
         color: white;
         font-size: 28px;
         font-weight: 900;
         padding: 5px 12px;
         border-radius: 6px;
         line-height: 1;
         z-index: 10;
}

/* SECTION DÉTAILS */
.joueur-details-section {
         padding: 15px 20px 20px;
         flex-grow: 1;
}

.joueur-poste-tag {
         display: inline-block;
         background-color: #e74c3c; 
         color: white;
         padding: 4px 10px;
         border-radius: 4px;
         font-size: 12px;
         font-weight: bold;
         text-transform: uppercase;
         margin-bottom: 10px;
}

.joueur-nom {
         font-size: 20px;
         color: #333;
         margin-bottom: 5px;
         font-weight: 500;
         line-height: 1.2;
}

.joueur-nom-bold {
         font-weight: 800;
         text-transform: uppercase;
         color: #2A88C8;
}

.joueur-meta-info {
         font-size: 14px;
         color: #7f8c8d; 
         margin-top: 8px;
         display: flex;
         align-items: center;
         gap: 5px;
}

.icon {
         font-size: 16px;
}

.meta-value {
         color: #2c3e50;
         font-weight: 600;
}

.activity-line {
         border-top: 1px solid #eee;
         padding-top: 10px;
         margin-top: 10px;
}


/* --- ETATS : CHARGEMENT ET RÉSULTATS VIDES --- */
.loading-overlay {
       text-align: center;
       padding: 40px;
       color: #2A88C8;
       font-size: 1.2em;
}

.empty-results {
       text-align: center;
       padding: 40px;
       border: 2px dashed #ccc;
       border-radius: 10px;
       color: #7f8c8d;
       margin-top: 30px;
}

/* Spinner (pour le loader) */
.loader {
    border: 4px solid #f3f3f3;
    border-top: 4px solid #2A88C8;
    border-radius: 50%;
    width: 30px;
    height: 30px;
    animation: spin 1s linear infinite;
    margin: 0 auto 10px;
}

@keyframes spin {
    0% { transform: rotate(0deg); }
    100% { transform: rotate(360deg); }
}

/* RESPONSIVE */
@media (max-width: 768px) {
       .joueurs-grid {
             grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
       }
       .search-form {
             gap: 10px;
       }
       .btn-search, .btn-reset {
             flex: 1 1 45%;
             min-width: initial;
       }
}
</style>