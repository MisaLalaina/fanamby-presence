<script setup>
import { ref, computed, onMounted } from 'vue';
import { getAllJoueurs } from '@/services/JoueurService';
import { getAllPostes } from '@/services/PosteService';
import { Joueur } from '@/models/joueur';
import { Poste } from '@/models/poste';

const postes = ref(['TOUS']);
const joueurs = ref([]);
const currentFilter = ref('TOUS');

const loadData = async () => {
  try {
    // Fetch postes and prepend 'TOUS'
    const postesResp = await getAllPostes();
    const postesList = Poste.listFromApiData(postesResp);
    postes.value = ['TOUS', ...postesList.map(p => p.libelle.toUpperCase())];

    // Fetch joueurs
    const joueursResp = await getAllJoueurs();
    joueurs.value = Joueur.listFromApiData(joueursResp);
  } catch (err) {
    console.error('Erreur chargement données:', err);
  }
};

onMounted(() => {
  loadData();
});

const filteredJoueurs = computed(() => {
  if (currentFilter.value === 'TOUS') return joueurs.value;
  return joueurs.value.filter(j => j.poste === currentFilter.value);
});

const groupedJoueurs = computed(() => {
  const groups = [];
  for (let i = 0; i < filteredJoueurs.value.length; i += 4) {
    groups.push(filteredJoueurs.value.slice(i, i + 4));
  }
  return groups;
});

const filterByPoste = (poste) => {
  currentFilter.value = poste;
};
</script>


<template>
  <div class="joueurs-container">
    <h1>LISTE DE JOUEURS</h1>
    
    <div class="filter-buttons">
      <button 
        v-for="poste in postes" 
        :key="poste" 
        @click="filterByPoste(poste)"
        :class="{ active: currentFilter === poste }"
      >
        {{ poste }}
      </button>
    </div>

    <div class="joueurs-grid">
      <div 
        v-for="(group, index) in groupedJoueurs" 
        :key="index" 
        class="joueur-group"
      >
        <div 
          v-for="joueur in group" 
          :key="joueur.id" 
          class="joueur-card"
        >
          <img src="https://placehold.co/150x100" alt="Avatar" class="joueur-avatar">
          <div class="joueur-numero">{{ joueur.numero }}</div>
          <div class="joueur-nom">{{ joueur.nom }}</div>
          <div class="joueur-poste">{{ joueur.poste }}</div>
          <div class="joueur-info">Né le {{ joueur.dateNaissance }}</div>
          <div class="joueur-nationalite">Nat. {{ joueur.nationalite }}</div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.joueurs-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 30px;
}

h1 {
  text-align: center;
  color: #2c3e50;
  margin-bottom: 30px;
  text-transform: uppercase;
  font-size: 28px;
  letter-spacing: 2px;
}

.filter-buttons {
  display: flex;
  justify-content: center;
  gap: 15px;
  margin-bottom: 30px;
  flex-wrap: wrap;
}

.filter-buttons button {
  padding: 10px 20px;
  border: none;
  background-color: #e0e0e0;
  border-radius: 30px;
  font-weight: bold;
  cursor: pointer;
  transition: all 0.3s;
  text-transform: uppercase;
  font-size: 14px;
}

.filter-buttons button.active {
  background-color: #3498db;
  color: white;
}

.filter-buttons button:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.joueurs-grid {
  display: flex;
  flex-direction: column;
  gap: 30px;
}

.joueur-group {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
}

.joueur-card {
  background-color: white;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
  text-align: center;
  border-top: 4px solid #3498db;
  transition: transform 0.3s, box-shadow 0.3s;
}

.joueur-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
}

.joueur-numero {
  font-size: 24px;
  font-weight: bold;
  color: #2c3e50;
  margin-bottom: 10px;
}

.joueur-nom {
  font-size: 18px;
  font-weight: bold;
  color: #2c3e50;
  margin-bottom: 5px;
  text-transform: uppercase;
}

.joueur-poste {
  font-size: 16px;
  color: #e74c3c;
  margin-bottom: 10px;
  font-weight: bold;
  text-transform: uppercase;
}

.joueur-info {
  font-size: 14px;
  color: #555;
  margin-bottom: 5px;
}

.joueur-nationalite {
  font-size: 14px;
  color: #555;
  font-style: italic;
}

@media (max-width: 1024px) {
  .joueur-group {
    grid-template-columns: repeat(3, 1fr);
  }
}

@media (max-width: 768px) {
  .joueur-group {
    grid-template-columns: repeat(2, 1fr);
  }
  
  .filter-buttons {
    flex-direction: column;
    align-items: center;
  }
  
  .filter-buttons button {
    width: 80%;
  }
}

@media (max-width: 480px) {
  .joueur-group {
    grid-template-columns: 1fr;
  }
  
  .joueurs-container {
    padding: 20px;
  }
}
</style>