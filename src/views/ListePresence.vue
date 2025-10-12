<script setup>
  import { ref, onMounted } from 'vue';
  import { getAllPresenceStatus } from '@/services/PresenceStatusService';
  import { getPresencesByIdSeance } from '@/services/PresenceService.js';
  import SeanceService from '@/services/SeanceService';
  import { Seance } from '@/models/seance';


  // Reactive state
  const sessions = ref([]);
  const players = ref([]);
  const selectedSession = ref('');
  const currentSession = ref({});
  const presenceStatuses = ref([]);
  const isEditing = ref(false);

  // Fetch presence statuses (async inside onMounted or a separate async fn)
  const loadPresenceStatuses = async () => {
    const response = await getAllPresenceStatus();
    presenceStatuses.value = response.data.content;
  };

  // Simulated API fetch for sessions
  const fetchSessions = async () => {
    const response = await SeanceService.getAllSeances();
    sessions.value = Seance.formatSeances(response);
  };

  // Load presence data for the selected session
  const loadPresences = async () => {
    if (!selectedSession.value) return;
    currentSession.value = sessions.value.find(s => s.idSeance === selectedSession.value) || {};
    try {
      players.value = await getPresencesByIdSeance(selectedSession.value);
      console.log(players);
    } catch (error) {
      alert("Erreur lors du chargement des présences : " + error.message);
      players.value = [];
    }
  };

  // Fonction pour basculer le mode d'édition
  const toggleEditMode = () => {
      isEditing.value = !isEditing.value;
      // Si on quitte le mode édition, on peut choisir de sauvegarder
      // ou de recharger les données originales.
      if (!isEditing.value) {
          // Option 1: Recharger les données pour annuler les changements non sauvegardés
          // loadPresences();
          
          // Option 2: Laisser les changements locaux et forcer la sauvegarde (ou demander confirmation)
          // Pour l'instant, nous allons laisser les changements locaux, mais on va
          // encourager l'utilisation du bouton "Enregistrer".
      }
  };

  // Simulate updating presence status in database
  const updatePresence = async (player) => {
    console.log('Mise à jour présence:', {
      idJoueur: player.idJoueur,
      idSeance: selectedSession.value,
      idstatutpresence: player.presenceStatus,
      commentaire: player.commentaire
    });
  };

  // Save all presence changes
  const saveAllPresences = async () => {
    for (const player of players.value) {
      await updatePresence(player);
    }
    alert('Toutes les présences ont été enregistrées avec succès!');
  };

  // Helpers to format session labels and dates
  const formatSessionLabel = (session) => {
    return `${session.type} - ${formatDate(session.dateSeance)} (${session.heureDebut})`;
  };

  const formatDate = (dateStr) => {
    const options = { year: 'numeric', month: 'short', day: 'numeric' };
    return new Date(dateStr).toLocaleDateString('fr-FR', options);
  };

  // Helper to get status label from ID
  const getStatusLabel = (idStatut) => {
      const status = presenceStatuses.value.find(s => s.idstatutpresence === idStatut);
      return status ? status.libelle : 'Inconnu';
  };

  // Initialization on mount
  onMounted(async () => {
    await loadPresenceStatuses();
    await fetchSessions();
    await loadPresences();
  });
</script>



<template>
  <div class="presence-container">
    <h2>Gestion des Présences</h2>

    <!-- Sélection de la séance -->
    <div class="session-selector">
      <div class="form-group">
        <label>Sélectionner une séance :</label>
        <select v-model="selectedSession" @change="loadPresences">
          <option value="">-- Choisir une séance --</option>
          <option v-for="session in sessions" :key="session.idSeance" :value="session.idSeance">
            {{ formatSessionLabel(session) }}
          </option>
        </select>
      </div>

      <div v-if="selectedSession" class="session-info">
        <h3>{{ currentSession.type }} - {{ formatDate(currentSession.dateSeance) }}</h3>
        <p>{{ currentSession.heureDebut }} à {{ currentSession.heureFin }} | {{ currentSession.lieu }}</p>
        <p>Objectif : {{ currentSession.objectif }}</p>
      </div>
    </div>

    <!-- Liste des joueurs -->
    <div v-if="selectedSession" class="presence-list">
      <table>
        <thead>
          <tr>
            <th>Joueur</th>
            <th>Poste</th>
            <th>Statut</th>
            <th>Commentaire</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="player in players" :key="player.idJoueur" :class="'presence-status-'+player.idStatutPresence">
            <td>{{ player.nom }} {{ player.prenom }}</td>
            <td>{{ player.poste }}</td>
            <td>
              <select v-if="isEditing" v-model="player.idStatutPresence" @change="updatePresence(player)">
                <option v-for="status in presenceStatuses" :key="status.idstatutpresence" :value="status.idstatutpresence">
                  {{ status.libelle }}
                </option>
              </select>
              <span v-else>
                {{ getStatusLabel(player.idStatutPresence) }}
              </span>
            </td>
            <td>
              <input v-if="isEditing" type="text" v-model="player.commentaire" @blur="updatePresence(player)" placeholder="Commentaire">
              <span v-else class="comment-text">
                {{ player.commentaire || '—' }}
              </span>
            </td>
          </tr>
        </tbody>
      </table>

      <div class="actions">
        <button @click="toggleEditMode" :class="['btn-edit', { 'btn-cancel': isEditing }]">
            {{ isEditing ? 'Annuler l\'édition' : 'Mode Modification' }}
        </button>

        <button v-if="isEditing" @click="saveAllPresences" class="btn-save">
            Enregistrer les modifications ({{ players.length }} lignes)
        </button>
      </div>
    </div>

    <div v-else class="no-session">
      <p>Veuillez sélectionner une séance pour gérer les présences</p>
    </div>
  </div>
</template>

<style scoped>

.presence-container {
  padding: 20px;
  max-width: 1200px;
  margin: 0 auto;
}

.session-selector {
  margin-bottom: 30px;
  padding: 15px;
  background-color: #f5f5f5;
  border-radius: 8px;
}

.form-group {
  margin-bottom: 15px;
}

.form-group label {
  display: block;
  margin-bottom: 5px;
  font-weight: bold;
}

.form-group select {
  width: 100%;
  padding: 8px;
  border: 1px solid #ddd;
  border-radius: 4px;
}

.session-info {
  margin-top: 15px;
  padding: 10px;
  background-color: #e9f7fe;
  border-radius: 4px;
}

.session-info h3 {
  margin: 0 0 5px 0;
  color: #3498db;
}

.presence-list {
  margin-top: 20px;
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

select, input[type="text"] {
  padding: 8px;
  border: 1px solid #ddd;
  border-radius: 4px;
  width: 100%;
}
.presence-status-2 {
  background-color: rgb(241, 241, 193);
}

.actions {
  text-align: right;
  margin-top: 20px;
}

.btn-save {
  background-color: #2ecc71;
  color: white;
  padding: 10px 20px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 16px;
}

.btn-save:hover {
  background-color: #27ae60;
}

.no-session {
  text-align: center;
  padding: 40px;
  background-color: #f9f9f9;
  border-radius: 8px;
  color: #777;
}
</style>