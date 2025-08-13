<template>
  <div class="feuille-match-container">
    <!-- En-tête de la feuille de match -->
    <div class="match-header">
      <div class="club-info home-team">
        <img v-if="matchData.clubLogo" :src="matchData.clubLogo" alt="Logo club" class="team-logo">
        <div v-else class="team-logo-placeholder"></div>
        <h2>{{ matchData.clubNom }}</h2>
      </div>
      
      <div class="match-score">
        <div class="score-display">
          <span class="score">{{ matchData.scoreEquipe }}</span>
          <span class="separator">-</span>
          <span class="score">{{ matchData.scoreAdversaire }}</span>
        </div>
        <div class="match-info">
          <p>{{ matchData.competition }}</p>
          <p>{{ formatDate(matchData.dateSeance) }} à {{ formatTime(matchData.heureDebut) }}</p>
          <p>{{ matchData.lieu }}</p>
        </div>
      </div>
      
      <div class="club-info away-team">
        <img v-if="matchData.adversaireLogo" :src="matchData.adversaireLogo" alt="Logo adversaire" class="team-logo">
        <div v-else class="team-logo-placeholder"></div>
        <h2>{{ matchData.adversaire }}</h2>
      </div>
    </div>

    <!-- Détails du match -->
    <div class="match-details">
      <div class="detail-section">
        <h3>Incidents</h3>
        <p v-if="matchData.incidents">{{ matchData.incidents }}</p>
        <p v-else class="no-data">Aucun incident à signaler</p>
      </div>
    </div>

    <!-- Composition de l'équipe -->
    <div class="team-compositions">
      <div class="team-sheet home-team">
        <h3>Composition: {{ matchData.clubNom }}</h3>
        <div class="players-list">
          <div v-for="player in matchData.compositionClub" :key="player.idJoueur" class="player-card">
            <div class="player-number">{{ player.numeroMaillot }}</div>
            <div class="player-info">
              <div class="player-name">{{ player.prenom }} {{ player.nom }}</div>
              <div class="player-position">{{ player.poste }}</div>
            </div>
            <div v-if="player.isCapitaine" class="captain-badge">C</div>
          </div>
        </div>
      </div>
    </div>

    <!-- Remplacements -->
    <div class="substitutions-section">
      <h3>Remplacements</h3>
      <div class="substitutions-grid">
        <div class="substitution" v-for="sub in matchData.remplacements" :key="sub.id">
          <span class="time">{{ sub.minute }}'</span>
          <div class="substitution-players">
            <span class="player-in">{{ sub.entrant }}</span>
            <span class="sub-arrow">⇄</span>
            <span class="player-out">{{ sub.sortant }}</span>
          </div>
        </div>
      </div>
    </div>

    <!-- Observations -->
    <div class="observations-section">
      <h3>Observations</h3>
      <p v-if="matchData.observations">{{ matchData.observations }}</p>
      <p v-else class="no-data">Aucune observation</p>
    </div>
  </div>
</template>

<script>
export default {
  name: 'FeuilleMatch',
  data() {
    return {
      matchData: {
        idMatch: 1,
        clubNom: 'FC Fanamby',
        clubLogo: null,
        adversaire: 'AS Adversaire',
        adversaireLogo: null,
        competition: 'Championnat Régional',
        dateSeance: '2023-11-15',
        heureDebut: '15:00:00',
        lieu: 'Stade Municipal',
        scoreEquipe: 2,
        scoreAdversaire: 1,
        tempsAdditionnel1: 2,
        tempsAdditionnel2: 3,
        public: 350,
        incidents: "Carton jaune pour le joueur #10 à la 65ème minute",
        observations: "Match bien arbitré dans l'ensemble",
        compositionClub: [
          {
            idJoueur: 1,
            numeroMaillot: 1,
            nom: 'Rakoto',
            prenom: 'Jean',
            poste: 'Gardien',
            isCapitaine: false
          },
          {
            idJoueur: 2,
            numeroMaillot: 4,
            nom: 'Rabe',
            prenom: 'Paul',
            poste: 'Défenseur',
            isCapitaine: true
          },
          {
            idJoueur: 3,
            numeroMaillot: 6,
            nom: 'Randria',
            prenom: 'Marc',
            poste: 'Milieu',
            isCapitaine: false
          },
          {
            idJoueur: 4,
            numeroMaillot: 9,
            nom: 'Rasoa',
            prenom: 'Pierre',
            poste: 'Attaquant',
            isCapitaine: false
          }
        ],
        remplacements: [
          {
            minute: 65,
            sortant: 'Rakoto Jean (#10)',
            entrant: 'Randria Paul (#22)'
          }
        ]
      }
    }
  },
  methods: {
    formatDate(dateString) {
      if (!dateString) return ''
      const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' }
      return new Date(dateString).toLocaleDateString('fr-FR', options)
    },
    formatTime(timeString) {
      if (!timeString) return ''
      return timeString.substring(0, 5)
    },
    fetchMatchData() {
      // Implémentez l'appel API pour récupérer les données du match
      // Exemple:
      // axios.get(`/api/matches/${this.$route.params.id}`)
      //   .then(response => {
      //     this.matchData = response.data
      //   })
      //   .catch(error => {
      //     console.error('Erreur lors du chargement du match:', error)
      //   })
    }
  },
  mounted() {
    this.fetchMatchData()
  }
}
</script>

