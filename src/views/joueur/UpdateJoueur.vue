<script>
import SideBar from '@/components/SideBar.vue';
import { onMounted, ref, watch } from 'vue';
// Importations nécessaires pour l'UPDATE
import { useRoute, useRouter } from 'vue-router';
import { updateJoueur, getJoueurById } from '@/services/JoueurService'; // Assurez-vous d'avoir getJoueurById et updateJoueur dans votre service
// Importations existantes
import { getAllPostes } from '@/services/PosteService';
import { Poste } from '@/models/poste';
import { getAllPiedsFort } from '@/services/PiedFortService';
import { PiedFort } from '@/models/piedFort';

export default {
    name: 'JoueurUpdate',
    components: { SideBar },
    setup() {
        // --- ROUTER & ROUTE ---
        const route = useRoute();
        const router = useRouter();

        // --- ÉTATS D'INTERFACE ---
        const isLoading = ref(true);
        const errorMessage = ref(null);
        const successMessage = ref(null);

        // --- DONNÉES DU JOUEUR (Initialisation vide) ---
        const joueur = ref({
            idjoueur: '',
            idclubClub: { idclub: 1 },
            idpostePoste: { idposte: 1 },
            idstatutjoueurStatutjoueur: { idstatutjoueur: 1 },
            idpiedfortPiedfort: { idpiedfort: 1 },
            nom: '',
            prenom: '',
            datenaissance: '',
            dateinscription: new Date().toISOString().slice(0, 10),
            nationalite: 'Malagasy',
            taille: '',
            poids: '',
            numeromaillot:'',
            adresse: '',
            telephone: '',
            email: ''
        });

        // --- LISTES DE SÉLECTION ---
        const postes = ref([]);
        const piedsFort = ref([]);

        // --- LOGIQUE DE CHARGEMENT ET MISE À JOUR ---

        const fetchPostes = async () => {
            try {
                const data = await getAllPostes();
                console.log(data);
                
                postes.value = data;
            } catch (error) {
                console.error("Erreur lors du chargement des postes :", error);
                errorMessage.value = "Impossible de charger les postes.";
            }
        };

        const fetchPiedsFort = async () => {
            try {
                const data = await getAllPiedsFort();
                piedsFort.value = data;
            } catch (error) {
                console.error("Erreur lors du chargement des pieds fort :", error);
                errorMessage.value = "Impossible de charger les pieds forts.";
            }
        };

        const fetchJoueurData = async () => {
            isLoading.value = true;
            errorMessage.value = null;
            const joueurId = route.params.id;

            if (!joueurId) {
                errorMessage.value = "ID du joueur manquant dans l'URL.";
                isLoading.value = false;
                return;
            }
            
            try {
                const data = await getJoueurById(joueurId);
                if (data) {
                    joueur.value = data.getDTO()
                }

            } catch (error) {
                console.error("Erreur lors du chargement des données du joueur :", error);
                errorMessage.value = `Impossible de charger le joueur avec l'ID ${joueurId}.`;
            } finally {
                isLoading.value = false;
            }
        };

        const submitForm = async () => {
            errorMessage.value = null;
            successMessage.value = null;
            isLoading.value = true;
            const joueurId = route.params.id;
            try {
                const payload = {
                    ...joueur.value,
                };
                await updateJoueur(joueurId, payload); 

                successMessage.value = 'Joueur mis à jour avec succès ! ✅';
                
                // Redirection ou annulation après un court délai
                setTimeout(() => {
                    router.push({ path: '/joueurs' }); // Adaptez le nom de la route de la liste
                }, 1500);

            } catch (error) {
                console.error("Erreur lors de la mise à jour du joueur :", error);
                errorMessage.value = error.response?.data?.message || 'Erreur lors de la mise à jour du joueur.';
            } finally {
                isLoading.value = false;
            }
        };

        const goBack = () => {
            // Revenir à la page précédente ou à la liste des joueurs
            router.go(-1);
        };

        // --- HOOKS ET WATCHERS ---

        onMounted(() => {
            fetchPostes();
            fetchPiedsFort();
            fetchJoueurData();
        });
        
        return {
            joueur,
            postes,
            piedsFort,
            submitForm,
            goBack, // Nouvelle fonction d'annulation
            isLoading,
            errorMessage,
            successMessage
        };
    }
};
</script>

