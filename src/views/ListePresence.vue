<script setup>
import { ref, onMounted } from 'vue';
import { getAllPresenceStatus } from '@/services/PresenceStatusService';
import { getPresencesByIdSeance, createPresence, updatePresence } from '@/services/PresenceService.js';
import SeanceService from '@/services/SeanceService';
// NOUVEAU: Import du service joueur
import * as JoueurService from '@/services/JoueurService'; 
import { useRoute } from 'vue-router';


// Constantes
const ID_STATUT_PRESENT = 1;
const ID_STATUT_ABSENT = 2;
const ID_STATUT_INCONNU = 3; // Statut par défaut si non trouvé

const route = useRoute()

// Reactive state
const players = ref([]);
const selectedSession = ref('');
const currentSession = ref({});
const presenceStatuses = ref([]);
const isEditing = ref(false);
// NOUVEAU: Pour les joueurs non enregistrés
const missingPlayers = ref([]); 
const missingPresences = ref({}); // État des checkboxes pour les joueurs manquants


// Fetch presence statuses
const loadPresenceStatuses = async () => {
    const response = await getAllPresenceStatus();
    presenceStatuses.value = response;
};


// NOUVEAU: Récupère tous les joueurs éligibles pour la séance (similaire à l'insertion rapide)
const fetchPlayersBySeance = async (seance) => {
    if (!seance || !seance.dateSeance) return [];
    
    try {
        // Supposons que searchJoueurs accepte un objet de recherche basé sur la date d'inscription
        const { data: joueurData } = await JoueurService.searchJoueurs({
            dateInscriptionMax: seance.dateSeance
        });
        return joueurData; // Liste complète des joueurs éligibles
    } catch (error) {
        console.error("Erreur lors du chargement des joueurs éligibles:", error);
        return [];
    }
};

const loadPresences = async () => {
    if (!selectedSession.value) return;
    currentSession.value = await SeanceService.getSeanceById(selectedSession.value);
    if (Object.keys(currentSession.value).length === 0) return;

    try {
        const registeredPresences = await getPresencesByIdSeance(selectedSession.value);
        const allEligiblePlayers = await fetchPlayersBySeance(currentSession.value);
        const registeredIds = new Set(registeredPresences.map(p => p.idJoueur));
        const missing = [];

        allEligiblePlayers.forEach(joueur => {
            if (!registeredIds.has(joueur.id)) {
                missing.push({
                    idJoueur: joueur.id,
                    nom: joueur.nom,
                    prenom: joueur.prenom,
                    poste: joueur.idpostePoste?.libelle || 'N/A',
                    idStatutPresence: ID_STATUT_ABSENT, 
                    commentaire: ''
                });
            }
        });
        players.value = registeredPresences; // Liste des présences déjà enregistrées
        missingPlayers.value = missing;      // Liste des joueurs à ajouter
        missingPresences.value = {};         // Réinitialiser le formulaire rapide
    } catch (error) {
        alert("Erreur lors du chargement des données de présence : " + error.message);
        players.value = [];
        missingPlayers.value = [];
    }
};

const saveMissingPresences = async () => {
    const seanceId = selectedSession.value;
    const requests = [];

    missingPlayers.value.forEach((joueur) => {
        const isPresent = missingPresences.value[joueur.idJoueur] || false;
        const payload = {
            idSeance: seanceId,
            idJoueur: joueur.idJoueur,
            // Si la checkbox est cochée, le statut est PRÉSENT, sinon ABSENT par défaut
            idStatutPresence: isPresent ? ID_STATUT_PRESENT : ID_STATUT_ABSENT,
            commentaire: '' // Pas de commentaire pour cette saisie rapide
        };
        requests.push(createPresence(payload));
    });

    try {
        await Promise.all(requests);
        alert(`${requests.length} nouvelles présences ont été enregistrées avec succès.`);
        // Recharger toutes les présences pour fusionner les nouvelles entrées dans le tableau principal
        loadPresences(); 
    } catch (error) {
        console.error("Erreur lors de l'enregistrement des présences manquantes :", error);
        alert("Erreur lors de l'enregistrement des présences manquantes.");
    }
};

// Fonction pour basculer le mode d'édition (Inchangé)
const toggleEditMode = () => {
    isEditing.value = !isEditing.value;
    if (!isEditing.value) {
        loadPresences();
    }
};

