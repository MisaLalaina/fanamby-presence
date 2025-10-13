<template>
    <div class="composition-insert-container">
        <NotificationToast v-model="notification" />

        <h2>Saisie Rapide des Compositions d'Équipe</h2>
        <form @submit.prevent="submitForm" class="form-container">
            
            <div class="form-group-match-select">
                <label for="match-select">Match concerné :</label>
                <select id="match-select" v-model="selectedMatchId" class="form-control" required>
                    <option value="" disabled>-- Choisir un match --</option>
                    <option v-for="match in matches" :key="match.idMatch" :value="match.idMatch">
                        {{ formatMatchLabel(match) }}
                    </option>
                </select>
            </div>
            
            <hr class="separator"/>

            <h3>Assignation des joueurs ({{ compositionRows.length }} lignes)</h3>
            <div class="table-responsive">
                <table class="composition-table">
                    <thead>
                        <tr>
                            <th class="player-col">Joueur</th>
                            <th>Statut</th>
                            <th class="w-100">N° Maillot</th>
                            <th class="w-150">Position</th>
                            <th class="w-capitaine">Capitaine</th>
                            <th>Commentaire</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="row in compositionRows" :key="row.key" 
                            :class="{ 'row-active': row.idJoueur, 'row-empty': !row.idJoueur }"
                        >
                            <td class="player-cell">
                              <SearchSelect 
                                v-model="row.idJoueur" 
                                :options="getAvailableOptions(row.key)"
                                @update:model-value="(idJoueur) => autoFillPlayerDetails(idJoueur, row.key)" 
                              />
                            </td>

                            <td>
                                <select v-model="row.idStatutComposition" class="form-control">
                                    <option v-for="status in playerStatuses" :key="status.idStatutComposition" :value="status.idStatutComposition">
                                        {{ status.libelle }}
                                    </option>
                                </select>
                            </td>
                            <td>
                                <input type="number" v-model.number="row.numeroMaillot" min="1" max="99" class="form-control text-center">
                            </td>
                            <td>
                                <input type="text" v-model="row.position" class="form-control">
                            </td>
                            <td class="text-center">
                                <input type="checkbox" v-model="row.isCapitaine">
                            </td>
                            <td>
                                <input type="text" v-model="row.commentaire" class="form-control">
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            
            <div class="row-controls">
                <button 
                    type="button" 
                    @click="addRow" 
                    class="btn-add-row" 
                    :disabled="compositionRows.length >= MAX_ROWS || isSaving"
                >
                    + Ajouter une ligne ({{ compositionRows.length }} / {{ MAX_ROWS }})
                </button>
            </div>

            <div class="form-actions">
                <button 
                    type="submit" 
                    class="btn-submit" 
                    :disabled="isSaving || !selectedMatchId"
                >
                    <span v-if="isSaving">Enregistrement en cours...</span>
                    <span v-else>💾 Enregistrer les Compositions</span>
                </button>
                <button type="button" @click="resetCompositionRows(DEFAULT_ROWS)" class="btn-cancel" :disabled="isSaving">
                    Effacer & Réduire
                </button>
            </div>
        </form>
    </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue';
import { createComposition, getAllStatutCompositions } from '@/services/CompositionService';
import { getAllJoueurs } from '@/services/JoueurService';
import { getAllMatches } from '@/services/MatchFootService.js';
import SearchSelect from '@/components/SearchSelect.vue'; 
import NotificationToast from '@/components/NotificationToast.vue';

// --- Constantes ---
const DEFAULT_ROWS = 12;
const MAX_ROWS = 25;
let keyCounter = DEFAULT_ROWS;

// --- Références réactives ---
const matches = ref([]);
const rawPlayers = ref([]); // Liste brute de tous les joueurs
const playerStatuses = ref([]);
const notification = ref({ show: false, message: '', type: 'success' });
const isSaving = ref(false);
const selectedMatchId = ref('');
const compositionRows = ref([]);

// --- Fonctions d'Initialisation (Identiques) ---

