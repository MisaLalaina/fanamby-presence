<template>
  <div class="player-profile-container">
    <div class="profile-card">

      <header class="profile-header">
        <div class="photo-container">
          <img 
            :src="'joueurs/'+player.id+'.jpg'" 
            :alt="'Photo de ' + player.nom" 
            class="profile-photo"
            @error="onImageError"
          >
          <div class="player-number-badge">{{ player.numero }}</div>
        </div>

        <div class="header-details">
          <div class="player-full-name">
            {{ player.prenom }} <span class="last-name">{{ player.nom }}</span>
          </div>
          <div class="player-poste-main">
            {{ player.poste }}
          </div>
          
          <div class="bio-info-line">
            <span class="info-icon">🌍</span> {{ player.nationalite }}
          </div>
          <div class="bio-info-line">
            <span class="info-icon">🎂</span> Né le {{ player.dateNaissance }}
          </div>
        </div>
      </header>

      <div class="profile-body">
        
        <section class="stat-section">
          <h2>Informations Détaillées</h2>
          <div class="stat-grid">
            <div class="stat-item">
              <span class="stat-label">Taille</span>
              <span class="stat-value">{{ player.taille || 'N/A' }} cm</span>
            </div>
            <div class="stat-item">
              <span class="stat-label">Poids</span>
              <span class="stat-value">{{ player.poids || 'N/A' }} kg</span>
            </div>
            <div class="stat-item">
              <span class="stat-label">Pied Fort</span>
              <span class="stat-value">{{ player.piedFort || 'Droit' }}</span>
            </div>
            <div class="stat-item">
              <span class="stat-label">Statut</span>
              <span :class="'stat-value status-'+String(player.status).toLowerCase()">{{ player.status }}</span>
            </div>
          </div>
        </section>

        <hr class="section-divider">

        <section class="career-section">
          <h2>Parcours Club</h2>
          <div class="career-info-grid">
            <div class="info-item">
              <span class="item-label">Date d'Inscription</span>
              <span class="item-value">{{ player.dateInscription }}</span>
            </div>
            <div class="info-item">
              <span class="item-label">Date de Départ</span>
              <span class="item-value item-inactive">{{ player.dateQuitter || 'N/A (Actif)' }}</span>
            </div>
          </div>
          
          <div v-if="player.note" class="player-note">
            <span class="note-title">Notes du Coach :</span> {{ player.note }}
          </div>
        </section>

        <hr class="section-divider">

        <section class="contact-section">
          <h2>Contact et Administratif</h2>
          <div class="contact-grid">
            <div class="contact-item">
              <span class="contact-label">Email</span>
              <span class="contact-value">{{ player.email || 'N/A' }}</span>
            </div>
            <div class="contact-item">
              <span class="contact-label">Téléphone</span>
              <span class="contact-value">{{ player.telephone || 'N/A' }}</span>
            </div>
            <div class="contact-item">
              <span class="contact-label">Licence FFF</span>
              <span class="contact-value">{{ player.licence || 'En attente' }}</span>
            </div>
          </div>
        </section>

        </div>

    </div>
    <router-link :to="'/joueurs/update/'+player.id" >Edit</router-link>
  </div>
</template>

<script setup>
import { defineProps } from 'vue';

const props = defineProps({
  player: {
    type: Object,
    required: true,
    // On suppose que l'objet joueur a au moins les propriétés utilisées
  }
});

// Fonction pour gérer les erreurs d'image (cohérence visuelle)
const onImageError = (event) => {
  event.target.src = '/logo/logofotsy.jpg'; // Avatar par défaut
  event.target.classList.add('default-avatar');
};
</script>

<style scoped>
/* Couleurs primaires pour la cohérence */
:root {
  --primary-color: #2A88C8; /* Bleu */
  --secondary-color: #e74c3c; /* Rouge (pour le poste ou les alertes) */
  --text-color: #333;
  --light-gray: #f4f4f4;
}

.player-profile-container {
  font-family: 'InterTight', sans-serif;
  max-width: 900px;
  margin: 30px auto;
  padding: 0 20px;
}

.profile-card {
  background-color: white;
  border-radius: 15px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
  overflow: hidden;
}

