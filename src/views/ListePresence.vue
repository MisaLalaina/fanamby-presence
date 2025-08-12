<script setup>
  import { ref, onMounted } from 'vue';
  import { getAllPresenceStatus } from '@/services/PresenceStatusService';
  import SeanceService from '@/services/SeanceService';
  import { Seance } from '@/models/seance';


  // Reactive state
  const sessions = ref([]);
  const players = ref([]);
  const selectedSession = ref('');
  const currentSession = ref({});
  const presenceStatuses = ref([]);

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

  // Simulated API fetch for players
const fetchPlayers = async () => {
    players.value = [
      { idJoueur: 1, nom: 'Dupont', prenom: 'Jean', poste: 'Attaquant', presenceStatus: 1, commentaire: '' },
      { idJoueur: 2, nom: 'Martin', prenom: 'Pierre', poste: 'Milieu', presenceStatus: 1, commentaire: '' },
      { idJoueur: 3, nom: 'Bernard', prenom: 'Luc', poste: 'Défenseur', presenceStatus: 2, commentaire: 'Blessé' },
      { idJoueur: 4, nom: 'Petit', prenom: 'Antoine', poste: 'Gardien', presenceStatus: 3, commentaire: 'Retard 15min' }
    ];
  };

  // Load presence data for the selected session
  const loadPresences = async () => {
    if (!selectedSession.value) return;
    currentSession.value = sessions.value.find(s => s.idSeance == selectedSession.value) || {};
    await fetchPlayers();
  };

  // Simulate updating presence status in database
  const updatePresence = async (player) => {
    console.log('Mise à jour présence:', {
      idJoueur: player.idJoueur,
      idSeance: selectedSession.value,
      idStatutPresence: player.presenceStatus,
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
          <tr v-for="player in players" :key="player.idJoueur">
            <td>{{ player.nom }} {{ player.prenom }}</td>
            <td>{{ player.poste }}</td>
            <td>
              <select v-model="player.presenceStatus" @change="updatePresence(player)">
                <option v-for="status in presenceStatuses" :key="status.idStatutPresence" :value="status.idStatutPresence">
                  {{ status.libelle }}
                </option>
              </select>
            </td>
            <td>
              <input type="text" v-model="player.commentaire" @blur="updatePresence(player)" placeholder="Commentaire">
            </td>
          </tr>
        </tbody>
      </table>

      <div class="actions">
        <button @click="saveAllPresences" class="btn-save">Enregistrer toutes les modifications</button>
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