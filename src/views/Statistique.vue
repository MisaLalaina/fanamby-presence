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
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { getDashboardStats } from '@/services/statPresence' 

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

// Mock data (you can remove this once your API is working)
const overallStats = ref({
  presenceRate: 85,
  totalSessions: 48,
  present: 41,
  absent: 7
})

const weeklyTrend = ref([
  { week: 'Sem 1', presenceRate: 78, current: false },
  { week: 'Sem 2', presenceRate: 82, current: false },
  { week: 'Sem 3', presenceRate: 88, current: false },
  { week: 'Sem 4', presenceRate: 85, current: false },
  { week: 'Sem 5', presenceRate: 90, current: true }
])

const topPlayers = ref([
  { id: 1, name: 'RAKOTO', present: 45, total: 48, presenceRate: 94 },
  { id: 2, name: 'RANDRIA', present: 44, total: 48, presenceRate: 92 },
  { id: 3, name: 'MIA', present: 43, total: 48, presenceRate: 90 },
  { id: 4, name: 'KELY', present: 42, total: 48, presenceRate: 88 },
  { id: 5, name: 'RAJAONA', present: 41, total: 48, presenceRate: 85 }
])

const allPlayers = ref([
  { id: 1, name: 'RAKOTO', position: 'Attaquant', present: 45, total: 48, presenceRate: 94 },
  { id: 2, name: 'RANDRIA', position: 'Milieu', present: 44, total: 48, presenceRate: 92 },
  { id: 3, name: 'MIA', position: 'Défenseur', present: 43, total: 48, presenceRate: 90 },
  { id: 4, name: 'KELY', position: 'Gardien', present: 42, total: 48, presenceRate: 88 },
  { id: 5, name: 'RAJAONA', position: 'Attaquant', present: 41, total: 48, presenceRate: 85 },
  { id: 6, name: 'ANDRIAMI', position: 'Milieu', present: 38, total: 48, presenceRate: 79 },
  { id: 7, name: 'FENO', position: 'Défenseur', present: 36, total: 48, presenceRate: 75 }
])

// Computed properties
const filteredPlayers = computed(() => {
  return allPlayers.value.filter(player =>
    player.name.toLowerCase().includes(playerSearch.value.toLowerCase())
  )
})

// If you want to compute these from your API data once it's loaded:
const playerPresenceData = computed(() => {
  return stats.value.playerPresenceStats?.content || []
})

const globalSessionData = computed(() => {
  return stats.value.globalSessionStats?.content || []
})

// Methods
const getInitials = (name) => {
  return name.split(' ').map(n => n[0]).join('').toUpperCase()
}

const getStatusClass = (rate) => {
  if (rate >= 90) return 'status-excellent'
  if (rate >= 80) return 'status-good'
  if (rate >= 70) return 'status-average'
  return 'status-poor'
}

const getStatusText = (rate) => {
  if (rate >= 90) return 'Excellent'
  if (rate >= 80) return 'Bon'
  if (rate >= 70) return 'Moyen'
  return 'À améliorer'
}


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
</style>