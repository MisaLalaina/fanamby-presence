<script>
export default {
  name: 'InsertionRapidePresence',
  data() {
    // Exemple de séances et joueurs (à remplacer par vos données dynamiques)
    const seances = [
      { id: 1, label: 'Entraînement Lundi' },
      { id: 2, label: 'Match Mercredi' },
      { id: 3, label: 'Entraînement Vendredi' }
    ];
    const joueurs = [
      { id: 1, nom: 'RAKOTO' },
      { id: 2, nom: 'RANDRIA' },
      { id: 3, nom: 'MIA' },
      { id: 4, nom: 'KELY' }
    ];

    // Initialisation des présences
    const presences = {};
    seances.forEach(seance => {
      presences[seance.id] = {};
      joueurs.forEach(joueur => {
        presences[seance.id][joueur.id] = false; // false = absent, true = présent
      });
    });

    return {
      seances,
      joueurs,
      selectedSeance: seances[0].id,
      presences,
      searchTerm: '' // Nouveau champ pour la recherche
    }
  },
  computed: {
    filteredJoueurs() {
      if (!this.searchTerm) return this.joueurs;
      const term = this.searchTerm.toLowerCase();
      return this.joueurs.filter(joueur => 
        joueur.nom.toLowerCase().includes(term)
      );
    }
  },
  methods: {
    savePresence() {
      const dataToSave = this.joueurs.map(joueur => ({
        joueur: joueur.nom,
        present: this.presences[this.selectedSeance][joueur.id]
      }));
      console.log("Présences à enregistrer:", {
        seance: this.selectedSeance,
        presences: dataToSave
      });
      alert("Présences enregistrées !");
      // Appel API ici si besoin
    }
  }
}
</script>

<template>
  <div class="presence-container">
    <div class="card">
      <h2>Insertion rapide des présences</h2>
      <form @submit.prevent="savePresence">
        <div class="form-row">
          <div class="form-group">
            <label for="seance-select">Séance :</label>
            <select id="seance-select" v-model="selectedSeance" class="form-control">
              <option v-for="seance in seances" :key="seance.id" :value="seance.id">
                {{ seance.label }}
              </option>
            </select>

            <!-- filtre recherche joueur -->
             <input 
              id="player-search" 
              type="text" 
              v-model="searchTerm" 
              placeholder="Entrez un nom de joueur..."
              class="form-control"
            />
          </div>
          
        </div>

        <div class="table-responsive">
          <table class="presence-table">
            <thead>
              <tr>
                <th>Joueur</th>
                <th>Présent</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="joueur in filteredJoueurs" :key="joueur.id">
                <td>{{ joueur.nom }}</td>
                <td>
                  <label class="checkbox-container">
                    <input
                      type="checkbox"
                      v-model="presences[selectedSeance][joueur.id]"
                    />
                    <span class="checkmark"></span>
                  </label>
                </td>
              </tr>
            </tbody>
          </table>
        </div>

        <button type="submit" class="btn-save">Enregistrer les présences</button>
      </form>
    </div>
  </div>
</template>

<style scoped>
/* Style alternatif moderne */
.presence-container {
  max-width: 1000px;
  margin: 2rem auto;
  padding: 0 1rem;
  font-family: 'Segoe UI', system-ui, sans-serif;
}

/* .card {
  background: white;
  border-radius: 12px;
  box-shadow: 0 4px 20px rgba(23, 71, 115, 0.1);
  padding: 2rem;
  border: none;
} */

h2 {
  color: #164773;
  font-size: 1.8rem;
  font-weight: 700;
  margin-bottom: 2rem;
  text-align: center;
  letter-spacing: -0.5px;
}

.form-row {
  display: flex;
  flex-direction: column;
  gap: 1.25rem;
  margin-bottom: 1.5rem;
}

.form-group {
  margin-bottom: 1.25rem;
}

label {
  display: block;
  margin-bottom: 0.75rem;
  font-size: 0.95rem;
  font-weight: 600;
  color: #1B578C;
}

.form-control {
  width: 100%;
  padding: 0.85rem 1.25rem;
  border: 2px solid #e3edf4;
  border-radius: 8px;
  font-size: 1rem;
  transition: all 0.25s ease;
  background-color: white;
  color: #333;
}

.form-control:focus {
  outline: none;
  border-color: #2493BF;
  box-shadow: 0 0 0 4px rgba(36, 147, 191, 0.15);
}

.presence-table {
  width: 100%;
  border-collapse: separate;
  border-spacing: 0;
  background: white;
  border-radius: 10px;
  overflow: hidden;
  margin: 1.5rem 0;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

.presence-table thead {
  background: linear-gradient(135deg, #1B578C 0%, #2493BF 100%);
}

.presence-table th {
  padding: 1.1rem 1.5rem;
  text-align: left;
  font-size: 0.85rem;
  font-weight: 600;
  color: white;
  letter-spacing: 0.5px;
}

.presence-table td {
  padding: 1.1rem 1.5rem;
  border-bottom: 1px solid #f0f6fa;
  color: #444;
  font-size: 0.95rem;
  background: white;
}

.presence-table tr:not(:last-child) td {
  border-bottom: 1px solid #e3edf4;
}

.presence-table tr:hover td {
  background-color: #f8fbfd;
}

/* Style personnalisé des checkboxes */
.checkbox-container {
  display: inline-block;
  position: relative;
  width: 24px;
  height: 24px;
}

.checkbox-container input {
  opacity: 0;
  width: 0;
  height: 0;
  position: absolute;
}

.checkmark {
  position: absolute;
  top: 0;
  left: 0;
  width: 24px;
  height: 24px;
  background-color: white;
  border: 2px solid #c2d6e5;
  border-radius: 6px;
  transition: all 0.25s ease;
}

.checkbox-container:hover .checkmark {
  border-color: #2A86BF;
}

.checkbox-container input:checked ~ .checkmark {
  background-color: #2A86BF;
  border-color: #2A86BF;
}

.checkmark:after {
  content: "";
  position: absolute;
  display: none;
  left: 8px;
  top: 4px;
  width: 6px;
  height: 12px;
  border: solid white;
  border-width: 0 2px 2px 0;
  transform: rotate(45deg);
}

.checkbox-container input:checked ~ .checkmark:after {
  display: block;
}

.btn-save {
  display: inline-block;
  width: auto;
  padding: 0.9rem 2.5rem;
  background: linear-gradient(to right, #1B578C, #2A86BF);
  color: white;
  border: none;
  border-radius: 8px;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.25s ease;
  margin-top: 1rem;
  box-shadow: 0 4px 12px rgba(27, 87, 140, 0.2);
  float: right;
}

.btn-save:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 16px rgba(27, 87, 140, 0.25);
}

/* Effets de focus accessibilité */
*:focus {
  outline: 2px dashed #2493BF;
  outline-offset: 2px;
}

/* Animation subtile des lignes */
@keyframes slideIn {
  from {
    opacity: 0;
    transform: translateX(10px);
  }
  to {
    opacity: 1;
    transform: translateX(0);
  }
}

.presence-table tbody tr {
  animation: slideIn 0.35s ease-out forwards;
}

.presence-table tbody tr:nth-child(1) { animation-delay: 0.05s; }
.presence-table tbody tr:nth-child(2) { animation-delay: 0.1s; }
.presence-table tbody tr:nth-child(3) { animation-delay: 0.15s; }
.presence-table tbody tr:nth-child(4) { animation-delay: 0.2s; }

/* Clearfix pour le bouton flottant */
.card::after {
  content: "";
  display: table;
  clear: both;
}
</style>