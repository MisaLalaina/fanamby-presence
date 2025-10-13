<script setup>
import { ref, onMounted, defineProps, defineEmits } from 'vue';
import SeanceService from '@/services/SeanceService';
import TypeSeanceService from '@/services/TypeSeanceService';
import { Seance } from '@/models/seance';
import { TypeSeance } from '@/models/typeSeance';

// --- PROPS & EMITS ---
const props = defineProps({
    // L'ID de la séance à modifier est passé via une prop
    seanceId: {
        type: [Number, String],
        required: true
    }
});

const emit = defineEmits(['updated', 'cancel']);

// --- DATA ---
const typesSeance = ref([]);
const currentSeance = ref(Seance.getDefaultSeance());
const successMessage = ref('');
const error = ref(null);
const isLoading = ref(false);

// ClubId et StatutId sont gérés ici, mais devraient idéalement être passés ou récupérés
// Si la séance est en cours de modification, le statut ne devrait pas être hardcodé à 1
const clubId = ref(1); 

// Note: Le statut est maintenant une propriété de la séance chargée, nous n'avons plus besoin de statutId hardcodé.


// --- FONCTIONS DE CHARGEMENT ---

const fetchTypes = async () => {
    try {
        const typeSeancesData = await TypeSeanceService.getAllTypeSeances();
        // Le formatage doit correspondre à celui utilisé dans le <select> du template
        // On suppose que votre TypeSeance.formatTypeSeances est correct
        typesSeance.value = TypeSeance.formatTypeSeances(typeSeancesData);
    } catch (err) {
        error.value = err.message || 'Erreur chargement types séance';
    }
};

const fetchSeanceData = async () => {
    isLoading.value = true;
    error.value = null;
    try {
        // Supposons que SeanceService.getSeanceById existe et retourne la séance
        const seanceData = await SeanceService.getSeanceById(props.seanceId);
        
        // Mettre à jour currentSeance. On suppose que la fonction formatSeances retourne un tableau, 
        // ou que nous avons un formatage pour un seul objet.
        // Si c'est un tableau [seance], on prend le premier élément.
        const formattedSeance = Seance.formatSeances([seanceData])[0] || seanceData; 
        
        // Assurez-vous que l'objet de la séance est bien formaté
        currentSeance.value = { 
            ...formattedSeance,
            // Convertir la date de 'YYYY-MM-DDTHH:mm:ss.000Z' à 'YYYY-MM-DD' pour l'input[type=date]
            dateSeance: formattedSeance.dateSeance ? formattedSeance.dateSeance.split('T')[0] : ''
        };
        
    } catch (err) {
        error.value = err.message || `Erreur lors du chargement de la séance ${props.seanceId}`;
    } finally {
        isLoading.value = false;
    }
};

// --- FONCTION DE SOUMISSION (MISE À JOUR) ---

const updateForm = async () => {
    isLoading.value = true;
    error.value = null;

    // L'objet à envoyer est la copie de currentSeance.value
    const payload = {
        ...currentSeance.value,
        clubId: clubId.value, // Assurez-vous que cette valeur est gérée correctement
        // On n'a plus besoin de statutId hardcodé, car le statut est dans currentSeance s'il est modifiable, 
        // sinon il est conservé.
    };

    try {
        // Supposons que SeanceService.updateSeance existe et prend l'ID et le payload
        await SeanceService.updateSeance(props.seanceId, payload); 
        
        successMessage.value = "Séance modifiée avec succès !";
        setTimeout(() => { 
            successMessage.value = ''; 
            // Émettre l'événement pour notifier le composant parent de la mise à jour
            emit('updated');
        }, 1500);

    } catch (err) {
        error.value = err.message || 'Erreur lors de la mise à jour';
    } finally {
        isLoading.value = false;
    }
};

// --- INITIALISATION ---

onMounted(() => {
    fetchTypes();
    fetchSeanceData();
});
</script>

<template>
  <div class="seance-insert-container">
    <h1>Modification de la séance n° {{ props.seanceId }}</h1>

    <div v-if="error" class="error-message">{{ error }}</div>
    <div v-if="successMessage" class="success-message">{{ successMessage }}</div>
    <div v-if="isLoading" class="loading-message">Chargement des données de la séance... 🔄</div>

    <form v-else @submit.prevent="updateForm" class="form-container">
      
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
      
      <div class="form-group">
        <label>Statut:</label>
        <select v-model="currentSeance.statut" required>
            <option value="Planifié">Planifié</option>
            <option value="EnCours">En Cours</option>
            <option value="Effectué">Effectué</option>
            <option value="Annulé">Annulé</option>
        </select>
      </div>


      <div class="form-actions">
        <button type="submit" class="btn-submit btn-update" :disabled="isLoading">
          {{ isLoading ? 'Mise à jour...' : 'Mettre à jour' }}
        </button>
        <button type="button" @click="$emit('cancel')" class="btn-cancel">Annuler</button>
      </div>
    </form>
  </div>
</template>

<style scoped>
/* Copier/Coller de vos styles d'insertion, avec quelques ajustements */
.seance-insert-container {
    padding: 20px;
    max-width: 600px;
    margin: 0 auto;
}

h1 {
    color: #3498db;
    margin-bottom: 20px;
    text-align: center;
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
    margin-top: 20px;
}

/* Style spécifique pour le bouton de mise à jour (bleu) */
.btn-submit.btn-update {
    background-color: #3498db; /* Bleu */
    width: 30%; /* Plus large que le bouton d'annulation */
}

.btn-submit.btn-update:hover {
    background-color: #2980b9;
}

.btn-cancel {
    background-color: #95a5a6; /* Gris, pour moins d'urgence */
    color: white;
    padding: 10px 20px;
    border: none;
    border-radius: 6px;
    cursor: pointer;
    width: 30%;
}

.btn-cancel:hover {
    background-color: #7f8c8d;
}

/* Messages */
.success-message {
    background-color: #d4edda;
    color: #155724;
    padding: 10px;
    border-radius: 4px;
    margin-bottom: 15px;
    text-align: center;
    font-weight: bold;
}

.error-message {
    background-color: #f8d7da;
    color: #721c24;
    padding: 10px;
    border-radius: 4px;
    margin-bottom: 15px;
    text-align: center;
    font-weight: bold;
}

.loading-message {
    text-align: center;
    padding: 20px;
    color: #3498db;
    font-weight: bold;
}

@media (max-width: 480px) {
    .form-row {
        flex-direction: column;
    }
    .btn-submit.btn-update, .btn-cancel {
        width: 48%;
    }
    .form-actions {
        justify-content: space-between;
    }
}
</style>