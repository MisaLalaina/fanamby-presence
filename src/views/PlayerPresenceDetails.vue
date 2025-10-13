<template>
  <div class="modal-overlay" @click.self="$emit('close')">
    <div class="modal player-details-modal">
      <div class="modal-header">
        <h3>Détails de Présence pour {{ player.prenom }} {{ player.nom }}</h3>
        <button @click="$emit('close')" class="btn-close-modal">
          <i class="fas fa-times"></i>
        </button>
      </div>
      
      <div class="player-summary">
        <div class="stat-item">
          <span class="stat-number">{{ player.tauxGeneral }}%</span>
          <span class="stat-text">Taux Global</span>
        </div>
        <div class="stat-item">
          <span class="stat-number">{{ player.tauxEntrainement }}%</span>
          <span class="stat-text">Taux Entraînement</span>
        </div>
        <div class="stat-item">
          <span class="stat-number">{{ player.tauxMatch }}%</span>
          <span class="stat-text">Taux Match</span>
        </div>
      </div>

      <div class="table-container">
        <table class="sessions-table">
          <thead>
            <tr>
              <th>Date</th>
              <th>Type de Séance</th>
              <th>Statut</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="session in filteredDetails" :key="session.idSeance">
              <td>{{ formatDate(session.dateSeance) }}</td>
              <td>{{ session.typeSeance }}</td>
              <td>
                <span :class="['status-badge', session.presenceStatus]">
                  {{ formatStatus(session.presenceStatus) }}
                </span>
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <div class="modal-footer">
        <button @click="$emit('close')" class="btn-cancel">Fermer</button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { defineProps, ref, onMounted, computed } from 'vue';
import { getPresencesByPlayerId } from '@/services/PresenceService'; // Assurez-vous d'avoir ce service

const props = defineProps({
  player: {
    type: Object,
    required: true
  }
});

const playerDetails = ref([]);

// Propriété calculée pour le tri et le filtrage (si nécessaire)
const filteredDetails = computed(() => {
  // Tri par date du plus récent au plus ancien
  return playerDetails.value.slice().sort((a, b) => new Date(b.dateSeance) - new Date(a.dateSeance));
});

// Fonctions utilitaires
const formatDate = (dateString) => {
  const options = { day: 'numeric', month: 'short', year: 'numeric' };
  return new Date(dateString).toLocaleDateString('fr-FR', options);
};

const formatStatus = (status) => {
  if (status === 'Present') return 'Présent ✅';
  if (status === 'Absent') return 'Absent ❌';
  return status;
};

// Chargement des données au montage du composant
onMounted(async () => {
  try {
    // NOTE: Il faut implémenter 'getPresencesByPlayerId' dans votre PresenceService
    // Cette fonction devrait retourner une liste de : { idSeance, dateSeance, typeSeance, presenceStatus }
    playerDetails.value = await getPresencesByPlayerId(props.player.id); 
  } catch (error) {
    console.error("Erreur chargement détails joueur:", error);
    // Gérer l'erreur (affichage d'un message)
  }
});
</script>

<style scoped>
/* Les styles de base de 'modal-overlay' et 'modal' peuvent être repris de votre fichier principal */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.6);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 2000; /* Plus haut que les autres popups */
}

.player-details-modal {
  max-width: 700px;
  width: 90%;
  padding: 0; /* Suppression du padding pour mieux gérer le header/footer */
  max-height: 90vh;
  display: flex;
  flex-direction: column;
}

.modal-header {
    background-color: #2493BF;
    color: white;
    padding: 15px 25px;
    border-radius: 10px 10px 0 0;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.modal-header h3 {
    margin: 0;
    color: white;
    border: none;
    padding: 0;
}

.btn-close-modal {
    background: none;
    border: none;
    color: white;
    font-size: 1.5em;
    cursor: pointer;
}

.player-summary {
    display: flex;
    justify-content: space-around;
    padding: 20px;
    background-color: #f8f9fa;
    border-bottom: 1px solid #eee;
}

.stat-item {
    text-align: center;
}

.stat-number {
    font-size: 20px;
    font-weight: 700;
    color: #2493BF;
    display: block;
}

.stat-text {
    font-size: 12px;
    color: #7f8c8d;
}

.table-container {
    overflow-y: auto;
    padding: 15px 25px;
    flex-grow: 1;
}

.sessions-table {
    width: 100%;
    border-collapse: collapse;
}

.sessions-table th, .sessions-table td {
    padding: 10px;
    text-align: left;
    border-bottom: 1px solid #eee;
}

.sessions-table th {
    background-color: #f0f0f0;
}

.status-badge {
    padding: 4px 8px;
    border-radius: 4px;
    font-size: 0.85em;
    font-weight: 600;
}

.status-badge.Present {
    background-color: #e6f7ee;
    color: #27ae60;
}

.status-badge.Absent {
    background-color: #fcebeb;
    color: #e74c3c;
}

.modal-footer {
    padding: 15px 25px;
    border-top: 1px solid #eee;
    text-align: right;
}

.btn-cancel {
  padding: 10px 20px;
  background-color: #95a5a6;
  color: white;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  transition: background-color 0.3s;
}

.btn-cancel:hover {
  background-color: #7f8c8d;
}
</style>