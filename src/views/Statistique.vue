<template>
  <div class="stats-container">
    <div class="header-section">
      <h1>Statistiques de Présence</h1>
      <!-- <p>Suivi des présences des joueurs pour la saison 2024</p> -->
    </div>

    <div class="filters-section">
      <div class="filter-group">
        <label>Saison :</label>
        <select v-model="selectedSeason" class="filter-select">
          <option value="2024">Saison 2024</option>
          <option value="2023">Saison 2023</option>
        </select>
      </div>
      
      <div class="filter-group">
        <label>Type de séance :</label>
        <select v-model="selectedType" class="filter-select">
          <option value="all">Toutes les séances</option>
          <option value="training">Entraînements</option>
          <option value="match">Matches</option>
        </select>
      </div>

      <div class="filter-group">
        <label>Période :</label>
        <select v-model="selectedPeriod" class="filter-select">
          <option value="all">Toute la saison</option>
          <option value="month">30 derniers jours</option>
          <option value="week">7 derniers jours</option>
        </select>
      </div>
    </div>

    <!-- Carte de résumé global -->
    <div class="stat-card summary-card">
      <div class="card-header">
        <h3>Résumé Global</h3>
      </div>
      <div class="card-content">
        <div class="summary-item">
          <div class="summary-value">{{ dashboardStat.global.tauxEntrainement }}%</div>
          <div class="summary-label">Taux de présence entrainement</div>
        </div>
        <div class="summary-item">
          <div class="summary-value">{{ dashboardStat.global.tauxMatch }}%</div>
          <div class="summary-label">Taux de présence match</div>
        </div>
        <div class="summary-item">
          <div class="summary-value">{{ dashboardStat.global.tauxGeneral }}%</div>
          <div class="summary-label">Taux de présence global</div>
        </div>

        <div class="summary-stats">
          <div class="stat-item">
            <span class="stat-number">{{ dashboardStat.global.totalSeance }}</span>
            <span class="stat-text">Séances totales</span>
          </div>

          <div class="stat-item">
            <span class="stat-number">{{ dashboardStat.global.totalEntrainement }}</span>
            <span class="stat-text">Entrainement totales</span>
          </div>
          
          <div class="stat-item">
            <span class="stat-number">{{ dashboardStat.global.totalMatch }}</span>
            <span class="stat-text">Matches totales</span>
          </div>
        </div>
      </div>
    </div>
    <div class="stats-grid">

    </div>
    <!-- Détail par joueur -->
      <div class="stat-card details-card">
        <div class="card-header">
          <h3>Détail par Joueur ({{ dashboardStat.joueurs.length }})</h3>
          <input v-model="playerSearch" placeholder="Rechercher un joueur..." class="search-input">
        </div>
        <div class="table-container">
          <table class="players-table">
            <thead>
              <tr>
                <th>Joueur</th>
                <th>Entrainement</th>
                <th>Match</th>
                <th>General</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="player in dashboardStat.joueurs" :key="player.id">
                <td class="player-cell">
                  <!-- <div class="player-avatar">{{ getInitials(player.nom) }}</div> -->
                  <div class="player-details">
                    <div class="player-name">{{ player.nom }} {{ player.prenom }}</div>
                  </div>
                </td>
                <td>
                    <div class="rate-display">
                    {{ player.tauxEntrainement }}%
                    <div class="progress-bar small">
                      <div 
                        class="progress-fill" 
                        :style="{ width: player.tauxEntrainement + '%' }"
                      ></div>
                    </div>
                  </div>
                </td>
                <td>
                    <div class="rate-display">
                    {{ player.tauxMatch }}%
                    <div class="progress-bar small">
                      <div 
                        class="progress-fill" 
                        :style="{ width: player.tauxMatch + '%' }"
                      ></div>
                    </div>
                  </div>
                </td>
                <td> 
                    <div class="rate-display">
                    {{ player.tauxGeneral }}%
                    <div class="progress-bar small">
                      <div 
                        class="progress-fill" 
                        :style="{ width: player.tauxGeneral + '%' }"
                      ></div>
                    </div>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

    <!-- Filtre Seance -->
    <div class="filter-group">
      <label>Séance :</label>
      <select v-model="selectedSession" class="filter-select">
        <option value="">Toutes les séances</option>
        <option 
          v-for="session in sessions" 
          :key="session.idSeance" 
          :value="session.idSeance">
          {{ session.type }} - {{ session.dateSeance }}
        </option>
      </select>
      <button 
        v-if="selectedSession" 
        @click="openPresencePopup" 
        class="btn-popup">
        Voir les présences
      </button>
    </div>

    <!-- Popup Présences -->
    <div v-if="showPopup" class="modal-overlay">
      <div class="modal">
        <h3>Présences pour la séance sélectionnée</h3>
        <div class="popup-stats">
  <div class="stat-item">
    <span class="stat-number">{{ popupStats.total }}</span>
    <span class="stat-text">Joueurs</span>
  </div>
  <div class="stat-item">
    <span class="stat-number">{{ popupStats.presents }}</span>
    <span class="stat-text">Présents</span>
  </div>
  <div class="stat-item">
    <span class="stat-number">{{ popupStats.absents }}</span>
    <span class="stat-text">Absents</span>
  </div>
  <div class="stat-item">
    <span class="stat-number">{{ popupStats.tauxPresence }}%</span>
    <span class="stat-text">Taux de présence</span>
  </div>
