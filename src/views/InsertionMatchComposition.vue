<script setup>
import { ref, onMounted, computed } from 'vue';
import { createMatch } from '@/services/MatchFootService.js';
import SeanceService from '@/services/SeanceService';
import TypeSeanceService from '@/services/TypeSeanceService';
import { TypeSeance } from '@/models/typeSeance';
import { getAllTypeMathce } from '@/services/TypeMatchService';
import { TypeMatch } from '@/models/typeMatch';
import * as CompositionService from '@/services/CompositionService';
import { getAllJoueurs } from '@/services/JoueurService';
import { Seance } from '@/models/seance';

// --- Références Réactives ---
const typesSeance = ref([]);
const typesMatch = ref([]);
const tousLesJoueurs = ref([]);
const successMessage = ref('');
const error = ref(null);
const isLoading = ref(false);

// NOUVEAU: Références pour la recherche
const searchTitulaires = ref('');
const searchRemplacants = ref('');

const form = ref({
    // Données du match
    idTypeMatch: 1,
    competition: 'Compet',
    adversaire: 'Fongitika',
    domicile: true,
    scoreEquipe: 10,
    scoreAdversaire: 5,
    incidents: '',
    observations: '',
    
    // Données de la séance
    idTypeSeance: 2,
    dateSeance: new Date().toISOString().slice(0, 10),
    heureDebut: '13:13',
    heureFin: '14:14',
    lieu: 'Ampefiloha',
    objectif: '',
    bilan: '',

    // Données de la composition
    titulaires: [],
    remplacants: [],
    capitaineId: null,
});

// --- Logique de Récupération des Données ---
const fetchInitialData = async () => {
    try {
        const [typeSeancesData, typeMatchesData, joueursData] = await Promise.all([
            TypeSeanceService.getAllTypeSeances(),
            getAllTypeMathce(),
            getAllJoueurs()
        ]);

        typesSeance.value = TypeSeance.formatTypeSeances(typeSeancesData);
        typesMatch.value = TypeMatch.formatTypeMatch(typeMatchesData);
        tousLesJoueurs.value = joueursData || [];
    } catch (err) {
        error.value = err.message || 'Erreur lors du chargement des données.';
    }
};

onMounted(fetchInitialData);

// --- NOUVEAU: Logique de Filtrage des Joueurs ---
const filteredTitulaires = computed(() => {
    if (!searchTitulaires.value) {
        return tousLesJoueurs.value;
    }
    const searchTerm = searchTitulaires.value.toLowerCase();
    return tousLesJoueurs.value.filter(joueur =>
        `${joueur.prenom} ${joueur.nom}`.toLowerCase().includes(searchTerm)
    );
});

const filteredRemplacants = computed(() => {
    if (!searchRemplacants.value) {
        return tousLesJoueurs.value;
    }
    const searchTerm = searchRemplacants.value.toLowerCase();
    return tousLesJoueurs.value.filter(joueur =>
        `${joueur.prenom} ${joueur.nom}`.toLowerCase().includes(searchTerm)
    );
});

// --- Logique de Soumission (inchangée) ---
const submitForm = async () => {
    isLoading.value = true;
    error.value = null;

    if (form.value.titulaires.length < 1) {
        error.value = "Veuillez sélectionner au moins un joueur titulaire.";
        isLoading.value = false;
        return;
    }
    if (!form.value.capitaineId) {
        error.value = "Veuillez désigner un capitaine parmi les titulaires.";
        isLoading.value = false;
        return;
    }

    try {
        // 1. Créer la Séance
        const seanceData = {
            idTypeSeance: Number(form.value.idTypeSeance), dateSeance: form.value.dateSeance, heureDebut: form.value.heureDebut, heureFin: form.value.heureFin, lieu: form.value.lieu, objectif: form.value.objectif, bilan: form.value.bilan,
            idclubClub: {idclub: 1},
            idstatutseanceStatutseance: {idstatutseance:1}
        };
        const createdSeance = await SeanceService.createSeance(seanceData);
        
        // 2. Créer le Match
        const matchData = {
            idSeance: createdSeance.idseance, idTypeMatch: Number(form.value.idTypeMatch), competition: form.value.competition, adversaire: form.value.adversaire, domicile: form.value.domicile, scoreEquipe: form.value.scoreEquipe, scoreAdversaire: form.value.scoreAdversaire, incidents: form.value.incidents, observations: form.value.observations
        };
        const createdMatch = await createMatch(matchData);
        
       // 3. Préparation de la Composition (inchangée)
        const compositionPayload = [];
        const idMatch = createdMatch.idMatch || createdMatch.id;

        form.value.titulaires.forEach(joueurId => {
            compositionPayload.push({
                idMatch,
                idJoueur: joueurId,
                idStatutComposition: 1, 
                isCapitaine: joueurId === form.value.capitaineId,
            });
        });

        form.value.remplacants.forEach(joueurId => {
            compositionPayload.push({
                idMatch,
                idJoueur: joueurId,
                idStatutComposition: 2,
                isCapitaine: false,
            });
        });

        // 4. Envoyer la composition en parallèle (MODIFIÉ)
        // Crée un tableau de promesses, où chaque promesse est un appel API pour un joueur
        const requests = compositionPayload.map(comp => {
            return CompositionService.createComposition(comp); // Appelle le service pour CHAQUE objet
        });

        // Exécute toutes les promesses en parallèle et attend que TOUTES soient terminées
        const results = await Promise.allSettled(requests);
        
        // Optionnel : Vérifier si des requêtes ont échoué
        const failedRequests = results.filter(result => result.status === 'rejected');
        
        if (failedRequests.length > 0) {
            console.error("Certaines compositions n'ont pas pu être enregistrées:", failedRequests);
            // Gérer l'erreur partielle
            error.value = `${failedRequests.length} composition(s) n'ont pas pu être enregistrée(s).`;
            // Ne pas bloquer le message de succès si certains ont réussi
        }

        successMessage.value = `Opération terminée. ${compositionPayload.length - failedRequests.length} / ${compositionPayload.length} compositions enregistrées.`;
        resetForm();
        setTimeout(() => { successMessage.value = ''; }, 3000);
    } catch (err) {
        console.error("Erreur de soumission :", err);
        error.value = err.message || 'Une erreur est survenue lors de la création.';
    } finally {
        isLoading.value = false;
    }
};