const fetchInitialData = async () => {
    try {
        await Promise.all([
            fetchMatches(),
            fetchPlayers(),
            fetchPlayerStatuses()
        ]);
        
        if (matches.value.length) {
            selectedMatchId.value = matches.value[0].idMatch;
        }
        
        resetCompositionRows(DEFAULT_ROWS);
    } catch (error) {
        showNotification("Erreur lors du chargement des données initiales.", 'error');
        console.error(error);
    }
};

const fetchMatches = async () => {
    const allMatches = await getAllMatches();
    matches.value = allMatches.sort((a, b) => new Date(b.dateMatch) - new Date(a.dateMatch));
};

const fetchPlayers = async () => {
    rawPlayers.value = await getAllJoueurs();
};

const fetchPlayerStatuses = async () => {
    playerStatuses.value = await getAllStatutCompositions();
};

const showNotification = (message, type = 'success') => {
    notification.value = { show: true, message, type };
    setTimeout(() => {
        notification.value = { show: false, message: '', type: 'success' };
    }, 4000);
};

onMounted(() => {
    fetchInitialData();
});

// 💡 Logique des options de joueur (Identique)
const playerOptions = computed(() => {
    return rawPlayers.value.map(p => ({
        value: p.idJoueur,
        label: `${p.nom} ${p.prenom} (${p.poste})`,
    }));
});

const getAvailableOptions = (currentRowKey) => {
    // ... (Logique d'exclusion des joueurs déjà sélectionnés) ...
    const selectedIds = compositionRows.value
        .filter(row => row.idJoueur && row.key !== currentRowKey)
        .map(row => row.idJoueur);
    
    let availableOptions = playerOptions.value.filter(option => !selectedIds.includes(option.value));

    const currentSelection = compositionRows.value.find(row => row.key === currentRowKey)?.idJoueur;
    if (currentSelection && !availableOptions.some(opt => opt.value === currentSelection)) {
        const selectedPlayerOption = playerOptions.value.find(opt => opt.value === currentSelection);
        if (selectedPlayerOption) {
            availableOptions.unshift(selectedPlayerOption);
        }
    }
    
    return availableOptions;
};

// --- NOUVELLE FONCTION D'AUTO-REMPLISSAGE ---
/**
 * Recherche le joueur dans la liste brute et remplit les champs position/maillot.
 * @param {number|null} idJoueur - L'ID du joueur sélectionné ou null.
 * @param {number} rowKey - La clé de la ligne à mettre à jour.
 */
const autoFillPlayerDetails = (idJoueur, rowKey) => {
    const rowIndex = compositionRows.value.findIndex(row => row.key === rowKey);
    if (rowIndex === -1) return;

    const row = compositionRows.value[rowIndex];
    
    if (idJoueur) {
        // Trouve l'objet joueur complet
        const player = rawPlayers.value.find(p => p.idJoueur === idJoueur);
        
        if (player) {
            // Mise à jour des champs
            row.numeroMaillot = player.numeroMaillot || null; // Utilise la valeur du joueur
            row.position = player.poste || ''; // Utilise la valeur du joueur
            // Optionnel : Définir un statut par défaut si non défini
            if (!row.idStatutComposition) {
                // EX: Si 'Titulaires' est le premier statut (hypothèse)
                row.idStatutComposition = playerStatuses.value[0]?.idStatutComposition || null;
            }
        }
    } else {
        // Si le joueur est désélectionné (idJoueur est null), on vide les champs
        row.numeroMaillot = null;
        row.position = '';
        row.idStatutComposition = null;
        row.isCapitaine = false;
    }
};

// --- Logique du Tableau et Soumission (Identiques) ---

const resetCompositionRows = (count = compositionRows.value.length) => {
    const initialRows = Array.from({ length: count }, (_, index) => ({
        idJoueur: null,
        idStatutComposition: null,
        numeroMaillot: null,
        position: '',
        isCapitaine: false,
        commentaire: '',
        key: index
    }));
    compositionRows.value = initialRows;
    keyCounter = count;
};

