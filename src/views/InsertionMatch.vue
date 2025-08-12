<script setup>
import { ref, computed, onMounted } from 'vue';

const sessions = ref([]);
const form = ref({
  idSeance: '',
  competition: '',
  adversaire: '',
  domicile: true,
  scoreEquipe: 0,
  scoreAdversaire: 0,
  incidents: '',
  observations: ''
});
const successMessage = ref('');

const fetchSessions = async () => {
  sessions.value = [
    {
      idSeance: 1,
      dateSeance: '2023-10-15',
      heureDebut: '08:00',
      heureFin: '10:00',
      lieu: 'Terrain principal',
      objectif: 'Amélioration des passes et du jeu collectif'
    },
    {
      idSeance: 2,
      dateSeance: '2023-10-20',
      heureDebut: '15:00',
      heureFin: '17:00',
      lieu: 'Stade municipal',
      objectif: 'Tester de nouvelles combinaisons offensives'
    }
  ];
};

const selectedSeance = computed(() => {
  return sessions.value.find(s => s.idSeance == form.value.idSeance) || {};
});

const formatSessionLabel = (session) => {
  return `${session.dateSeance} (${session.heureDebut}) - ${session.lieu}`;
};

const formatDate = (dateStr) => {
  const options = { year: 'numeric', month: 'short', day: 'numeric' };
  return new Date(dateStr).toLocaleDateString('fr-FR', options);
};

const submitForm = () => {
  // Ici, vous pouvez envoyer les données à une API ou les stocker localement
  successMessage.value = "Match ajouté avec succès !";
  resetForm();
  setTimeout(() => { successMessage.value = ''; }, 2500);
};

const resetForm = () => {
  form.value = {
    idSeance: '',
    competition: '',
    adversaire: '',
    domicile: true,
    scoreEquipe: 0,
    scoreAdversaire: 0,
    public: '',
    incidents: '',
    observations: ''
  };
};

onMounted(() => {
  fetchSessions();
});
</script>


<template>
  <div class="match-insert-container">
    <h2>Insertion d'un match</h2>
    <form @submit.prevent="submitForm" class="form-container">
      <div class="form-group">
        <label>Séance associée :</label>
        <select v-model="form.idSeance" required>
          <option value="">-- Choisir une séance --</option>
          <option v-for="session in sessions" :key="session.idSeance" :value="session.idSeance">
            {{ formatSessionLabel(session) }}
          </option>
        </select>
      </div>
      <div v-if="form.idSeance" class="seance-info">
        <p><strong>Date :</strong> {{ formatDate(selectedSeance.dateSeance) }}</p>
        <p><strong>Heure :</strong> {{ selectedSeance.heureDebut }} - {{ selectedSeance.heureFin }}</p>
        <p><strong>Lieu :</strong> {{ selectedSeance.lieu }}</p>
        <p><strong>Objectif :</strong> {{ selectedSeance.objectif }}</p>
      </div>
      <div class="form-group">
        <label>Compétition :</label>
        <input type="text" v-model="form.competition" required placeholder="Nom de la compétition">
      </div>
      <div class="form-group">
        <label>Adversaire :</label>
        <input type="text" v-model="form.adversaire" required placeholder="Nom de l'adversaire">
      </div>
      <div class="form-group">
        <label>Lieu :</label>
        <select v-model="form.domicile" required>
          <option :value="true">Domicile</option>
          <option :value="false">Extérieur</option>
        </select>
      </div>
      <div class="form-group">
        <label>Score équipe :</label>
        <input type="number" v-model.number="form.scoreEquipe" min="0" required>
      </div>
      <div class="form-group">
        <label>Score adversaire :</label>
        <input type="number" v-model.number="form.scoreAdversaire" min="0" required>
      </div>
      <div class="form-group">
        <label>Incidents :</label>
        <textarea v-model="form.incidents" placeholder="Incidents (optionnel)"></textarea>
      </div>
      <div class="form-group">
        <label>Observations :</label>
        <textarea v-model="form.observations" placeholder="Observations (optionnel)"></textarea>
      </div>
      <div class="form-actions">
        <button type="submit" class="btn-submit">Ajouter</button>
        <button type="button" @click="resetForm" class="btn-cancel">Annuler</button>
      </div>
      <div v-if="successMessage" class="success-message">{{ successMessage }}</div>
    </form>
  </div>
</template>

<style scoped>
.match-insert-container {
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
.seance-info {
  background: #e9f7fe;
  padding: 10px;
  border-radius: 4px;
  margin-bottom: 15px;
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
