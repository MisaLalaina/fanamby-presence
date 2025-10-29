<script setup>
import { ref, onMounted, computed, watch } from 'vue';
import { useRoute } from 'vue-router';
import { getMatchById, updateMatch, deleteMatch } from '@/services/MatchFootService.js'; 
import SeanceService from '@/services/SeanceService';
import TypeSeanceService from '@/services/TypeSeanceService';
import { TypeSeance } from '@/models/typeSeance';
import { getAllTypeMathce } from '@/services/TypeMatchService';
import { TypeMatch } from '@/models/typeMatch';
import * as CompositionService from '@/services/CompositionService';
import * as JoueurService from '@/services/JoueurService';

import SearchSelect from '@/components/SearchSelect.vue'; 

const route = useRoute();
const idMatch = route.params.id; 

const MAX_ROWS = 25;
let keyCounter = 0;

const typesSeance = ref([]);
const typesMatch = ref([]);
const tousLesJoueurs = ref([]);
const playerStatuses = ref([]);
const idSeance = ref(null);
const successMessage = ref('');
const error = ref(null);
const isLoading = ref(false);

const matchSeance = ref(null)

const form = ref({
    idTypeMatch: null, competition: '', adversaire: '', domicile: true, scoreEquipe: 0, scoreAdversaire: 0, incidents: '', observations: '',
    idTypeSeance: null, dateSeance: '', heureDebut: '', heureFin: '', lieu: '', objectif: '', bilan: '',
});

const compositionRows = ref([]);

const autoFillPlayerDetails = (idJoueur, rowKey) => {
    const rowIndex = compositionRows.value.findIndex(row => row.key === rowKey);
    if (rowIndex === -1) return;

    const row = compositionRows.value[rowIndex];
    
    if (idJoueur) {
        const player = tousLesJoueurs.value.find(p => p.idJoueur === idJoueur);
        
        if (player) {
            if (row.numeroMaillot === null) row.numeroMaillot = player.numeromaillot || null;
            if (row.position === '') row.position = player.poste || ''; 
            if (!row.idStatutComposition && playerStatuses.value.length) {
                const defaultStatus = playerStatuses.value.find(s => s.idStatutComposition === 1) || playerStatuses.value[0];
                row.idStatutComposition = defaultStatus.idStatutComposition;
            }
        }
    } else {
        row.numeroMaillot = null;
        row.position = '';
        row.idStatutComposition = null;
        row.isCapitaine = false;
    }
};

const getJoueurLabel = (joueur) => `${joueur.prenom} ${joueur.nom} (${joueur.poste})`;

const playerOptions = computed(() => {
    return tousLesJoueurs.value.map(p => ({
        value: p.idJoueur,
        label: getJoueurLabel(p),
    }));
});

