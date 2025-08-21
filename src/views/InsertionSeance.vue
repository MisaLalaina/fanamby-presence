<script setup>
import { ref, onMounted } from 'vue';
import SeanceService from '@/services/SeanceService';
import TypeSeanceService from '@/services/TypeSeanceService';
import { Seance } from '@/models/seance';
import { TypeSeance } from '@/models/typeSeance';

const typesSeance = ref([]);
const currentSeance = ref(Seance.getDefaultSeance());
const clubId = ref(1);
const statutId = ref(1);
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
    await SeanceService.createSeance({
      ...currentSeance.value,
      clubId: clubId.value,
      statutId: statutId.value
    });
    successMessage.value = "Séance ajoutée avec succès !";
    resetForm();
    setTimeout(() => { successMessage.value = ''; }, 2500);
  } catch (err) {
    error.value = err.message || 'Erreur lors de la création';
  } finally {
    isLoading.value = false;
  }
};

const resetForm = () => {
  currentSeance.value = Seance.getDefaultSeance();
};

onMounted(() => {
  fetchTypes();
});
</script>

<template>
  <div class="seance-insert-container">
    <h1>Insertion d'une séance d'entrainement</h1>

    <div v-if="error" class="error-message">{{ error }}</div>
    <div v-if="successMessage" class="success-message">{{ successMessage }}</div>

    <form @submit.prevent="submitForm" class="form-container">
      <div class="form-row">
        <div class="form-group">
          <label>Type:</label>
          <select v-model="currentSeance.idTypeSeance" required>
            <option value="">Sélectionner un type</option>
            <option v-for="type in typesSeance" :key="type.idTypeSeance" :value="type.idTypeSeance">
              {{ type.libelle }}
            </option>
          </select>
        </div>
        <div class="form-group">
          <label>Date:</label>
          <input type="date" v-model="currentSeance.dateSeance" required>
        </div>
      </div>

      <div class="form-row">
        <div class="form-group">
          <label>Heure début:</label>
          <input type="time" v-model="currentSeance.heureDebut" required>
        </div>
        <div class="form-group">
          <label>Heure fin:</label>
          <input type="time" v-model="currentSeance.heureFin" required>
        </div>
      </div>

      <div class="form-group">
        <label>Lieu:</label>
        <input type="text" v-model="currentSeance.lieu" required>
      </div>

      <div class="form-group">
        <label>Objectif:</label>
        <textarea v-model="currentSeance.objectif"></textarea>
      </div>

      <div class="form-group">
        <label>Bilan:</label>
        <textarea v-model="currentSeance.bilan"></textarea>
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
.seance-insert-container {
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

.form-row {
  display: flex;
  gap: 20px;
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