const addRow = () => {
    if (compositionRows.value.length >= MAX_ROWS) {
        showNotification(`Limite de ${MAX_ROWS} lignes atteinte.`, 'warning');
        return;
    }
    
    compositionRows.value.push({
        idJoueur: null,
        idStatutComposition: null,
        numeroMaillot: null,
        position: '',
        isCapitaine: false,
        commentaire: '',
        key: keyCounter++
    });
};

const submitForm = async () => {
    if (isSaving.value) return;
    isSaving.value = true;

    if (!selectedMatchId.value) {
        showNotification("Veuillez sélectionner un match.", 'warning');
        isSaving.value = false;
        return;
    }

    const validCompositions = compositionRows.value.filter(row => row.idJoueur);

    if (validCompositions.length === 0) {
        showNotification("Aucune composition n'a été saisie.", 'warning');
        isSaving.value = false;
        return;
    }

    const requests = validCompositions.map(comp => {
        const payload = { ...comp, idMatch: selectedMatchId.value };
        return createComposition(payload);
    });

    const results = await Promise.allSettled(requests);
    const failed = results.filter(r => r.status === 'rejected');

    if (failed.length === 0) {
        showNotification(`✅ ${validCompositions.length} compositions enregistrées avec succès !`, 'success');
        resetCompositionRows(DEFAULT_ROWS);
    } else {
        showNotification(`⚠️ ${failed.length} enregistrement(s) a/ont échoué. ${validCompositions.length - failed.length} réussi(s).`, 'warning');
    }

    isSaving.value = false;
};

const formatMatchLabel = (match) => {
    return `${match.dateMatch} - ${match.competition} vs ${match.adversaire} ${match.domicile ? '(Domicile)' : '(Extérieur)'}`;
};
</script>

<style scoped>
.composition-insert-container {
    padding: 20px;
    max-width: 1200px;
    margin: 0 auto;
}
.form-container {
    background-color: #f5f5f5;
    padding: 20px;
    border-radius: 8px;
    margin-bottom: 20px;
}
/* Entête */
h3 {
    margin-top: 0;
    font-size: 1.1rem;
    color: #3498db;
    border-bottom: 2px solid #3498db;
    padding-bottom: 5px;
}
.separator {
    border: none;
    border-top: 1px solid #ddd;
    margin: 20px 0;
}

/* Sélection Match */
.form-group-match-select select {
    width: 100%;
    padding: 8px;
    border: 1px solid #ddd;
    border-radius: 4px;
}

/* Tableau */
.table-responsive {
    overflow-x: auto;
    max-height: 60vh;
    overflow-y: auto;
}
.composition-table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 15px;
    font-size: 0.9rem;
}
.composition-table th {
    background-color: #3498db;
    color: white;
    padding: 10px 8px;
    text-align: left;
    font-weight: 600;
    position: sticky; 
    top: 0;
    z-index: 10;
}
.composition-table td {
    padding: 5px 8px;
    border: 1px solid #eee;
    background-color: white;
}
.composition-table .player-col { width: 250px; }
.composition-table .player-cell { position: relative; }
.composition-table .w-100 { width: 100px; }
.composition-table .w-150 { width: 150px; }
.composition-table .w-capitaine { width: 80px; text-align: center; }

/* UX Ligne active */
.composition-table .row-active {
    background-color: #eaf6ff;
}

/* Contrôles et Actions */
.row-controls {
    text-align: left;
    margin-top: 10px;
}
.btn-add-row {
    background-color: #2ecc71;
    color: white;
    padding: 6px 15px;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-size: 0.9rem;
    transition: background-color 0.2s;
}
.btn-add-row:hover:not([disabled]) {
    background-color: #27ae60;
}
.form-actions {
    display: flex;
    justify-content: flex-end;
    gap: 10px;
    margin-top: 20px;
}
.btn-submit {
    background-color: #3498db;
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
.btn-submit[disabled], .btn-cancel[disabled] {
    opacity: 0.6;
    cursor: not-allowed;
}
</style>