</div>

        <table class="players-table">
          <thead>
            <tr>
              <th>Joueur</th>
              <th>Présent</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="p in presenceList" :key="p.idPresence">
              <td>{{ p.nom }} {{ p.prenom }}</td>
              <td>{{ p.presenceStatus }}</td>
            </tr>
          </tbody>
        </table>
        <button @click="closePresencePopup" class="btn-close">Fermer</button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { getDashboardStats } from '@/services/statPresence'

import SeanceService from '@/services/SeanceService'
import { Seance } from '@/models/seance'

import {getPresencesByIdSeance} from '@/services/PresenceService'

const showPopup = ref(false)
const presenceList = ref([])

const popupStats = ref({
  total: 0,
  presents: 0,
  absents: 0,
  tauxPresence: 0
})

const openPresencePopup = async () => {
  if (!selectedSession.value) return
  try {
    const data = await getPresencesByIdSeance(selectedSession.value)
    presenceList.value = data

    // Calcul des chiffres
    popupStats.value.total = data.length
    popupStats.value.presents = data.filter(p => p.presenceStatus === 'Present').length
    popupStats.value.absents = popupStats.value.total - popupStats.value.presents
    popupStats.value.tauxPresence = popupStats.value.total > 0 
      ? Math.round((popupStats.value.presents / popupStats.value.total) * 100) 
      : 0

    showPopup.value = true
  } catch (err) {
    console.error("Erreur chargement présences:", err)
  }
}


const closePresencePopup = () => {
  showPopup.value = false
  presenceList.value = []
}


const selectedSession = ref('')
const sessions = ref([])

// Reactive data
const selectedSeason = ref('2024')
const selectedType = ref('all')
const selectedPeriod = ref('all')
const playerSearch = ref('')
const stats = ref({
  playerPresenceStats: [],
  globalSessionStats: [
    {
      "idtypeseance": 1,
      "typeseance": "Entrainement",
      "nbseance": 0
    },
    {
      "idtypeseance": 2,
      "typeseance": "Match",
      "nbseance": 0
    }
  ]
})
// -------

// Charger la liste des séances
const fetchSessions = async () => {
  const response = await SeanceService.getAllSeances()
  sessions.value = Seance.formatSeances(response)
}