// --- Fonctions Utilitaires ---
const resetForm = () => {
    form.value = {
        idTypeMatch: '1', competition: '', adversaire: '', domicile: true, scoreEquipe: 0, scoreAdversaire: 0, incidents: '', observations: '', idTypeSeance: '2', dateSeance: new Date().toISOString().slice(0, 10), heureDebut: '', heureFin: '', lieu: '', objectif: '', bilan: '', titulaires: [], remplacants: [], capitaineId: null,
    };
};

const capitainesPossibles = computed(() => {
    return tousLesJoueurs.value.filter(joueur => form.value.titulaires.includes(joueur.idJoueur));
});
</script>

<template>
    <div class="page-header">
        <h2>Insertion d'un Match & de sa Composition</h2>
        <router-link to="/matchs" class="btn-add">
            <span>Retour à la liste des matchs</span>
        </router-link>
    </div>
    <div class="match-insert-container">    
        <div v-if="error" class="error-message">{{ error }}</div>
        <div v-if="successMessage" class="success-message">{{ successMessage }}</div>
        
        <form @submit.prevent="submitForm" class="form-container">
            <h3>Informations du Match</h3>
            <div class="form-row">
                <div class="form-group"><label>Compétition :</label><input type="text" v-model="form.competition" required></div>
                <div class="form-group"><label>Adversaire :</label><input type="text" v-model="form.adversaire" required></div>
                <div class="form-group"><label>Type de Match :</label><select v-model="form.idTypeMatch" required><option v-for="type in typesMatch" :key="type.idTypeMatch" :value="type.idTypeMatch">{{ type.libelle }}</option></select></div>
            </div>
            <div class="form-row">
                <div class="form-group"><label>Domicile / Extérieur :</label><select v-model="form.domicile" required><option :value="true">Domicile</option><option :value="false">Extérieur</option></select></div>
                <div class="form-group"><label>Score Équipe :</label><input type="number" v-model.number="form.scoreEquipe" min="0" required></div>
                <div class="form-group"><label>Score Adversaire :</label><input type="number" v-model.number="form.scoreAdversaire" min="0" required></div>
            </div>
             <h3>Détails de la Séance</h3>
             <div class="form-row">
                <div class="form-group"><label>Date :</label><input type="date" v-model="form.dateSeance" required></div>
                <div class="form-group"><label>Heure Début :</label><input type="time" v-model="form.heureDebut" required></div>
                <div class="form-group"><label>Heure Fin :</label><input type="time" v-model="form.heureFin" required></div>
                <div class="form-group"><label>Lieu :</label><input type="text" v-model="form.lieu" required></div>
            </div>

            <h3 class="composition-title">Composition de l'Équipe</h3>
            <div class="composition-container">
                <div class="composition-list">
                    <label>Titulaires ({{ form.titulaires.length }})</label>
                    <input type="text" v-model="searchTitulaires" placeholder="Rechercher un titulaire..." class="search-input">
                    <div class="checkbox-list">
                        <div v-for="joueur in filteredTitulaires" :key="joueur.idJoueur" 
                             class="checkbox-item" :class="{ disabled: form.remplacants.includes(joueur.idJoueur) }">
                            <label>
                                <input type="checkbox" :value="joueur.idJoueur" v-model="form.titulaires"
                                       :disabled="form.remplacants.includes(joueur.idJoueur)">
                                {{ joueur.prenom }} {{ joueur.nom }}
                            </label>
                        </div>
                    </div>
                </div>

                <div class="composition-list">
                    <label>Remplaçants ({{ form.remplacants.length }})</label>
                    <input type="text" v-model="searchRemplacants" placeholder="Rechercher un remplaçant..." class="search-input">
                    <div class="checkbox-list">
                        <div v-for="joueur in filteredRemplacants" :key="joueur.idJoueur"
                             class="checkbox-item" :class="{ disabled: form.titulaires.includes(joueur.idJoueur) }">
                            <label>
                                <input type="checkbox" :value="joueur.idJoueur" v-model="form.remplacants"
                                       :disabled="form.titulaires.includes(joueur.idJoueur)">
                                {{ joueur.prenom }} {{ joueur.nom }}
                            </label>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="form-group captain-select">
                <label>Capitaine :</label>
                <select v-model.number="form.capitaineId" required :disabled="form.titulaires.length === 0">
                    <option :value="null">-- Choisir un capitaine parmi les titulaires --</option>
                    <option v-for="capitaine in capitainesPossibles" :key="capitaine.idJoueur" :value="capitaine.idJoueur">
                        {{ capitaine.prenom }} {{ capitaine.nom }}
                    </option>
                </select>
            </div>
            
            <div class="form-actions">
                <button type="button" @click="resetForm" class="btn-cancel">Annuler</button>
                <button type="submit" class="btn-submit" :disabled="isLoading">
                    {{ isLoading ? 'Enregistrement en cours...' : 'Ajouter le Match & la Compo' }}
                </button>
            </div>
        </form>
    </div>