/* --- EN-TÊTE --- */

.profile-header {
  background: linear-gradient(135deg, var(--primary-color) 0%, #3498db 100%);
  padding: 30px 40px;
  color: white;
  display: flex;
  align-items: center;
  gap: 30px;
  position: relative;
}

.photo-container {
  width: 150px;
  height: 180px;
  border-radius: 0%;
  border: 5px solid white;
  overflow: hidden;
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
  position: relative;
  flex-shrink: 0;
}

.profile-photo {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.player-number-badge {
  position: absolute;
  bottom: 0;
  right: 0;
  background-color: var(--secondary-color);
  color: white;
  font-size: 20px;
  font-weight: 900;
  padding: 5px 10px;
  border-radius: 50%;
  line-height: 1;
  border: 3px solid var(--primary-color);
}

.header-details {
  color: #333;
}

.player-full-name {
  font-size: 36px;
  font-weight: 500;
  margin-bottom: 5px;
  line-height: 1.1;
}

.last-name {
  font-weight: 800;
  text-transform: uppercase;
}

.player-poste-main {
  display: inline-block;
  background-color: white;
  color: var(--primary-color);
  padding: 5px 15px;
  border-radius: 6px;
  font-size: 16px;
  font-weight: bold;
  text-transform: uppercase;
  margin-bottom: 15px;
}

.bio-info-line {
  font-size: 16px;
  margin-top: 5px;
  display: flex;
  align-items: center;
  gap: 8px;
}

.info-icon {
  font-size: 18px;
}

/* --- CORPS DE LA FICHE --- */

.profile-body {
  padding: 30px 40px;
  color: var(--text-color);
}

.section-divider {
  border: 0;
  height: 1px;
  background: #eee;
  margin: 30px 0;
}

/* Sections */
.stat-section, .career-section, .contact-section {
  margin-bottom: 30px;
}

h2 {
  color: var(--primary-color);
  font-size: 22px;
  border-bottom: 2px solid var(--light-gray);
  padding-bottom: 5px;
  margin-bottom: 15px;
  font-weight: 700;
}

/* Grille de statistiques */
.stat-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
  gap: 20px;
}

.stat-item {
  background-color: var(--light-gray);
  padding: 15px;
  border-radius: 8px;
  text-align: center;
}

.stat-label {
  display: block;
  font-size: 14px;
  color: #7f8c8d;
  margin-bottom: 5px;
  text-transform: uppercase;
}

.stat-value {
  display: block;
  font-size: 24px;
  font-weight: 800;
  color: var(--text-color);
}

.status-actif {
    color: #27ae60; /* Vert pour Actif */
}

.status-inactif {
    color: #e74c3c; /* Vert pour Actif */
}

/* Grille d'infos Carrière/Contact */
.career-info-grid, .contact-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 20px;
}

.info-item, .contact-item {
    padding: 10px 0;
    border-left: 3px solid var(--primary-color);
    padding-left: 15px;
}

.item-label, .contact-label {
    display: block;
    font-size: 13px;
    color: #7f8c8d;
    text-transform: uppercase;
    margin-bottom: 3px;
}

.item-value, .contact-value {
    font-size: 16px;
    font-weight: 600;
    color: var(--text-color);
}

.item-inactive {
    color: var(--secondary-color); /* Rouge pour "N/A (Actif)" */
}

.player-note {
    background-color: #fffacd; /* Jaune pâle pour les notes */
    border-left: 4px solid #f1c40f;
    padding: 15px;
    border-radius: 5px;
    margin-top: 20px;
    font-style: italic;
    color: #555;
}

.note-title {
    font-weight: 700;
    color: #2c3e50;
    margin-right: 5px;
}

/* --- RESPONSIVE --- */
@media (max-width: 768px) {
  .profile-header {
    flex-direction: column;
    text-align: center;
  }

  .header-details {
    width: 100%;
    margin-top: 15px;
  }

  .photo-container {
    width: 120px;
    height: 120px;
  }

  .player-full-name {
    font-size: 30px;
  }
  
  .profile-body {
    padding: 20px;
  }

  .stat-grid, .career-info-grid, .contact-grid {
    grid-template-columns: 1fr;
  }
}
</style>