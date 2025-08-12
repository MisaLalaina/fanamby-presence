<script setup>
  import { ref, computed, onMounted } from 'vue';
  import { getAllJoueurs } from '@/services/JoueurService';
  import { Joueur } from '@/models/joueur';
  import { getAllMatches } from '@/services/MatchFootService.js';
  import { getAllCompositionsByMatchId, getAllStatutCompositions } from '@/services/CompositionService.js';
  
  // Données
  const matches = ref([]);
  const players = ref([]);
  const compositions = ref([]);
  const selectedMatch = ref('');
  const showAddForm = ref(false);
  const editingPlayer = ref(null);
  const playerStatuses = ref([]);

  // Nouveau joueur à ajouter
  const newPlayer = ref({
    idJoueur: '',
    idStatutComposition: 1,
    numeroMaillot: null,
    position: '',
    isCapitaine: false,
    commentaire: ''
  });

  
  // Chargement des données
  const fetchPlayerStatuses = async () => {
    playerStatuses.value = await getAllStatutCompositions();
    
  }

  const fetchMatches = async () => {
    matches.value = await getAllMatches();
  };

  const fetchPlayers = async () => {
    const joueursResp = await getAllJoueurs();
    players.value = Joueur.listFromApiData(joueursResp);
  };

  const fetchComposition = async (matchId) => {
    compositions.value = await getAllCompositionsByMatchId(matchId);
  };

  // Fonctions
  const loadComposition = async () => {
    if (!selectedMatch.value) return;
    await fetchComposition(selectedMatch.value);
    showAddForm.value = false;
  };

  const addPlayerToComposition = async () => {
    const playerInfo = players.value.find(p => p.idJoueur === newPlayer.value.idJoueur);
    
    const newComposition = {
      idComposition: Math.max(...compositions.value.map(c => c.idComposition), 0) + 1,
      idMatch: parseInt(selectedMatch.value),
      ...newPlayer.value,
      ...playerInfo
    };
    
    compositions.value.push(newComposition);
    
    // Réinitialiser le formulaire
    newPlayer.value = {
      idJoueur: '',
      idStatutComposition: 1,
      numeroMaillot: null,
      position: '',
      isCapitaine: false,
      commentaire: ''
    };
    
    showAddForm.value = false;
  };

  const editPlayer = (player) => {
    editingPlayer.value = { ...player };
  };

  const updatePlayer = () => {
    const index = compositions.value.findIndex(c => c.idComposition === editingPlayer.value.idComposition);
    if (index !== -1) {
      compositions.value[index] = { ...editingPlayer.value };
    }
    editingPlayer.value = null;
  };

  const cancelEdit = () => {
    editingPlayer.value = null;
  };

  const removePlayer = (id) => {
    if (confirm('Voulez-vous vraiment retirer ce joueur de la composition ?')) {
      compositions.value = compositions.value.filter(c => c.idComposition !== id);
    }
  };

  const setAsCaptain = (player) => {
    compositions.value.forEach(c => {
      c.isCapitaine = false;
    });
    
    const index = compositions.value.findIndex(c => c.idComposition === player.idComposition);
    if (index !== -1) {
      compositions.value[index].isCapitaine = true;
    }
  };

  const getStatusName = (id) => {
    const status = playerStatuses.value.find(s => s.idStatutComposition === id);
    return status ? status.libelle : 'Inconnu';
  };

  const formatMatchLabel = (match) => {
    return `${match.competition} vs ${match.adversaire} (${formatDate(match.dateMatch)})`;
  };

  const formatDate = (dateStr) => {
    const options = { year: 'numeric', month: 'short', day: 'numeric' };
    return new Date(dateStr).toLocaleDateString('fr-FR', options);
  };

  // Computed properties
  const availablePlayers = computed(() => {
    // Joueurs non encore dans la composition
    const composedPlayerIds = compositions.value.map(c => c.idJoueur);
    return players.value.filter(p => !composedPlayerIds.includes(p.idJoueur));
  });

  const titulaires = computed(() => {
    return compositions.value.filter(c => c.idStatutComposition === 1);
  });

  const remplacants = computed(() => {
    return compositions.value.filter(c => c.idStatutComposition === 2);
  });

  const autresStatuts = computed(() => {
    return compositions.value.filter(c => c.idStatutComposition > 2);
  });

  // Initialisation
  onMounted(() => {
    fetchMatches();
    fetchPlayers();
    fetchPlayerStatuses();
  });
