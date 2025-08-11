<template>
  <div class="seance-insert-container">
    <h1>Insertion d'une séance</h1>
    <div class="form-container">
      <form @submit.prevent="submitForm">
        <div class="form-row">
          <div class="form-group">
            <label>Type:</label>
            <select v-model="currentSeance.idTypeSeance" required>
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
          <button type="submit" class="btn-submit">Ajouter</button>
        </div>
      </form>
      <div v-if="successMessage" class="success-message">{{ successMessage }}</div>
    </div>
  </div>
</template>

<script>
import { ref } from 'vue';

export default {
  name: 'InsertionSeance',
  setup() {
    const typesSeance = ref([
      { idTypeSeance: 1, libelle: 'Entrainement', description: 'Séance d entraînement régulière' },
      { idTypeSeance: 2, libelle: 'Match amical', description: 'Match sans enjeu compétitif' },
      { idTypeSeance: 3, libelle: 'Match officiel', description: 'Match de championnat ou coupe' },
      { idTypeSeance: 4, libelle: 'Seance physique', description: 'Séance axée sur la condition physique' },
      { idTypeSeance: 5, libelle: 'Seance tactique', description: 'Séance axée sur la tactique d équipe' }
    ]);

    const currentSeance = ref({
      idTypeSeance: 1,
      dateSeance: '',
      heureDebut: '',
      heureFin: '',
      lieu: '',
      objectif: '',
      bilan: ''
    });

    const successMessage = ref('');

    const submitForm = () => {
      // Ici, vous pouvez envoyer les données à une API ou les stocker localement
      successMessage.value = "Séance ajoutée avec succès !";
      resetForm();
      setTimeout(() => { successMessage.value = ''; }, 2500);
    };

    const resetForm = () => {
      currentSeance.value = {
        idTypeSeance: 1,
        dateSeance: '',
        heureDebut: '',
        heureFin: '',
        lieu: '',
        objectif: '',
        bilan: ''
      };
    };

    return {
      typesSeance,
      currentSeance,
      submitForm,
      resetForm,
      successMessage
    };
  }
}
</script>

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