// Adapter la récupération des stats
const fetchStats = async () => {
  // try {
  //   const dashboardData = await getDashboardStats({
  //     season: selectedSeason.value,
  //     type: selectedType.value,
  //     period: selectedPeriod.value,
  //     idSeance: selectedSession.value || null   // ✅ On passe le filtre séance
  //   })
  //   stats.value = dashboardData
  // } catch (error) {
  //   console.error("Erreur chargement stats:", error)
  // }
}
// -------
const dashboardStat = computed(() => {
  const presenceStat = {
    global : {
      totalSeance : stats.value.globalSessionStats[0].nbseance + stats.value.globalSessionStats[1].nbseance,
      totalEntrainement: stats.value.globalSessionStats[0].nbseance,
      totalMatch: stats.value.globalSessionStats[1].nbseance, 
      tauxEntrainement: 0,
      tauxMatch: 0,
      tauxGeneral: 0,
    },
    joueurs:[],
    sommeEntrainement:0,
    sommeMatch:0,
    sommeGeneral:0,
  }

  stats.value.playerPresenceStats.forEach((playerPresence) => {
    const playerStat = {
      tauxEntrainement : 0,
      tauxMatch: 0,
      tauxGeneral: 0
    }
    if (presenceStat.global.totalEntrainement > 0) {
      playerStat.tauxEntrainement = (playerPresence.entpresences / presenceStat.global.totalEntrainement) * 100
    }

    if (presenceStat.global.totalMatch > 0) {
      playerStat.tauxEntrainement = (playerPresence.matpresences / presenceStat.global.totalMatch) * 100
    }

    if(presenceStat.global.totalSeance > 0){
      playerStat.tauxGeneral = (playerPresence.totalpresences / presenceStat.global.totalSeance) * 100
    }

    presenceStat.joueurs.push({
      id:playerPresence.idjoueur,
      nom:playerPresence.nom,
      prenom:playerPresence.prenom,
      ...playerStat
    })
    presenceStat.sommeEntrainement = presenceStat.sommeEntrainement + playerStat.tauxEntrainement

    presenceStat.sommeMatch = presenceStat.sommeMatch + playerStat.tauxMatch
    
    presenceStat.sommeGeneral = presenceStat.sommeGeneral + playerStat.tauxGeneral
  })

  presenceStat.global.tauxEntrainement = presenceStat.sommeEntrainement / presenceStat.joueurs.length
  
  presenceStat.global.tauxMatch = presenceStat.sommeMatch / presenceStat.joueurs.length
  
  presenceStat.global.tauxGeneral = presenceStat.sommeGeneral / presenceStat.joueurs.length  
  
  return presenceStat;
}); 

// Lifecycle hook
onMounted(async () => {
  console.log("Fetch dashboard")
  try {
    const dashboardData = await getDashboardStats()
    stats.value = dashboardData
    console.log(stats.value);

    await fetchSessions()
    await fetchStats()
    
  } catch (error) {
    console.error("Failed to load dashboard data:", error)
    // You might want to show an error message to the user
  }
})
</script>

<style scoped>
/* Appliquer la police InterTight à tout le conteneur */
.stats-container {
  font-family: 'InterTight', sans-serif;
  padding: 20px;
  max-width: 1200px;
  margin: 0 auto;
  color: #2c3e50;
}

/* En-tête */
.header-section {
  /* text-align: center; */
  /* margin-bottom: 30px; */
  color:  #2A88C8;
}

.header-section h1 {
  font-size: 32px;
  color:#2A88C8;
  margin-bottom: 10px;
  /* font-weight: 700; */
}

.header-section p {
  color: #7f8c8d;
  font-size: 16px;
}

/* Filtres */
.filters-section {
  display: flex;
  gap: 20px;
  margin-bottom: 30px;
  flex-wrap: wrap;
  align-items: center;
}