</script>


<template>
  <div class="composition-container">
    <div class="header">
      <h2>Gestion des Compositions</h2>
      <div class="controls">
        <select v-model="selectedMatch" @change="loadComposition">
          <option value="">Sélectionner un match</option>
          <option v-for="match in matches" :key="match.idMatch" :value="match.idMatch">
            {{ formatMatchLabel(match) }}
          </option>
        </select>
        <button v-if="selectedMatch" @click="showAddForm = true" class="btn-add">
          <i class="fas fa-plus"></i> Ajouter joueur
        </button>
      </div>
    </div>

    <!-- Formulaire d'ajout -->
    <div v-if="showAddForm" class="add-form">
      <h3>Ajouter un joueur à la composition</h3>
      <form @submit.prevent="addPlayerToComposition">
        <div class="form-row">
          <div class="form-group">
            <label>Joueur:</label>
            <select v-model="newPlayer.idJoueur" required>
              <option v-for="player in availablePlayers" :key="player.idJoueur" :value="player.idJoueur">
                {{ player.nom }} {{ player.prenom }} ({{ player.poste }})
              </option>
            </select>
          </div>

          <div class="form-group">
            <label>Statut:</label>
            <select v-model="newPlayer.idStatutComposition" required>
              <option v-for="status in playerStatuses" :key="status.idStatutComposition" :value="status.idStatutComposition">
                {{ status.libelle }}
              </option>
            </select>
          </div>
        </div>

        <div class="form-row">
          <div class="form-group">
            <label>Numéro maillot:</label>
            <input type="number" v-model="newPlayer.numeroMaillot" min="1" max="99">
          </div>

          <div class="form-group">
            <label>Position:</label>
            <input type="text" v-model="newPlayer.position">
          </div>
        </div>

        <div class="form-group">
          <label>
            <input type="checkbox" v-model="newPlayer.isCapitaine"> Capitaine
          </label>
        </div>

        <div class="form-group">
          <label>Commentaire:</label>
          <textarea v-model="newPlayer.commentaire"></textarea>
        </div>

        <div class="form-actions">
          <button type="button" @click="showAddForm = false" class="btn-cancel">Annuler</button>
          <button type="submit" class="btn-submit">Ajouter</button>
        </div>
      </form>
    </div>

    <!-- Liste des compositions -->
    <div v-if="selectedMatch" class="composition-list">
      <div class="team-sections">
        <!-- Titulaires -->
        <div class="team-section">
          <h3>Titulaires</h3>
          <table>
            <thead>
              <tr>
                <th>N°</th>
                <th>Joueur</th>
                <th>Poste</th>
                <th>Position</th>
                <th>Capitaine</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="player in titulaires" :key="player.idComposition">
                <td>{{ player.numeroMaillot || '-' }}</td>
                <td>{{ player.nom }} {{ player.prenom }}</td>
                <td>{{ player.poste }}</td>
                <td>{{ player.position || '-' }}</td>
                <td>
                  <i v-if="player.isCapitaine" class="fas fa-star captain-icon"></i>
                  <button v-else @click="setAsCaptain(player)" class="btn-set-captain" title="Définir comme capitaine">
                    <i class="far fa-star"></i>
                  </button>
                </td>
                <td class="actions">
                  <button @click="editPlayer(player)" class="btn-edit" title="Modifier">
                    <i class="fas fa-edit"></i>
                  </button>
                  <button @click="removePlayer(player.idComposition)" class="btn-delete" title="Supprimer">
                    <i class="fas fa-trash"></i>
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>

        <!-- Remplaçants -->
        <div class="team-section">
          <h3>Remplaçants</h3>
          <table>
            <thead>
              <tr>
                <th>N°</th>
                <th>Joueur</th>
                <th>Poste</th>
                <th>Position</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="player in remplacants" :key="player.idComposition">
                <td>{{ player.numeroMaillot || '-' }}</td>
                <td>{{ player.nom }} {{ player.prenom }}</td>
                <td>{{ player.poste }}</td>
                <td>{{ player.position || '-' }}</td>
                <td class="actions">
                  <button @click="editPlayer(player)" class="btn-edit" title="Modifier">
                    <i class="fas fa-edit"></i>
                  </button>
                  <button @click="removePlayer(player.idComposition)" class="btn-delete" title="Supprimer">
                    <i class="fas fa-trash"></i>
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>

        <!-- Autres statuts -->
        <div class="team-section">
          <h3>Autres</h3>
          <table>
            <thead>
              <tr>
                <th>Statut</th>
                <th>Joueur</th>
                <th>Poste</th>
                <th>Commentaire</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="player in autresStatuts" :key="player.idComposition">
                <td>{{ getStatusName(player.idStatutComposition) }}</td>
                <td>{{ player.nom }} {{ player.prenom }}</td>
                <td>{{ player.poste }}</td>
                <td>{{ player.commentaire || '-' }}</td>
                <td class="actions">
                  <button @click="editPlayer(player)" class="btn-edit" title="Modifier">
                    <i class="fas fa-edit"></i>
                  </button>
                  <button @click="removePlayer(player.idComposition)" class="btn-delete" title="Supprimer">
                    <i class="fas fa-trash"></i>
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <!-- Modal d'édition -->
    <div v-if="editingPlayer" class="modal">
      <div class="modal-content">
        <h3>Modifier joueur</h3>
        <form @submit.prevent="updatePlayer">
          <div class="form-row">
            <div class="form-group">
              <label>Statut:</label>
              <select v-model="editingPlayer.idStatutComposition" required>
                <option v-for="status in playerStatuses" :key="status.idStatutComposition" :value="status.idStatutComposition">
                  {{ status.libelle }}
                </option>
              </select>
            </div>

            <div class="form-group">
              <label>Numéro maillot:</label>
              <input type="number" v-model="editingPlayer.numeroMaillot" min="1" max="99">
            </div>
          </div>

          <div class="form-group">
            <label>Position:</label>
            <input type="text" v-model="editingPlayer.position">
          </div>

          <div class="form-group">
            <label>
              <input type="checkbox" v-model="editingPlayer.isCapitaine"> Capitaine
            </label>
          </div>

          <div class="form-group">
            <label>Commentaire:</label>
            <textarea v-model="editingPlayer.commentaire"></textarea>
          </div>

          <div class="form-actions">
            <button type="button" @click="cancelEdit" class="btn-cancel">Annuler</button>
            <button type="submit" class="btn-submit">Enregistrer</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>