// Simulate updating presence status in database (Utilisé pour le mode édition)
const updateCurrentPresence = async (player) => {
    await updatePresence(player.idPresence, player)
};

// Save all presence changes (Utilisé pour le mode édition)
const saveAllPresences = async () => {
    for (const player of players.value) {
        await updateCurrentPresence(player);
    }
    toggleEditMode();
};

const formatDate = (dateStr) => {
    const options = { year: 'numeric', month: 'short', day: 'numeric' };
    return new Date(dateStr).toLocaleDateString('fr-FR', options);
};

const getStatusLabel = (idStatut) => {
    const status = presenceStatuses.value.find(s => s.idStatutPresence === idStatut);
    return status ? status.libelle : 'Inconnu';
};

onMounted(async () => {
    selectedSession.value = Number(route.params.idSeance);
    await loadPresenceStatuses();
    await loadPresences();
});
</script>

<template>
    <div class="presence-container">
        <div class="page-header">
            <h2>Fiche de presence</h2>
            <div>
                <router-link to="/seances" class="btn-add">
                    Retour a la liste des seances
                </router-link>

                <router-link to="/presences/create" class="btn-add">
                    Insertion presences
                </router-link>            
            </div>
        </div>

        <div class="session-selector">
            <div v-if="selectedSession" class="session-info">
                <h3>{{ currentSession.type }} - {{ formatDate(currentSession.dateSeance) }}</h3>
                <p>{{ currentSession.heureDebut }} à {{ currentSession.heureFin }} | {{ currentSession.lieu }}</p>
                <p>Objectif : {{ currentSession.objectif }}</p>
            </div>
        </div>
        <div v-if="selectedSession && missingPlayers.length > 0" class="missing-players-form card">
            <h3>Joueurs manquants à l'appel ({{ missingPlayers.length }})</h3>
            <form @submit.prevent="saveMissingPresences">
                <table class="presence-table">
                    <thead>
                        <tr>
                            <th>Joueur</th>
                            <th>Présent ?</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="joueur in missingPlayers" :key="joueur.idJoueur">
                            <td>{{ joueur.nom }} {{ joueur.prenom }}</td>
                            <td>
                                <label class="checkbox-container">
                                    <input
                                        type="checkbox"
                                        v-model="missingPresences[joueur.idJoueur]"
                                    />
                                    <span class="checkmark"></span>
                                </label>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <div class="actions">
                    <button type="submit" class="btn-save btn-add-missing">Enregistrer les {{ missingPlayers.length }} entrées manquantes</button>
                </div>
            </form>
        </div>
        <div v-if="selectedSession" class="presence-list">
            <h3>Fiche de Présence Complète ({{ players.length }} entrées)</h3>
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
                            <select v-if="isEditing" v-model="player.idStatutPresence">
                                <option v-for="status in presenceStatuses" :key="status.idStatutPresence" :value="status.idStatutPresence">
                                    {{ status.libelle }}
                                </option>
                            </select>
                            <span v-else>
                                {{ getStatusLabel(player.idStatutPresence) }}
                            </span>
                        </td>
                        <td>
                            <input v-if="isEditing" type="text" v-model="player.commentaire" placeholder="Commentaire">
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

.missing-players-form {
    margin-top: 30px;
    padding: 20px;
    background-color: #ffe0b2; /* Couleur d'alerte ou orange pâle */
    border-radius: 8px;
    border: 1px solid #ffb74d;
    box-shadow: 0 2px 4px rgba(0,0,0,0.05);
}

.missing-players-form h3 {
    color: #e65100; /* Orange foncé */
    margin-top: 0;
    margin-bottom: 15px;
    font-size: 1.1rem;
}

.missing-players-form .presence-table th {
    background-color: #ffa000; /* Orange plus visible */
}

.btn-add-missing {
    background-color: #e65100; /* Orange foncé pour le bouton d'ajout */
    color: white;
    padding: 8px 15px;
    font-size: 0.95rem;
}

.btn-add-missing:hover {
    background-color: #bf360c;
}

.presence-container {
  padding: 20px;
  max-width: 1200px;
  margin: 0 auto;
}

.session-selector {
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