<template>
    <div class="page-header">
      <h2>Modification joueur</h2>
      <router-link to="/joueurs" class="btn-add">
        <span>Retour a la liste des joueurs</span>
      </router-link>
    </div>
    <div class="form-container">
        <h1>Modification du joueur #{{ joueur.idjoueur }}</h1>
        
        <div v-if="errorMessage" class="message error-message">{{ errorMessage }}</div>
        <div v-if="successMessage" class="message success-message">{{ successMessage }}</div>

        <div v-if="isLoading" class="loading-overlay">
            <div class="loader"></div>
            <p>Chargement des données...</p>
        </div>

        <form v-else @submit.prevent="submitForm" class="player-form">
            <div class="form-row">
                <div class="form-group">
                    <label for="nom">Nom*</label>
                    <input 
                        type="text" 
                        id="nom" 
                        v-model="joueur.nom" 
                        required
                        placeholder="Entrez le nom"
                    >
                </div>
                
                <div class="form-group">
                    <label for="prenom">Prénom*</label>
                    <input 
                        type="text" 
                        id="prenom" 
                        v-model="joueur.prenom" 
                        required
                        placeholder="Entrez le prénom"
                    >
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="inscription">Date Inscription</label>
                    <input 
                        type="date" 
                        id="inscription" 
                        v-model="joueur.dateinscription" 
                        required
                        placeholder="Entrez la date d'inscription"
                    >
                </div>

                <div class="form-group">
                    <label for="naissance">Date de naissance*</label>
                    <input 
                        type="date" 
                        id="naissance" 
                        v-model="joueur.datenaissance" 
                        required
                        @change="calculerAge"
                    >
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="numeroMaillot">Numéro de maillot*</label>
                    <input 
                        type="number" 
                        id="numeroMaillot" 
                        v-model="joueur.numeromaillot" 
                        placeholder="Ex: 10"
                    >
                </div>

                <div class="form-group">
                    <label for="poste">Poste*</label>
                    <select 
                        id="poste" 
                        v-model="joueur.idpostePoste.idposte" 
                        required
                        class="form-control"
                    >
                        <option v-for="poste in postes" :key="poste.id" :value="poste.id">
                            {{ poste.libelle }}
                        </option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="piedfort">Pied fort*</label>
                    <select 
                        id="piedfort" 
                        v-model="joueur.idpiedfortPiedfort.idpiedfort" 
                        required
                        class="form-control"
                    >
                        <option v-for="piedfort in piedsFort" :key="piedfort.id" :value="piedfort.id">
                            {{ piedfort.libelle }}
                        </option>
                    </select>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="nationalite">Nationalité*</label>
                    <input 
                        type="text" 
                        id="nationalite" 
                        v-model="joueur.nationalite" 
                        required
                        placeholder="Ex: Malagasy, Français"
                    >
                </div>
                <div class="form-group">
                    <label for="taille">Taille (en cm)*</label>
                    <input 
                        type="number" 
                        id="taille" 
                        v-model="joueur.taille" 
                        placeholder="Ex: 175"
                    >
                </div>
                <div class="form-group">
                    <label for="poids">Poids (en kg)*</label>
                    <input 
                        type="number" 
                        id="poids" 
                        v-model="joueur.poids" 
                        placeholder="Ex: 68"
                    >
                </div>
            </div>

            <div class="form-group full-width">
                <label for="adresse">Adresse*</label>
                <input 
                    type="text" 
                    id="adresse" 
                    v-model="joueur.adresse" 
                    required
                    placeholder="Entrez l'adresse complète"
                >
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="contact">Téléphone*</label>
                    <input 
                        type="tel" 
                        id="contact" 
                        v-model="joueur.telephone" 
                        placeholder="Ex: +261 32 12 345 67"
                        pattern="[+]{1}[0-9]{3} [0-9]{2} [0-9]{2} [0-9]{3} [0-9]{2}"
                    >
                </div>
                
                <div class="form-group">
                    <label for="email">Email</label>
                    <input 
                        type="email" 
                        id="email" 
                        v-model="joueur.email" 
                        placeholder="joueur@example.com"
                    >
                </div>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn-submit" :disabled="isLoading">
                    {{ isLoading ? 'Mise à jour...' : 'Mettre à jour' }}
                </button>
                <button type="button" class="btn-cancel" @click="goBack">Annuler</button>
            </div>
        </form>
    </div>
