<template>
  <div class="composition-insert-container">
    <h2>Insertion d'une composition d'équipe</h2>
    <form @submit.prevent="submitForm" class="form-container">
      <div class="form-group">
        <label>Match :</label>
        <select v-model="form.idMatch" required>
          <option value="">-- Choisir un match --</option>
          <option v-for="match in matches" :key="match.idMatch" :value="match.idMatch">
            {{ formatMatchLabel(match) }}
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
        <select v-model="form.idStatutComposition" required>
          <option value="">-- Choisir un statut --</option>
          <option v-for="status in playerStatuses" :key="status.idStatutComposition" :value="status.idStatutComposition">
            {{ status.libelle }}
          </option>
        </select>
      </div>
      <div class="form-row">
        <div class="form-group">
          <label>Numéro maillot :</label>
          <input type="number" v-model.number="form.numeroMaillot" min="1" max="99">
        </div>
        <div class="form-group">
          <label>Position :</label>
          <input type="text" v-model="form.position">
        </div>
      </div>
      <div class="form-group">
        <label>
          <input type="checkbox" v-model="form.isCapitaine"> Capitaine
        </label>
      </div>
      <div class="form-group">
        <label>Commentaire :</label>
        <textarea v-model="form.commentaire"></textarea>
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

const matches = ref([]);
const players = ref([]);
const playerStatuses = ref([
  { idStatutComposition: 1, libelle: 'Titulaire' },
  { idStatutComposition: 2, libelle: 'Remplacant' },
  { idStatutComposition: 3, libelle: 'Blessé' },
  { idStatutComposition: 4, libelle: 'Suspendu' },
  { idStatutComposition: 5, libelle: 'Autre' }
]);

const form = ref({
  idMatch: '',
  idJoueur: '',
  idStatutComposition: '',
  numeroMaillot: '',
  position: '',
  isCapitaine: false,
  commentaire: ''
});

const successMessage = ref('');

const fetchMatches = async () => {
  matches.value = [
    { idMatch: 1, competition: 'Championnat Régional', adversaire: 'FC Olympique', dateMatch: '2023-10-15' },
    { idMatch: 2, competition: 'Coupe Nationale', adversaire: 'AS Victory', dateMatch: '2023-10-22' }
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

const formatMatchLabel = (match) => {
  return `${match.competition} vs ${match.adversaire} (${match.dateMatch})`;
};

const submitForm = () => {
  // Ici, vous pouvez envoyer les données à une API ou les stocker localement
  successMessage.value = "Composition ajoutée avec succès !";
  resetForm();
  setTimeout(() => { successMessage.value = ''; }, 2500);
};

const resetForm = () => {
  form.value = {
    idMatch: '',
    idJoueur: '',
    idStatutComposition: '',
    numeroMaillot: '',
    position: '',
    isCapitaine: false,
    commentaire: ''
  };
};

onMounted(() => {
  fetchMatches();
  fetchPlayers();
});
</script>

<style scoped>
.composition-insert-container {
  padding: 20px;
  max-width: 600px;
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
.form-group input,
.form-group textarea {
  width: 100%;
  padding: 8px;
  border: 1px solid #ddd;
  border-radius: 4px;
}
.form-row {
  display: flex;
  gap: 20px;
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
