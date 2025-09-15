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
*{
  font-family: CormorantGaramond-Italic,sans-serif;
}
.stats-container {
  max-width: 1400px;
  margin: 0 auto;
  padding: 2rem;
  font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
}

.header-section {
  text-align: center;
  margin-bottom: 2.5rem;
}

.header-section h1 {
  color: #1B578C;
  font-size: 2.5rem;
  font-weight: 700;
  margin-bottom: 0.5rem;
}

.header-section p {
  color: #2A86BF;
  font-size: 1.1rem;
}

.filters-section {
  display: flex;
  gap: 1.5rem;
  margin-bottom: 2rem;
  flex-wrap: wrap;
}

.filter-group {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.filter-group label {
  font-weight: 600;
  color: #164773;
  font-size: 0.9rem;
}

.filter-select {
  padding: 0.75rem 1rem;
  border: 1px solid #D1D1D1;
  border-radius: 8px;
  background-color: #F2F2F2;
  font-size: 0.95rem;
  min-width: 180px;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
  gap: 1.5rem;
  margin-bottom: 2rem;
}

.stat-card {
  background: white;
  border-radius: 12px;
  padding: 1.5rem;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  border: 1px solid #E0E0E0;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1.5rem;
  padding-bottom: 1rem;
  border-bottom: 1px solid #F0F0F0;
}

.card-header h3 {
  color: #164773;
  font-size: 1.2rem;
  font-weight: 600;
}

.search-input {
  padding: 0.5rem 1rem;
  border: 1px solid #D1D1D1;
  border-radius: 6px;
  font-size: 0.9rem;
  width: 200px;
}

.summary-card .card-content {
  text-align: center;
}

.summary-value {
  font-size: 3rem;
  font-weight: 700;
  color: #2493BF;
  margin-bottom: 0.5rem;
}

.summary-label {
  color: #718096;
  font-size: 1rem;
  margin-bottom: 1.5rem;
}

.summary-stats {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 1rem;
}

.stat-item {
  text-align: center;
  padding: 1rem;
  background-color: #F8FBFD;
  border-radius: 8px;
}

.stat-number {
  display: block;
  font-size: 1.5rem;
  font-weight: 700;
  color: #1B578C;
}

.stat-text {
  font-size: 0.85rem;
  color: #718096;
}

.chart-container {
  height: 200px;
  display: flex;
  align-items: flex-end;
}

.trend-chart {
  display: flex;
  align-items: flex-end;
  gap: 1rem;
  width: 100%;
  height: 100%;
}

.chart-bar {
  flex: 1;
  background-color: #2A86BF;
  border-radius: 6px 6px 0 0;
  position: relative;
  transition: height 0.3s ease;
  min-height: 20px;
}

.chart-bar.current-week {
  background-color: #2493BF;
}

.bar-value {
  position: absolute;
  top: -25px;
  left: 50%;
  transform: translateX(-50%);
  font-size: 0.8rem;
  font-weight: 600;
  color: #164773;
}

.players-list {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.player-item {
  display: flex;
  align-items: center;
  gap: 1rem;
  padding: 0.75rem;
  background-color: #F8FBFD;
  border-radius: 8px;
}

.player-rank {
  width: 30px;
  height: 30px;
  background-color: #1B578C;
  color: white;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 700;
  font-size: 0.9rem;
}

.player-info {
  flex: 1;
}

.player-name {
  font-weight: 600;
  color: #164773;
  margin-bottom: 0.25rem;
}

.player-stats {
  font-size: 0.85rem;
  color: #718096;
}

.presence-rate {
  font-weight: 600;
  color: #2493BF;
  margin-right: 0.5rem;
}

.progress-bar {
  width: 100px;
  height: 8px;
  background-color: #E0E0E0;
  border-radius: 4px;
  overflow: hidden;
}

.progress-bar.small {
  width: 60px;
  height: 6px;
  margin-top: 0.25rem;
}

.progress-fill {
  height: 100%;
  background-color: #2493BF;
  border-radius: 4px;
  transition: width 0.3s ease;
}

.table-container {
  overflow-x: auto;
}

.players-table {
  width: 100%;
  border-collapse: collapse;
}

.players-table th {
  background-color: #1B578C;
  color: white;
  padding: 1rem;
  text-align: left;
  font-weight: 600;
  font-size: 0.9rem;
}

.players-table td {
  padding: 1rem;
  border-bottom: 1px solid #F0F0F0;
}

.player-cell {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.player-avatar {
  width: 40px;
  height: 40px;
  background-color: #2A86BF;
  color: white;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 700;
  font-size: 0.9rem;
}

.player-details {
  display: flex;
  flex-direction: column;
}

.player-position {
  font-size: 0.8rem;
  color: #718096;
}

.rate-display {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.status-badge {
  padding: 0.35rem 0.75rem;
  border-radius: 20px;
  font-size: 0.8rem;
  font-weight: 600;
}

.status-excellent {
  background-color: #E8F5E8;
  color: #2E7D32;
}

.status-good {
  background-color: #E3F2FD;
  color: #1565C0;
}

.status-average {
  background-color: #FFF3E0;
  color: #EF6C00;
}

.status-poor {
  background-color: #FFEBEE;
  color: #C62828;
}

@media (max-width: 768px) {
  .stats-grid {
    grid-template-columns: 1fr;
  }
  
  .filters-section {
    flex-direction: column;
  }
  
  .summary-stats {
    grid-template-columns: 1fr;
  }
}

.modal-overlay {
  position: fixed;
  top: 0; left: 0; right: 0; bottom: 0;
  background: rgba(0,0,0,0.6);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 999;
}
.modal {
  background: white;
  padding: 2rem;
  border-radius: 10px;
  max-width: 800px;
  width: 100%;
  max-height: 80vh;
  overflow-y: auto;
}
.btn-popup, .btn-close {
  margin-top: 1rem;
  padding: 0.5rem 1rem;
  background: #1B578C;
  color: white;
  border: none;
  border-radius: 5px;
  cursor: pointer;
}
.btn-popup:hover, .btn-close:hover {
  background: #2493BF;
}
</style>