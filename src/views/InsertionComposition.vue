<script setup>
  import { ref, onMounted } from 'vue';
  import { createComposition, getAllStatutCompositions  } from '@/services/CompositionService';
  import { getAllJoueurs } from '@/services/JoueurService';
  import { Joueur } from '@/models/joueur';
  import { getAllMatches } from '@/services/MatchFootService.js';
  
  const matches = ref([]);
  const players = ref([]);
  const playerStatuses = ref([]);
  const successMessage = ref('');

  const form = ref({
    idMatch: '',
    idJoueur: '',
    idStatutComposition: '',
    numeroMaillot: '',
    position: '',
    isCapitaine: false,
    commentaire: ''
  });



  const fetchMatches = async () => {
    matches.value = await getAllMatches();
  };

  const fetchPlayers = async () => {
      const joueursResp = await getAllJoueurs();
      players.value = Joueur.listFromApiData(joueursResp);
  };

  const fetchPlayerStatuses = async () => {
    playerStatuses.value = await getAllStatutCompositions();
    
  }

  const formatMatchLabel = (match) => {
    return `${match.competition} vs ${match.adversaire} (${match.dateMatch})`;
  };

  const submitForm = async () => {
    try {
      await createComposition(form.value);
      successMessage.value = "Composition ajoutée avec succès !";
      resetForm();
      setTimeout(() => { successMessage.value = ''; }, 2500);
    } catch (error) {
      console.error(error);
      successMessage.value = "Erreur lors de l'ajout de la composition";
    }
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
    fetchPlayerStatuses();
  });
</script>

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
