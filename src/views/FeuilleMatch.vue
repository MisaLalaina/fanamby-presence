<template>
  <div class="feuille-match-container">
    
    <h1 class="page-title">
        Match vs {{ matchData.adversaire }} 
        <span class="competition-tag">{{ matchData.competition }}</span>
    </h1>

    <div class="action-bar">
        <button 
            @click="voirPresence(matchData.idSeance)" 
            class="btn-action btn-presence" 
            title="Voir fiche de présence"
            :disabled="!matchData.idSeance"
        >
            <span class="icon">📋</span> Fiche de Présence
        </button>
    </div>

    <div class="match-header">
      
      <div class="club-info home-team">
        <img v-if="matchData.clubLogo" :src="matchData.clubLogo" :alt="matchData.clubNom" class="team-logo">
        <div v-else class="team-logo-placeholder"></div>
        <span class="team-name">Fanamby</span>
      </div>
      
      <div class="match-details-central">
        <div class="score-display">
          <span class="score home">{{ matchData.scoreEquipe }}</span>
          <span class="separator">-</span>
          <span class="score away">{{ matchData.scoreAdversaire }}</span>
        </div>
        <div class="match-info">
          <p class="match-date-time">{{ formatDate(matchData.dateSeance) }} à {{ formatTime(matchData.heureDebut) }}</p>
          <p class="match-location" v-if="seanceData">📍 {{ seanceData.lieu }}</p>
        </div>
      </div>
      
      <div class="club-info away-team">
        <img v-if="matchData.adversaireLogo" :src="matchData.adversaireLogo" :alt="matchData.adversaire" class="team-logo">
        <div v-else class="team-logo-placeholder"></div>
        <span class="team-name">{{ matchData.adversaire }}</span>
      </div>
    </div>
    
    <hr class="section-divider">

    <div class="team-compositions">
      <div class="team-sheet">
        <h3>Composition de Départ (Titulaires)</h3>
        <div class="substitutions-grid">
          <div v-for="player in matchData.compositionClub" :key="player.idJoueur" class="player-card starter">
            <div class="player-number">{{ player.numeroMaillot }}</div>
            <div class="player-info">
              <div class="player-name">{{ player.prenom }} {{ player.nom }}</div>
              <div class="player-position">{{ player.poste }}</div>
            </div>
            <div v-if="player.isCapitaine" class="captain-badge">C</div>
          </div>
          <p v-if="matchData.compositionClub.length === 0" class="no-data">Composition non enregistrée.</p>
        </div>
      </div>
    </div>

    <div class="substitutions-section">
      <h3>Remplaçants</h3>
      <div v-if="matchData.remplacents.length > 0" class="substitutions-grid">
        <div v-for="player in matchData.remplacents" :key="player.idJoueur" class="player-card sub">
          <div class="player-number">{{ player.numeroMaillot }}</div>
          <div class="player-info">
            <div class="player-name">{{ player.prenom }} {{ player.nom }}</div>
            <div class="player-position">{{ player.poste }}</div>
          </div>
        </div>
      </div>
      <p v-else class="no-data">Aucun remplaçant enregistré.</p>
    </div>
    
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { getMatchById } from '@/services/MatchFootService.js';
import { getAllCompositionsByMatchId } from '@/services/CompositionService.js';
import { getPresencesByIdSeance } from '@/services/PresenceService.js';
import seanceService from '@/services/SeanceService.js'
import TypeSeanceService from '@/services/TypeSeanceService';

const route = useRoute();
const matchId = route.params.id;
const matchData = ref({
  scoreEquipe: 0,
  scoreAdversaire: 0,
  adversaire: 'Adversaire Inconnu',
  competition: 'Compétition Inconnue',
  compositionClub: [],
  remplacents: [],
  idSeance: null
});
const seanceData = ref(null);
const presences = ref([]);

const router = useRouter();
const voirPresence = (idSeance) => {
  router.push({ path: `/presences/${idSeance}` });
}

const fetchMatchData = async () => {
  try {
    const match = await getMatchById(matchId);
    let compositions =  [ ]
    try {
      compositions = await getAllCompositionsByMatchId(match.idMatch);
    } catch (error) {
      console.error(error);
      alert("Aucune composition trouver")
    } 
    matchData.value = {
      ...match,
      compositionClub: compositions.filter(c => c.idStatutComposition === 1),
      remplacents: compositions.filter(c => c.idStatutComposition === 2),
    };

    if(match.idSeance) {
      const seance = await seanceService.getSeanceById(match.idSeance);
      const tps = await TypeSeanceService.getTypeSeanceById(seance.idTypeSeance);
      seanceData.value = {
        ...seance,
        typeSeance: tps.libelle,
      };
      
      const presenceResponse = await getPresencesByIdSeance(match.idSeance);
      presences.value = presenceResponse;
    }
    
  } catch (error) {
    console.error('Erreur lors du chargement du match:', error);
  }
};

const formatDate = (dateString) => {
  if (!dateString) return '';
  const options = { year: 'numeric', month: 'long', day: 'numeric' };
  return new Date(dateString).toLocaleDateString('fr-FR', options);
};

const formatTime = (timeString) => {
  if (!timeString) return '';
  return timeString.substring(0, 5);
};

onMounted(() => {
  fetchMatchData();
});
</script>


<style scoped>
/* Définition des variables de couleurs pour la cohérence */
:root {
  --primary-color: #3498db; /* Bleu */
  --secondary-color: #e74c3c; /* Rouge (couleur d'accent/erreur) */
  --warning-color: #f39c12; /* Jaune/Orange */
  --light-bg: #f9f9f9;
  --dark-text: #2c3e50;
  --gray-text: #7f8c8d;
}

