<template>
  <div class="presence-insert-container">
    <h2>Insertion d'une présence</h2>
    <form @submit.prevent="submitForm" class="form-container">
      <div class="form-group">
        <label>Séance :</label>
        <select v-model="form.idSeance" required>
          <option value="">-- Choisir une séance --</option>
          <option v-for="session in sessions" :key="session.idSeance" :value="session.idSeance">
            {{ formatSessionLabel(session) }}
          </option>
        </select>
      </div>
      <div class="form-group">
        <label>Joueur :</label>
        <select v-model="form.idJoueur" required>
          <option value="">-- Choisir un joueur --</option>
          <option v-for="player in players" :key="player.idJoueur" :value="player.idJoueur">
            {{ player.nom }} {{ player.prenom }} ({{ player.poste }})
          </option>
        </select>
      </div>
      <div class="form-group">
        <label>Statut :</label>
        <select v-model="form.idStatutPresence" required>
          <option value="">-- Choisir un statut --</option>
          <option v-for="status in presenceStatuses" :key="status.idStatutPresence" :value="status.idStatutPresence">
            {{ status.libelle }}
          </option>
        </select>
      </div>
      <div class="form-group">
        <label>Commentaire :</label>
        <input type="text" v-model="form.commentaire" placeholder="Commentaire">
      </div>
      <div class="form-actions">
        <button type="submit" class="btn-submit">Ajouter</button>
        <button type="button" @click="resetForm" class="btn-cancel">Annuler</button>
      </div>
      <div v-if="successMessage" class="success-message">{{ successMessage }}</div>
    </form>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';

const sessions = ref([]);
const players = ref([]);
const presenceStatuses = ref([
  { idStatutPresence: 1, libelle: 'Present', code: 'P' },
  { idStatutPresence: 2, libelle: 'Absent', code: 'A' },
  { idStatutPresence: 3, libelle: 'Retard', code: 'R' },
  { idStatutPresence: 4, libelle: 'Excusé', code: 'E' }
]);

const form = ref({
  idSeance: '',
  idJoueur: '',
  idStatutPresence: '',
  commentaire: ''
});

const successMessage = ref('');

const fetchSessions = async () => {
  sessions.value = [
    { idSeance: 1, type: 'Entrainement', dateSeance: '2023-10-15', heureDebut: '08:00' },
    { idSeance: 2, type: 'Match amical', dateSeance: '2023-10-20', heureDebut: '15:00' }
  ];
};

const fetchPlayers = async () => {
  players.value = [
    { idJoueur: 1, nom: 'Dupont', prenom: 'Jean', poste: 'Attaquant' },
    { idJoueur: 2, nom: 'Martin', prenom: 'Pierre', poste: 'Milieu' },
    { idJoueur: 3, nom: 'Bernard', prenom: 'Luc', poste: 'Défenseur' },
    { idJoueur: 4, nom: 'Petit', prenom: 'Antoine', poste: 'Gardien' }
  ];
};

const formatSessionLabel = (session) => {
  return `${session.type} - ${session.dateSeance} (${session.heureDebut})`;
};

const submitForm = () => {
  // Ici, vous pouvez envoyer les données à une API ou les stocker localement
  successMessage.value = "Présence ajoutée avec succès !";
  resetForm();
  setTimeout(() => { successMessage.value = ''; }, 2500);
};

const resetForm = () => {
  form.value = {
    idSeance: '',
    idJoueur: '',
    idStatutPresence: '',
    commentaire: ''
  };
};

onMounted(() => {
  fetchSessions();
  fetchPlayers();
});
</script>

<style scoped>
.presence-insert-container {
  padding: 20px;
  max-width: 500px;
  margin: 0 auto;
}
.form-container {
  background-color: #f5f5f5;
  padding: 20px;
  border-radius: 8px;
  margin-bottom: 20px;
}
.form-group {
  margin-bottom: 15px;
}
.form-group label {
  display: block;
  margin-bottom: 5px;
  font-weight: bold;
}
.form-group select,
.form-group input {
  width: 100%;
  padding: 8px;
  border: 1px solid #ddd;
  border-radius: 4px;
}
.form-actions {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
}
.btn-submit {
  background-color: #2ecc71;
  color: white;
  padding: 8px 15px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}
.btn-cancel {
  background-color: #e74c3c;
  color: white;
  padding: 8px 15px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}
.success-message {
  color: #2ecc71;
  margin-top: 10px;
  font-weight: bold;
}
</style>