</template>

<style scoped>
/* Styles généraux (inchangés) */
.match-insert-container { padding: 20px; max-width: 1000px; margin: 0 auto; }
.form-container { background-color: #ffffff; padding: 25px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); }
h3 { margin: 25px 0 15px 0; color: #2c3e50; border-bottom: 1px solid #ddd; padding-bottom: 5px; }
h3:first-of-type { margin-top: 0; }
.composition-title { color: #3498db; }
.form-row { display: flex; gap: 15px; margin-bottom: 15px; }
.form-group { flex: 1; margin-bottom: 15px; }
.form-group label { display: block; margin-bottom: 5px; font-weight: bold; font-size: 0.9em; }
.form-group input, .form-group select, .form-group textarea { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box; }

/* NOUVEAUX STYLES POUR LA COMPOSITION */
.composition-container {
    display: flex;
    gap: 20px;
    margin-bottom: 15px;
}
.composition-list {
    flex: 1;
    display: flex;
    flex-direction: column;
}
.search-input {
    margin-bottom: 10px;
    padding: 8px;
    border: 1px solid #ccc;
    border-radius: 4px;
}
.checkbox-list {
    border: 1px solid #ddd;
    border-radius: 4px;
    padding: 10px;
    max-height: 250px; /* Hauteur maximale avant le défilement */
    overflow-y: auto; /* Ajoute une barre de défilement si nécessaire */
    background-color: #f8f9fa;
}
.checkbox-item {
    display: block; /* Chaque item sur sa propre ligne */
    margin-bottom: 8px;
}
.checkbox-item label {
    display: flex;
    align-items: center;
    gap: 8px;
    font-weight: normal;
    cursor: pointer;
}
.checkbox-item input[type="checkbox"] {
    width: auto; /* Rétablit la taille par défaut du checkbox */
}
.checkbox-item.disabled label {
    color: #aaa;
    cursor: not-allowed;
    text-decoration: line-through;
}

/* Styles pour le capitaine et les actions (inchangés) */
.captain-select { max-width: 50%; }
.success-message, .error-message { padding: 10px; border-radius: 4px; margin-bottom: 15px; font-weight: bold; }
.success-message { color: #27ae60; background-color: #e9f7ef; border: 1px solid #2ecc71; }
.error-message { color: #c0392b; background-color: #fbe Nne; border: 1px solid #e74c3c; }
.form-actions { display: flex; justify-content: flex-end; gap: 10px; margin-top: 20px; border-top: 1px solid #eee; padding-top: 20px; }
.btn-submit, .btn-cancel { padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; font-weight: bold; transition: background-color 0.2s; }
.btn-submit { background-color: #2ecc71; color: white; }
.btn-submit:disabled { background-color: #95a5a6; cursor: not-allowed; }
.btn-cancel { background-color: #e74c3c; color: white; }

/* Responsive */
@media (max-width: 768px) {
    .form-row, .composition-container {
        flex-direction: column;
    }
    .captain-select {
        max-width: 100%;
    }
}
</style>