.feuille-match-container {
  max-width: 1000px;
  margin: 0 auto;
  padding: 20px;
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  color: var(--dark-text);
}

/* --- TITRE ET ACTIONS --- */
.page-title {
    text-align: center;
    font-size: 2.2rem;
    color: var(--dark-text);
    margin-bottom: 5px;
    font-weight: 700;
}

.competition-tag {
    display: block;
    font-size: 1rem;
    font-weight: 400;
    color: var(--gray-text);
    margin-top: 5px;
}

.action-bar {
    text-align: center;
    margin-bottom: 30px;
}

.btn-action {
    background-color: var(--primary-color);
    color: white;
    padding: 10px 20px;
    border: none;
    border-radius: 6px;
    cursor: pointer;
    font-size: 1rem;
    font-weight: 600;
    transition: background-color 0.3s;
    display: inline-flex;
    align-items: center;
    gap: 8px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.btn-action:hover:not(:disabled) {
    background-color: #2980b9;
}

.btn-action:disabled {
    background-color: #bdc3c7;
    cursor: not-allowed;
}

.section-divider {
    border: 0;
    height: 1px;
    background: #e0e0e0;
    margin: 30px 0;
}


/* --- EN-TÊTE DE MATCH (Score & Infos) --- */

.match-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30px;
  padding: 20px 40px;
  background-color: white;
  border-radius: 12px;
  border: 1px solid #ddd;
  box-shadow: 0 4px 10px rgba(0,0,0,0.05);
}

.club-info {
  display: flex;
  flex-direction: column;
  align-items: center;
  width: 25%;
}

.team-logo {
  width: 70px;
  height: 70px;
  object-fit: contain;
  margin-bottom: 8px;
  border-radius: 50%;
  background-color: var(--light-bg);
  border: 2px solid var(--light-bg);
}

.team-logo-placeholder {
  width: 70px;
  height: 70px;
  border-radius: 50%;
  background-color: #ddd;
  margin-bottom: 8px;
}

.team-name {
    font-size: 1.1rem;
    font-weight: 600;
    text-align: center;
}

.match-details-central {
  display: flex;
  flex-direction: column;
  align-items: center;
  width: 50%;
}

.score-display {
  display: flex;
  align-items: center;
  font-size: 3.5rem;
  margin-bottom: 10px;
  font-weight: 800;
  font-family: 'Inter', sans-serif;
}

.score {
  padding: 0 15px;
}

.score.home {
    color: var(--primary-color);
}
.score.away {
    color: var(--secondary-color);
}

.separator {
  font-weight: normal;
  color: var(--gray-text);
}

.match-info {
  text-align: center;
  font-size: 0.95rem;
  color: #666;
}

.match-date-time {
    font-weight: 600;
    color: var(--dark-text);
    margin-bottom: 5px;
}
.match-location {
    font-style: italic;
    color: var(--gray-text);
}

/* --- SECTIONS DE JOUEURS --- */

.team-compositions, .substitutions-section {
    margin-bottom: 30px;
    padding: 15px;
    background-color: var(--light-bg);
    border-radius: 10px;
}

.team-sheet h3, .substitutions-section h3 {
    margin-top: 0;
    font-size: 1.5rem;
    padding-bottom: 10px;
    border-bottom: 2px solid #eee;
    margin-bottom: 15px;
    font-weight: 700;
}

.team-sheet h3 {
    color: var(--primary-color);
}

.substitutions-section h3 {
    color: var(--warning-color);
}

.players-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.substitutions-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
    gap: 15px;
}

.player-card {
  display: flex;
  align-items: center;
  padding: 10px 15px;
  background-color: white;
  border-radius: 6px;
  box-shadow: 0 2px 5px rgba(0,0,0,0.05);
  transition: all 0.2s ease-in-out;
  border-left: 5px solid;
}

.player-card.starter {
    border-left-color: var(--primary-color);
}

.player-card.sub {
    border-left-color: var(--warning-color);
}

.player-card:hover {
    box-shadow: 0 4px 8px rgba(0,0,0,0.1);
    transform: translateY(-2px);
}

.player-number {
  font-weight: bold;
  font-size: 1.3rem;
  width: 40px;
  text-align: center;
  margin-right: 15px;
  color: var(--dark-text);
  border-right: 1px solid #eee;
}

.player-info {
  flex-grow: 1;
}

.player-name {
  font-weight: 600;
  font-size: 1.05rem;
}

.player-position {
  font-size: 0.85rem;
  color: var(--gray-text);
}

.captain-badge {
  background-color: var(--primary-color);
  color: white;
  font-size: 0.75rem;
  padding: 3px 8px;
  border-radius: 15px;
  font-weight: bold;
}

.no-data {
  color: var(--gray-text);
  font-style: italic;
  padding: 10px 0;
  text-align: center;
}


/* --- RESPONSIVE --- */
@media (max-width: 768px) {
    .page-title {
        font-size: 1.8rem;
    }
    
    .match-header {
        flex-direction: column;
        padding: 20px;
    }
    
    .club-info {
        width: 100%;
        margin-bottom: 15px;
    }
    
    .match-details-central {
        width: 100%;
        order: -1; /* Place le score au-dessus des équipes sur mobile */
        margin-bottom: 15px;
    }
    
    .score-display {
        font-size: 3rem;
    }
    
    .team-name {
        margin-top: 5px;
    }

    .substitutions-grid {
        grid-template-columns: 1fr;
    }
}
</style>