.filter-group {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.filter-group label {
  font-weight: 600;
  font-size: 14px;
  color: #2c3e50;
}

.filter-select {
  padding: 10px 12px;
  border: 1px solid #ddd;
  border-radius: 6px;
  font-size: 14px;
  background-color: white;
  min-width: 180px;
}

/* Cartes de statistiques */
.stat-card {
  background: white;
  border-radius: 10px;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
  margin-bottom: 30px;
  overflow: hidden;
}

.card-header {
  background-color: #2493BF;
  color: white;
  padding: 15px 20px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.card-header h3 {
  margin: 0;
  font-size: 18px;
  font-weight: 600;
}

.search-input {
  padding: 8px 12px;
  border: 1px solid #ddd;
  border-radius: 6px;
  font-size: 14px;
  min-width: 250px;
}

.card-content {
  padding: 20px;
}

/* Résumé global */
.summary-card .card-content {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 20px;
}

.summary-item {
  text-align: center;
  padding: 15px;
  border-radius: 8px;
  background-color: #f8f9fa;
}

.summary-value {
  font-size: 28px;
  font-weight: 700;
  color: #2493BF;
  margin-bottom: 5px;
}

.summary-label {
  font-size: 14px;
  color: #7f8c8d;
}

.summary-stats {
  grid-column: span 3;
  display: flex;
  justify-content: space-around;
  margin-top: 20px;
  padding-top: 20px;
  border-top: 1px solid #eee;
}

.stat-item {
  text-align: center;
}

.stat-number {
  display: block;
  font-size: 24px;
  font-weight: 700;
  color: #2c3e50;
}

.stat-text {
  font-size: 14px;
  color: #7f8c8d;
}

/* Tableau des joueurs */
.table-container {
  overflow-x: auto;
}

.players-table {
  width: 100%;
  border-collapse: collapse;
  margin-top: 15px;
}

.players-table th {
  background-color: #f8f9fa;
  padding: 12px 15px;
  text-align: left;
  font-weight: 600;
  color: #2c3e50;
  border-bottom: 2px solid #eee;
}

.players-table td {
  padding: 12px 15px;
  border-bottom: 1px solid #eee;
}

.players-table tr:hover {
  background-color: #f8f9fa;
}

.player-cell {
  display: flex;
  align-items: center;
  gap: 12px;
}

.player-avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  background-color: #2493BF;
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 600;
}

.player-name {
  font-weight: 600;
}

/* Barres de progression */
.rate-display {
  display: flex;
  align-items: center;
  gap: 10px;
}

.progress-bar {
  flex-grow: 1;
  height: 8px;
  background-color: #ecf0f1;
  border-radius: 4px;
  overflow: hidden;
}

.progress-bar.small {
  max-width: 100px;
}

.progress-fill {
  height: 100%;
  background-color: #2493BF;
  border-radius: 4px;
  transition: width 0.3s ease;
}

/* Boutons */
.btn-popup {
  padding: 8px 15px;
  background-color: #2493BF;
  color: white;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  font-size: 14px;
  margin-top: 10px;
  transition: background-color 0.3s;
}

.btn-popup:hover {
  background-color: #1d7ea3;
}

.btn-close {
  padding: 10px 20px;
  background-color: #e74c3c;
  color: white;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  font-size: 14px;
  margin-top: 20px;
  transition: background-color 0.3s;
}

.btn-close:hover {
  background-color: #c0392b;
}

/* Popup de présences */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.modal {
  background: white;
  border-radius: 10px;
  padding: 25px;
  max-width: 600px;
  width: 90%;
  max-height: 80vh;
  overflow-y: auto;
  box-shadow: 0 5px 25px rgba(0, 0, 0, 0.2);
}

.modal h3 {
  margin-top: 0;
  color: #2c3e50;
  border-bottom: 2px solid #2493BF;
  padding-bottom: 10px;
  margin-bottom: 20px;
}

.popup-stats {
  display: flex;
  justify-content: space-around;
  margin: 20px 0;
  padding: 15px;
  background-color: #f8f9fa;
  border-radius: 8px;
}

/* Responsive */
@media (max-width: 768px) {
  .filters-section {
    flex-direction: column;
    align-items: stretch;
  }
  
  .filter-select {
    min-width: 100%;
  }
  
  .summary-card .card-content {
    grid-template-columns: 1fr;
  }
  
  .summary-stats {
    flex-direction: column;
    gap: 15px;
  }
  
  .card-header {
    flex-direction: column;
    gap: 15px;
    align-items: flex-start;
  }
  
  .search-input {
    min-width: 100%;
  }
  
  .popup-stats {
    flex-wrap: wrap;
    gap: 15px;
  }
  
  .stat-item {
    flex: 1;
    min-width: 45%;
  }
}

/* Animation pour les barres de progression */
@keyframes progressFill {
  from { width: 0; }
}

.progress-fill {
  animation: progressFill 1s ease-out;
}

/* Amélioration visuelle pour les taux élevés/moyens/faibles */
.rate-display .progress-fill[style*="width: 7"],
.rate-display .progress-fill[style*="width: 8"],
.rate-display .progress-fill[style*="width: 9"],
.rate-display .progress-fill[style*="width: 100"] {
  background-color: #27ae60; /* Vert pour les bons taux */
}

.rate-display .progress-fill[style*="width: 5"],
.rate-display .progress-fill[style*="width: 6"] {
  background-color: #f39c12; /* Orange pour les taux moyens */
}

.rate-display .progress-fill[style*="width: 0"],
.rate-display .progress-fill[style*="width: 1"],
.rate-display .progress-fill[style*="width: 2"],
.rate-display .progress-fill[style*="width: 3"],
.rate-display .progress-fill[style*="width: 4"] {
  background-color: #e74c3c; /* Rouge pour les faibles taux */
}
</style>