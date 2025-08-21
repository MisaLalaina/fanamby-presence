<script setup>
import { ref, computed } from 'vue';
import { createMatch } from '@/services/MatchFootService.js';
import SeanceService from '@/services/SeanceService';
import TypeSeanceService from '@/services/TypeSeanceService';
import { TypeSeance } from '@/models/typeSeance';

const typesSeance = ref([]);
const form = ref({
  // Données du match
  competition: 'CAN 2025',
  adversaire: 'Tanzanie',
  domicile: true,
  scoreEquipe: 1,
  scoreAdversaire: 1,
  incidents: '',
  observations: '',
  
  // Données de la séance
  idTypeSeance: '2',
  dateSeance: '2025-08-16',
  heureDebut: '20:00',
  heureFin: '21:00',
  lieu: 'Antananarivo',
  objectif: '',
  bilan: ''
});

const successMessage = ref('');
const error = ref(null);
const isLoading = ref(false);

const fetchTypes = async () => {
  try {
    const typeSeancesData = await TypeSeanceService.getAllTypeSeances();
    typesSeance.value = TypeSeance.formatTypeSeances(typeSeancesData);
  } catch (err) {
    error.value = err.message || 'Erreur chargement types séance';
  }
};

const submitForm = async () => {
  isLoading.value = true;
  error.value = null;
  try {
    // D'abord créer la séance
    const seanceData = {
      idTypeSeance: form.value.idTypeSeance,
      dateSeance: form.value.dateSeance,
      heureDebut: form.value.heureDebut,
      heureFin: form.value.heureFin,
      lieu: form.value.lieu,
      objectif: form.value.objectif,
      bilan: form.value.bilan,
      clubId: 1, // À adapter selon votre logique
      statutId: 1 // À adapter selon votre logique
    };
    
    const createdSeance = await SeanceService.createSeance(seanceData);
    if (createdSeance) {
      console.log(createdSeance);
    }
    
    // Ensuite créer le match avec l'ID de la séance créée
    const matchData = {
      idSeance: createdSeance.idseance,
      competition: form.value.competition,
      adversaire: form.value.adversaire,
      domicile: form.value.domicile,
      scoreEquipe: form.value.scoreEquipe,
      scoreAdversaire: form.value.scoreAdversaire,
      incidents: form.value.incidents,
      observations: form.value.observations
    };

    console.log(matchData);
    
    
    await createMatch(matchData);
    
    successMessage.value = "Match et séance ajoutés avec succès !";
    resetForm();
    setTimeout(() => { successMessage.value = ''; }, 2500);
  } catch (err) {
    error.value = err.message || 'Erreur lors de la création';
  } finally {
    isLoading.value = false;
  }
};

const resetForm = () => {
  form.value = {
    competition: '',
    adversaire: '',
    domicile: true,
    scoreEquipe: 0,
    scoreAdversaire: 0,
    incidents: '',
    observations: '',
    idTypeSeance: '',
    dateSeance: '',
    heureDebut: '',
    heureFin: '',
    lieu: '',
    objectif: '',
    bilan: ''
  };
};

fetchTypes();
</script>

<template>
  <div class="match-insert-container">
    <h2>Insertion d'un match</h2>
    
    <div v-if="error" class="error-message">{{ error }}</div>
    <div v-if="successMessage" class="success-message">{{ successMessage }}</div>
    
    <form @submit.prevent="submitForm" class="form-container">
      <h3>Informations du match</h3>
      <div class="form-row">
        <div class="form-group">
          <label>Compétition :</label>
          <input type="text" v-model="form.competition" required placeholder="Nom de la compétition">
        </div>
        <div class="form-group">
          <label>Adversaire :</label>
          <input type="text" v-model="form.adversaire" required placeholder="Nom de l'adversaire">
        </div>
      </div>
      
      <div class="form-row">
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
      </div>
      
      <h3>Informations de la séance</h3>
      <div class="form-row">
        <div class="form-group">
          <label>Type de séance :</label>
          <select v-model="form.idTypeSeance" required>
            <option value="">-- Choisir un type --</option>
            <option v-for="type in typesSeance" :key="type.idTypeSeance" :value="type.idTypeSeance">
              {{ type.libelle }}
            </option>
          </select>
        </div>
        <div class="form-group">
          <label>Date :</label>
          <input type="date" v-model="form.dateSeance" required>
        </div>
      </div>
      
      <div class="form-row">
        <div class="form-group">
          <label>Heure début :</label>
          <input type="time" v-model="form.heureDebut" required>
        </div>
        <div class="form-group">
          <label>Heure fin :</label>
          <input type="time" v-model="form.heureFin" required>
        </div>
        <div class="form-group">
          <label>Lieu :</label>
          <input type="text" v-model="form.lieu" required>
        </div>
      </div>
      
      <div class="form-group">
        <label>Objectif :</label>
        <textarea v-model="form.objectif" placeholder="Objectif de la séance"></textarea>
      </div>
      
      <div class="form-group">
        <label>Bilan :</label>
        <textarea v-model="form.bilan" placeholder="Bilan de la séance (après le match)"></textarea>
      </div>
      
      <div class="form-actions">
        <button type="button" @click="resetForm" class="btn-cancel">Annuler</button>
        <button type="submit" class="btn-submit" :disabled="isLoading">
          {{ isLoading ? 'Enregistrement...' : 'Ajouter' }}
        </button>
      </div>
    </form>
  </div>
</template>

<style scoped>
.match-insert-container {
  padding: 20px;
  max-width: 800px;
  margin: 0 auto;
}

.form-container {
  background-color: #f5f5f5;
  padding: 20px;
  border-radius: 8px;
  margin-bottom: 20px;
}

.form-row {
  display: flex;
  gap: 15px;
  margin-bottom: 15px;
}

.form-group {
  flex: 1;
  margin-bottom: 15px;
}

.form-group label {
  display: block;
  margin-bottom: 5px;
  font-weight: bold;
}

.form-group input,
.form-group select,
.form-group textarea {
  width: 100%;
  padding: 8px;
  border: 1px solid #ddd;
  border-radius: 4px;
}

.form-group textarea {
  min-height: 80px;
}

.form-actions {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  margin-top: 20px;
}

.btn-submit {
  background-color: #2ecc71;
  color: white;
  padding: 8px 15px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.btn-submit:disabled {
  background-color: #95a5a6;
  cursor: not-allowed;
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
  margin: 10px 0;
  font-weight: bold;
}

.error-message {
  color: #e74c3c;
  margin: 10px 0;
  font-weight: bold;
}

h3 {
  margin: 20px 0 15px 0;
  color: #2c3e50;
  border-bottom: 1px solid #ddd;
  padding-bottom: 5px;
}
</style>