const getAvailableOptions = (currentRowKey) => {
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
const fetchJoueurs = async () => {
    if (matchSeance == null) return
    const {data} = await JoueurService.searchJoueurs({
        dateInscriptionMax: matchSeance.value.dateSeance
    })
    return data;
}

const fetchCompositions = async () => {
    try {
        return await CompositionService.getAllCompositionsByMatchId(idMatch)
    } catch (error) {
        return []
    }
}

const fetchMatchData = async () => {
    isLoading.value = true;
    error.value = null;

    try {
        if (!idMatch) {
            error.value = "ID du match manquant.";
            return;
        }

        const [typeSeancesData, typeMatchesData, statutCompoData] = await Promise.all([
            TypeSeanceService.getAllTypeSeances(),
            getAllTypeMathce(),
            CompositionService.getAllStatutCompositions(),
        ]);

        typesSeance.value = TypeSeance.formatTypeSeances(typeSeancesData);
        typesMatch.value = TypeMatch.formatTypeMatch(typeMatchesData);
        playerStatuses.value = statutCompoData || [];
        
        const match = await getMatchById(idMatch);
        if (!match) {
            error.value = "Match non trouvé.";
            return;
        }
        
        const [seance, compositions] = await Promise.all([
            SeanceService.getSeanceById(match.idSeance), 
            fetchCompositions(),
        ]);
        
        matchSeance.value = seance
        idSeance.value = match.idSeance;
        
        const joueursData = await fetchJoueurs();
        tousLesJoueurs.value = joueursData || [];

        form.value = {
            idTypeMatch: match.idtypematchTypematch.idtypematch, 
            competition: match.competition, 
            adversaire: match.adversaire, 
            domicile: match.domicile, 
            scoreEquipe: match.scoreEquipe, 
            scoreAdversaire: match.scoreAdversaire, 
            incidents: match.incidents || '', 
            observations: match.observations || '',

            idTypeSeance: seance.idTypeSeance, 
            dateSeance: seance.dateSeance.slice(0, 10),
            heureDebut: seance.heureDebut, 
            heureFin: seance.heureFin, 
            lieu: seance.lieu, 
            objectif: seance.objectif || '', 
            bilan: seance.bilan || '',
        };

        compositionRows.value = compositions.map((comp, index) => ({
            key: index,
            idComposition: comp.idComposition,
            idJoueur: comp.idJoueur,
            idStatutComposition: comp.idStatutComposition,
            numeroMaillot: comp.numeroMaillot,
            position: comp.position,
            isCapitaine: comp.isCapitaine,
            commentaire: comp.commentaire || '',
        }));

        keyCounter = compositions.length;

        if (compositions.length === 0) {
            for (let i = 0; i < 5; i++) {
                addRow();
            }
        }
    } catch (err) {
        console.error("Erreur lors du chargement des données du match:", err);
        error.value = err.message || 'Erreur lors du chargement des données du match.';
    } finally {
        isLoading.value = false;
    }
};

onMounted(() => {
    if (idMatch) {
        fetchMatchData();
    } else {
         error.value = "ID de match non spécifié pour la modification.";
    }
});

const addRow = () => {
    if (compositionRows.value.length >= MAX_ROWS) {
        error.value = `Limite de ${MAX_ROWS} lignes atteinte.`;
        return;
    }
    
    compositionRows.value.push({
        key: keyCounter++,
        idComposition: null,
        idJoueur: null,
        idStatutComposition: null,
        numeroMaillot: null,
        position: '',
        isCapitaine: false,
        commentaire: '',
    });
};

const submitForm = async () => {
    isLoading.value = true;
    error.value = null;
    successMessage.value = '';

    try {
        const seance = await SeanceService.getSeanceById(idSeance.value)
        const seanceData = {
            idseance: idSeance.value,
            idTypeSeance: Number(form.value.idTypeSeance), 
            dateSeance: form.value.dateSeance, 
            heureDebut: form.value.heureDebut, 
            heureFin: form.value.heureFin, 
            lieu: form.value.lieu, 
            objectif: form.value.objectif, 
            bilan: form.value.bilan,
            idclubClub: seance.idclubClub,
            idstatutseanceStatutseance: seance.idstatutseanceStatutseance,
        };
        await SeanceService.updateSeance(idSeance.value, seanceData);

        const matchData = {
            idMatch: idMatch,
            idSeance: idSeance.value, 
            idTypeMatch: Number(form.value.idTypeMatch), 
            competition: form.value.competition, 
            adversaire: form.value.adversaire, 
            domicile: form.value.domicile, 
            scoreEquipe: form.value.scoreEquipe, 
            scoreAdversaire: form.value.scoreAdversaire, 
            incidents: form.value.incidents, 
            observations: form.value.observations
        };
        await updateMatch(idMatch, matchData);
        
        const allCompositions = compositionRows.value;
        let toCreate = [];
        let toUpdate = [];
        let existingIds = allCompositions
            .filter(c => c.idComposition)
            .map(c => c.idComposition);

        const oldCompositions = await fetchCompositions();
        const toDeleteIds = oldCompositions
            .map(c => c.idComposition)
            .filter(oldId => !existingIds.includes(oldId));

        allCompositions.forEach(row => {
            if (row.idJoueur) {
                const payload = { 
                    ...row, 
                    idMatch: idMatch,
                    key: undefined,
                    idComposition: undefined
                };

                if (row.idComposition) {
                    toUpdate.push({ id: row.idComposition, payload: { ...payload, idComposition: row.idComposition } }); 
                } else {
                    toCreate.push(payload);
                }
            }
        });

        const requests = [
            ...toDeleteIds.map(id => CompositionService.deleteComposition(id)),
            ...toUpdate.map(item => CompositionService.updateComposition(item.id, item.payload)),
            ...toCreate.map(payload => CompositionService.createComposition(payload))
        ];

        const results = await Promise.allSettled(requests);
        const failedRequests = results.filter(result => result.status === 'rejected');
        
        if (failedRequests.length > 0) {
            console.error("Certaines opérations de composition ont échoué:", failedRequests);
            error.value = `${failedRequests.length} opération(s) de composition a/ont échoué. Veuillez vérifier le match.`;
        }

        successMessage.value = `✅ Match et compositions mis à jour avec succès !`;
        await fetchMatchData(); 
        
        setTimeout(() => { successMessage.value = ''; }, 3000);
    } catch (err) {
        console.error("Erreur de soumission :", err);
        error.value = err.message || 'Une erreur est survenue lors de la mise à jour.';
    } finally {
        isLoading.value = false;
    }
};
</script>

<template>
    <div class="page-header">
        <h2>Modification du Match #{{ idMatch }} & de sa Composition</h2>
        <router-link to="/matchs" class="btn-add">
            <span>Retour à la liste des matchs</span>
        </router-link>
    </div>
    <div class="match-insert-container">     
        <div v-if="isLoading && !error" class="loading-message">Chargement des données...</div>
        <div v-if="error" class="error-message">{{ error }}</div>
        <div v-if="successMessage" class="success-message">{{ successMessage }}</div>
        
        <form @submit.prevent="submitForm" class="form-container" v-if="!isLoading && !error">
            <h3>Informations du Match</h3>
            <div class="form-row">
                <div class="form-group"><label>Compétition :</label><input type="text" v-model="form.competition" required></div>
                <div class="form-group"><label>Adversaire :</label><input type="text" v-model="form.adversaire" required></div>
                <div class="form-group"><label>Type de Match :</label><select v-model.number="form.idTypeMatch" required>
                    <option v-for="type in typesMatch" :key="type.idTypeMatch" :value="type.idTypeMatch">{{ type.libelle }}</option>
                </select></div>
            </div>
            <div class="form-row">
                <div class="form-group"><label>Domicile / Extérieur :</label><select v-model="form.domicile" required><option :value="true">Domicile</option><option :value="false">Extérieur</option></select></div>
                <div class="form-group"><label>Score Équipe :</label><input type="number" v-model.number="form.scoreEquipe" min="0" required></div>
                <div class="form-group"><label>Score Adversaire :</label><input type="number" v-model.number="form.scoreAdversaire" min="0" required></div>
            </div>
            <div class="form-group">
                <label>Incidents :</label>
                <textarea v-model="form.incidents"></textarea>
            </div>
            <div class="form-group">
                <label>Observations :</label>
                <textarea v-model="form.observations"></textarea>
            </div>
            
            <hr class="separator"/>

            <h3>Détails de la Séance</h3>
            <div class="form-row">
                <div class="form-group"><label>Type de Séance :</label><select v-model.number="form.idTypeSeance" required>
                    <option v-for="type in typesSeance" :key="type.idTypeSeance" :value="type.idTypeSeance">{{ type.libelle }}</option>
                </select></div>
                <div class="form-group"><label>Date :</label><input type="date" v-model="form.dateSeance" required></div>
                <div class="form-group"><label>Heure Début :</label><input type="time" v-model="form.heureDebut" required></div>
                <div class="form-group"><label>Heure Fin :</label><input type="time" v-model="form.heureFin" required></div>
                <div class="form-group"><label>Lieu :</label><input type="text" v-model="form.lieu" required></div>
            </div>
            <div class="form-group">
                <label>Objectif :</label>
                <textarea v-model="form.objectif"></textarea>
            </div>
            <div class="form-group">
                <label>Bilan :</label>
                <textarea v-model="form.bilan"></textarea>
            </div>

            <hr class="separator"/>

            <h3 class="composition-title">Composition de l'Équipe ({{ compositionRows.filter(r => r.idJoueur).length }} joueurs)</h3>
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
                            <th class="w-delete">Supprimer</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(row, index) in compositionRows" :key="row.key" 
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
                                <select v-model.number="row.idStatutComposition" class="form-control">
                                    <option :value="null" disabled>-- Statut --</option>
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
                            <td class="text-center w-delete">
                                <button type="button" @click="compositionRows.splice(index, 1)" class="btn-delete-row">
                                    ❌
                                </button>
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
                    :disabled="compositionRows.length >= MAX_ROWS || isLoading"
                >
                    + Ajouter une ligne ({{ compositionRows.filter(r => r.idJoueur).length }} / {{ compositionRows.length }} lignes)
                </button>
            </div>
            
            <div class="form-actions">
                <button type="submit" class="btn-submit" :disabled="isLoading">
                    {{ isLoading ? 'Mise à jour en cours...' : 'Modifier le Match & la Compo' }}
                </button>
            </div>
        </form>
    </div>
</template>

<style scoped>
/* Styles de base du formulaire combiné */
.match-insert-container { padding: 20px; max-width: 1200px; margin: 0 auto; }
.form-container { background-color: #ffffff; padding: 25px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); }
h3 { margin: 25px 0 15px 0; color: #2c3e50; border-bottom: 1px solid #ddd; padding-bottom: 5px; }
h3:first-of-type { margin-top: 0; }
.composition-title { color: #3498db; }
.form-row { display: flex; gap: 15px; margin-bottom: 15px; }
.form-group { flex: 1; margin-bottom: 15px; }
.form-group label { display: block; margin-bottom: 5px; font-weight: bold; font-size: 0.9em; }
.form-group input, .form-group select, .form-group textarea { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box; }
.form-group textarea { min-height: 80px; resize: vertical; }

/* Séparateur pour les sections */
.separator {
    border: none;
    border-top: 2px dashed #ccc;
    margin: 20px 0 30px 0;
}

/* Styles pour le Tableau de Composition (issus de votre second code) */
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
.composition-table .w-delete { width: 50px; text-align: center; }
.composition-table .row-active { background-color: #eaf6ff; }

/* Styles pour les inputs du tableau */
.composition-table .form-control {
    width: 100%;
    padding: 6px;
    border: 1px solid #ccc;
    border-radius: 4px;
    box-sizing: border-box;
}
.composition-table .text-center { text-align: center; }

/* Bouton Supprimer Ligne */
.btn-delete-row {
    background: none;
    border: none;
    cursor: pointer;
    font-size: 1.1em;
    line-height: 1;
    padding: 0;
}

/* Contrôles et Actions */
.row-controls {
    text-align: left;
    margin-top: 10px;
}
.btn-add-row {
    background-color: #2ecc71;
    color: white;
    padding: 8px 15px;
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
    display: flex; justify-content: flex-end; gap: 10px; margin-top: 30px; 
    border-top: 1px solid #eee; padding-top: 20px;
}
.btn-submit { 
    background-color: #3498db; color: white; padding: 10px 20px; border: none; 
    border-radius: 4px; cursor: pointer; font-weight: bold; transition: background-color 0.2s; 
}
.btn-submit:hover:not([disabled]) { background-color: #2980b9; }

/* Messages */
.loading-message { padding: 15px; background-color: #f0f8ff; border: 1px solid #bce8f1; border-radius: 4px; text-align: center; color: #31708f; font-weight: bold; }
.success-message { padding: 10px; border-radius: 4px; margin-bottom: 15px; font-weight: bold; color: #27ae60; background-color: #e9f7ef; border: 1px solid #2ecc71; }
.error-message { padding: 10px; border-radius: 4px; margin-bottom: 15px; font-weight: bold; color: #c0392b; background-color: #fbe Nne; border: 1px solid #e74c3c; }

/* Responsive */
@media (max-width: 768px) {
    .form-row {
        flex-direction: column;
    }
}
</style>