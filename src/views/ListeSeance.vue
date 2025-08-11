<template>
  <div class="seance-list-container">
    <h1>Liste des séances</h1>
    <div class="filter-controls">
      <select v-model="filterType" @change="filterSeances">
        <option value="">Tous les types</option>
        <option v-for="type in typesSeance" :key="type.idTypeSeance" :value="type.idTypeSeance">
          {{ type.libelle }}
        </option>
      </select>
      <input type="date" v-model="filterDate" @change="filterSeances" placeholder="Filtrer par date">
    </div>
    <table>
      <thead>
        <tr>
          <th>Type</th>
          <th>Date</th>
          <th>Heures</th>
          <th>Lieu</th>
          <th>Objectif</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="seance in filteredSeances" :key="seance.idSeance">
          <td>{{ getTypeName(seance.idTypeSeance) }}</td>
          <td>{{ formatDate(seance.dateSeance) }}</td>
          <td>{{ seance.heureDebut }} - {{ seance.heureFin }}</td>
          <td>{{ seance.lieu }}</td>
          <td>{{ truncateText(seance.objectif, 30) }}</td>
          <td>
            <button @click="editSeance(seance)" class="btn-edit">✏️</button>
            <button @click="confirmDelete(seance.idSeance)" class="btn-delete">🗑️</button>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue';

export default {
  name: 'ListeSeance',
  setup() {
    const typesSeance = ref([
      { idTypeSeance: 1, libelle: 'Entrainement', description: 'Séance d entraînement régulière' },
      { idTypeSeance: 2, libelle: 'Match amical', description: 'Match sans enjeu compétitif' },
      { idTypeSeance: 3, libelle: 'Match officiel', description: 'Match de championnat ou coupe' },
      { idTypeSeance: 4, libelle: 'Seance physique', description: 'Séance axée sur la condition physique' },
      { idTypeSeance: 5, libelle: 'Seance tactique', description: 'Séance axée sur la tactique d équipe' }
    ]);

    const seances = ref([]);
    const filteredSeances = ref([]);
    const filterType = ref('');
    const filterDate = ref('');

    const fetchSeances = async () => {
      // Simuler un appel API
      seances.value = [
        {
          idSeance: 1,
          idTypeSeance: 1,
          dateSeance: '2023-10-15',
          heureDebut: '08:00',
          heureFin: '10:00',
          lieu: 'Terrain principal',
          objectif: 'Amélioration des passes et du jeu collectif',
          bilan: 'Bonne séance, participation active de tous'
        },
        {
          idSeance: 2,
          idTypeSeance: 2,
          dateSeance: '2023-10-20',
          heureDebut: '15:00',
          heureFin: '17:00',
          lieu: 'Stade municipal',
          objectif: 'Tester de nouvelles combinaisons offensives',
          bilan: 'Match équilibré, nouvelles stratégies efficaces'
        }
      ];
      filteredSeances.value = [...seances.value];
    };

    const filterSeances = () => {
      filteredSeances.value = seances.value.filter(seance => {
        const typeMatch = !filterType.value || seance.idTypeSeance == filterType.value;
        const dateMatch = !filterDate.value || seance.dateSeance === filterDate.value;
        return typeMatch && dateMatch;
      });
    };

    const getTypeName = (id) => {
      const type = typesSeance.value.find(t => t.idTypeSeance === id);
      return type ? type.libelle : 'Inconnu';
    };

    const formatDate = (dateStr) => {
      const options = { year: 'numeric', month: 'short', day: 'numeric' };
      return new Date(dateStr).toLocaleDateString('fr-FR', options);
    };

    const truncateText = (text, length) => {
      if (!text) return '';
      return text.length > length ? text.substring(0, length) + '...' : text;
    };

    const editSeance = (seance) => {
      alert('Fonction d\'édition à implémenter');
    };

    const confirmDelete = (id) => {
      if (confirm('Voulez-vous vraiment supprimer cette séance ?')) {
        seances.value = seances.value.filter(s => s.idSeance !== id);
        filterSeances();
      }
    };

    onMounted(() => {
      fetchSeances();
    });

    return {
      typesSeance,
      seances,
      filteredSeances,
      filterType,
      filterDate,
      filterSeances,
      getTypeName,
      formatDate,
      truncateText,
      editSeance,
      confirmDelete
    };
  }
}
</script>

<style scoped>
.seance-list-container {
  padding: 20px;
  max-width: 1200px;
  margin: 0 auto;
}

.filter-controls {
  display: flex;
  gap: 15px;
  margin-bottom: 15px;
}

.filter-controls select,
.filter-controls input {
  padding: 8px;
  border: 1px solid #ddd;
  border-radius: 4px;
}

table {
  width: 100%;
  border-collapse: collapse;
}

th, td {
  padding: 12px 15px;
  text-align: left;
  border-bottom: 1px solid #ddd;
}

th {
  background-color: #f2f2f2;
}

tr:hover {
  background-color: #f5f5f5;
}

.btn-edit, .btn-delete {
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
</style>