<style scoped>
.composition-container {
  padding: 20px;
  max-width: 1200px;
  margin: 0 auto;
}

.header {
  display: flex;
  flex-direction: column;
  gap: 15px;
  margin-bottom: 20px;
}

.controls {
  display: flex;
  gap: 15px;
  align-items: center;
}

select {
  padding: 8px;
  border: 1px solid #ddd;
  border-radius: 4px;
  min-width: 300px;
}

.btn-add {
  background-color: #3498db;
  color: white;
  padding: 8px 15px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 5px;
}

.add-form, .modal-content {
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

.composition-list {
  margin-top: 20px;
}

.team-sections {
  display: flex;
  flex-direction: column;
  gap: 30px;
}

.team-section {
  background-color: #f9f9f9;
  padding: 15px;
  border-radius: 8px;
}

.team-section h3 {
  margin-top: 0;
  color: #2c3e50;
  border-bottom: 1px solid #ddd;
  padding-bottom: 10px;
}

table {
  width: 100%;
  border-collapse: collapse;
  margin-top: 10px;
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
  background-color: #f0f0f0;
}

.actions {
  display: flex;
  gap: 10px;
}

.btn-edit, .btn-delete, .btn-set-captain {
  border: none;
  background: none;
  cursor: pointer;
  font-size: 16px;
  padding: 5px;
}

.btn-edit {
  color: #3498db;
}

.btn-delete {
  color: #e74c3c;
}

.btn-set-captain {
  color: #f39c12;
}

.captain-icon {
  color: #f1c40f;
}

.modal {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.modal-content {
  background-color: white;
  width: 90%;
  max-width: 600px;
  max-height: 90vh;
  overflow-y: auto;
}

@media (max-width: 768px) {
  .form-row {
    flex-direction: column;
    gap: 15px;
  }
  
  .controls {
    flex-direction: column;
    align-items: flex-start;
  }
  
  select {
    min-width: 100%;
  }
}
</style>