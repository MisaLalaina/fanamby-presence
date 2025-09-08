<template>
  <div class="p-6 space-y-6">
    <!-- En-tête -->
    <h1 class="text-2xl font-bold"></h1>

    <!-- Statistiques globales -->
    <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
      <div v-for="card in generalCards" :key="card.label" class="p-4 bg-white rounded-2xl shadow">
        <h2 class="text-sm text-gray-500">{{ card.label }}</h2>
        <p class="text-xl font-bold">{{ card.value }}</p>
      </div>
    </div>

    <!-- Graphiques -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <div class="p-4 bg-white rounded-2xl shadow">
        <h2 class="text-lg font-semibold mb-2">Présence par mois</h2>
        <canvas id="chartPresenceMois"></canvas>
      </div>
      <div class="p-4 bg-white rounded-2xl shadow">
        <h2 class="text-lg font-semibold mb-2">Répartition par type de séance</h2>
        <canvas id="chartTypes"></canvas>
      </div>
    </div>

    <!-- Tableau des joueurs -->
    <div class="p-4 bg-white rounded-2xl shadow">
      <h2 class="text-lg font-semibold mb-4">Statistiques individuelles</h2>
      <table class="w-full border-collapse">
        <thead>
          <tr class="bg-gray-100 text-left">
            <th class="p-2">Joueur</th>
            <th class="p-2">Poste</th>
            <th class="p-2">Présences</th>
            <th class="p-2">Absences</th>
            <th class="p-2">Entraînements ✔️</th>
            <th class="p-2">Matches ✔️</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="joueur in joueurs" :key="joueur.idJoueur" class="border-b">
            <td class="p-2">{{ joueur.nom }} {{ joueur.prenom }}</td>
            <td class="p-2">{{ joueur.poste }}</td>
            <td class="p-2">{{ joueur.presentes }}</td>
            <td class="p-2">{{ joueur.absences }}</td>
            <td class="p-2">{{ joueur.entrainements_presents }}</td>
            <td class="p-2">{{ joueur.matches_presents }}</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script setup>
import { onMounted, ref } from "vue";
import Chart from "chart.js/auto";

const generalCards = ref([]);
const joueurs = ref([]);

onMounted(async () => {
  // 🔹 Exemple d'API fetch (à remplacer par ton backend qui expose les vues SQL)
  const resGeneral = await fetch("/api/statistiques/generales");
  const dataGeneral = await resGeneral.json();

  const resIndividuel = await fetch("/api/statistiques/individuelles");
  const dataIndividuel = await resIndividuel.json();

  // Remplir les cartes globales
  generalCards.value = [
    { label: "Joueurs", value: dataGeneral.total_joueurs },
    { label: "Séances", value: dataGeneral.total_seances },
    { label: "Présences", value: dataGeneral.total_presents },
    { label: "Taux de présence", value: dataGeneral.taux_presence_moyen + "%" },
  ];

  // Charger les joueurs
  joueurs.value = dataIndividuel;

  // Graphique 1 : Présence par mois
  new Chart(document.getElementById("chartPresenceMois"), {
    type: "line",
    data: {
      labels: [...new Set(dataIndividuel.map(j => j.annee_mois))],
      datasets: [
        {
          label: "Présences",
          data: dataIndividuel.map(j => j.presentes),
          borderColor: "green",
          fill: false,
        },
        {
          label: "Absences",
          data: dataIndividuel.map(j => j.absences),
          borderColor: "red",
          fill: false,
        },
      ],
    },
  });

  // Graphique 2 : Présence par type
  new Chart(document.getElementById("chartTypes"), {
    type: "doughnut",
    data: {
      labels: ["Entraînements", "Matches"],
      datasets: [
        {
          data: [
            dataGeneral.entrainements_presents,
            dataGeneral.matches_presents,
          ],
          backgroundColor: ["#3b82f6", "#f59e0b"],
        },
      ],
    },
  });
});
</script>

<style scoped>
  :root {
            --primary-color: #3498db;
            --secondary-color: #2c3e50;
            --success-color: #2ecc71;
            --warning-color: #f39c12;
            --danger-color: #e74c3c;
            --light-color: #ecf0f1;
            --dark-color: #2c3e50;
        }
        
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .navbar {
            background-color: var(--secondary-color);
        }
        
        .card {
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s;
            margin-bottom: 20px;
        }
        
        .card:hover {
            transform: translateY(-5px);
        }
        
        .stat-card {
            text-align: center;
            padding: 20px;
        }
        
        .stat-number {
            font-size: 2.5rem;
            font-weight: bold;
        }
        
        .stat-title {
            font-size: 1rem;
            color: #6c757d;
        }
        
        .filter-section {
            background-color: white;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
        }
        
        .chart-container {
            position: relative;
            height: 300px;
            margin-bottom: 30px;
        }
        
        .presence-badge {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: bold;
        }
        
        .present {
            background-color: rgba(46, 204, 113, 0.2);
            color: #27ae60;
        }
        
        .absent {
            background-color: rgba(231, 76, 60, 0.2);
            color: #c0392b;
        }
        
        .table-hover tbody tr:hover {
            background-color: rgba(52, 152, 219, 0.1);
        }
</style>