<style scoped>
.feuille-match-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  color: #333;
}

.match-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30px;
  padding: 20px;
  background-color: #f5f5f5;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.club-info {
  display: flex;
  flex-direction: column;
  align-items: center;
  width: 30%;
}

.team-logo {
  width: 80px;
  height: 80px;
  object-fit: contain;
  margin-bottom: 10px;
  border-radius: 50%;
  background-color: white;
}

.team-logo-placeholder {
  width: 80px;
  height: 80px;
  border-radius: 50%;
  background-color: #ddd;
  margin-bottom: 10px;
}

.match-score {
  display: flex;
  flex-direction: column;
  align-items: center;
  width: 40%;
}

.score-display {
  display: flex;
  align-items: center;
  font-size: 2.5rem;
  margin-bottom: 10px;
}

.score {
  font-weight: bold;
  padding: 0 15px;
}

.separator {
  font-weight: normal;
}

.match-info {
  text-align: center;
  font-size: 0.9rem;
  color: #666;
}

.match-details {
  margin-bottom: 30px;
}

.detail-section {
  background-color: #f9f9f9;
  padding: 15px;
  border-radius: 8px;
  box-shadow: 0 1px 3px rgba(0,0,0,0.1);
}

.detail-section h3 {
  margin-top: 0;
  color: #2c3e50;
  border-bottom: 1px solid #eee;
  padding-bottom: 8px;
}

.no-data {
  color: #95a5a6;
  font-style: italic;
}

.team-compositions {
  margin-bottom: 30px;
}

.team-sheet {
  background-color: #f9f9f9;
  padding: 15px;
  border-radius: 8px;
  box-shadow: 0 1px 3px rgba(0,0,0,0.1);
}

.team-sheet h3 {
  margin-top: 0;
  color: #2c3e50;
  border-bottom: 1px solid #eee;
  padding-bottom: 8px;
}

.players-list {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.player-card {
  display: flex;
  align-items: center;
  padding: 8px 12px;
  background-color: white;
  border-radius: 4px;
  box-shadow: 0 1px 2px rgba(0,0,0,0.1);
}

.player-number {
  font-weight: bold;
  width: 30px;
  text-align: center;
  margin-right: 15px;
  color: #3498db;
}

.player-info {
  flex-grow: 1;
}

.player-name {
  font-weight: 500;
}

.player-position {
  font-size: 0.8rem;
  color: #7f8c8d;
}

.captain-badge {
  background-color: #e74c3c;
  color: white;
  font-size: 0.7rem;
  padding: 2px 6px;
  border-radius: 10px;
  font-weight: bold;
}

.substitutions-section {
  background-color: #f9f9f9;
  padding: 15px;
  border-radius: 8px;
  box-shadow: 0 1px 3px rgba(0,0,0,0.1);
  margin-bottom: 30px;
}

.substitutions-section h3 {
  margin-top: 0;
  color: #2c3e50;
  border-bottom: 1px solid #eee;
  padding-bottom: 8px;
}

.substitutions-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
  gap: 15px;
}

.substitution {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 8px;
  background-color: white;
  border-radius: 4px;
  box-shadow: 0 1px 2px rgba(0,0,0,0.1);
}

.time {
  font-weight: bold;
  color: #e74c3c;
}

.substitution-players {
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.sub-arrow {
  color: #7f8c8d;
  margin: 0 5px;
}

.observations-section {
  background-color: #f9f9f9;
  padding: 15px;
  border-radius: 8px;
  box-shadow: 0 1px 3px rgba(0,0,0,0.1);
}

.observations-section h3 {
  margin-top: 0;
  color: #2c3e50;
  border-bottom: 1px solid #eee;
  padding-bottom: 8px;
}

@media (max-width: 768px) {
  .match-header {
    flex-direction: column;
  }
  
  .club-info, .match-score {
    width: 100%;
    margin-bottom: 15px;
  }
}
</style>