</template>

<style scoped>
/* Les styles restent majoritairement les mêmes, ajustons les couleurs des boutons pour la modification */

.form-container {
    max-width: 800px;
    margin: 0 auto;
    padding: 30px;
    background-color: #f8f9fa;
    border-radius: 10px;
    box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
}

h1 {
    text-align: center;
    color: #2c3e50;
    margin-bottom: 30px;
    font-size: 28px;
}

.player-form {
    display: flex;
    flex-direction: column;
    gap: 20px;
}

.form-row {
    display: flex;
    gap: 20px;
}

.form-group {
    flex: 1;
    display: flex;
    flex-direction: column;
}

.form-group.full-width {
    flex: 100%;
}

label {
    margin-bottom: 8px;
    font-weight: 600;
    color: #2c3e50;
    font-size: 14px;
}

input, select {
    padding: 12px 15px;
    border: 1px solid #ddd;
    border-radius: 6px;
    font-size: 16px;
    transition: border-color 0.3s;
    width: 100%; /* Assurer que les selects s'étendent */
}

input:focus, select:focus {
    border-color: #3498db;
    outline: none;
    box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.2);
}

input:disabled {
    background-color: #f0f0f0;
    color: #555;
}

.form-actions {
    display: flex;
    justify-content: flex-end;
    gap: 15px;
    margin-top: 20px;
}

.btn-submit, .btn-cancel {
    padding: 12px 25px;
    border: none;
    border-radius: 6px;
    font-size: 16px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s;
}

/* Changer la couleur principale du bouton d'action pour le distinguer de l'insertion */
.btn-submit {
    background-color: #3498db; /* Bleu pour "Mettre à jour" */
    color: white;
}

.btn-submit:hover {
    background-color: #2980b9;
}

.btn-cancel {
    background-color: #95a5a6; /* Gris pour "Annuler/Retour" */
    color: white;
}

.btn-cancel:hover {
    background-color: #7f8c8d;
}

/* Styles pour les messages */
.message {
    padding: 15px;
    margin-bottom: 20px;
    border-radius: 8px;
    font-weight: 600;
    text-align: center;
}

.error-message {
    background-color: #f8d7da;
    color: #721c24;
    border: 1px solid #f5c6cb;
}

.success-message {
    background-color: #d4edda;
    color: #155724;
    border: 1px solid #c3e6cb;
}

/* Overlay de chargement */
.loading-overlay {
    text-align: center;
    padding: 40px;
    color: #3498db;
    font-size: 1.2em;
}

.loader {
    border: 4px solid #f3f3f3;
    border-top: 4px solid #3498db;
    border-radius: 50%;
    width: 30px;
    height: 30px;
    animation: spin 1s linear infinite;
    margin: 0 auto 10px;
}

@keyframes spin {
    0% { transform: rotate(0deg); }
    100% { transform: rotate(360deg); }
}

@media (max-width: 768px) {
    .form-row {
        flex-direction: column;
        gap: 20px;
    }
    
    .form-container {
        padding: 20px;
    }
    
    .form-actions {
        justify-content: center;
    }
}
</style>