<template>
    <div class="post-details">
      <div class="detail-section">
        <h4>Contenu</h4>
        <p class="post-message">{{ post.message || 'Aucun texte' }}</p>
      </div>
      
      <div class="detail-section">
        <h4>Statistiques détaillées</h4>
        <div v-if="post.stats" class="detailed-stats">
          <div class="stat-row">
            <span>Portée :</span>
            <strong>{{ post.stats.impressions || 0 }}</strong>
          </div>
          <div class="stat-row">
            <span>Utilisateurs engagés :</span>
            <strong>{{ post.stats.engaged_users || 0 }}</strong>
          </div>
          <div class="stat-row">
            <span>Taux d'engagement :</span>
            <strong>{{ post.stats.engagement_rate || 0 }}%</strong>
          </div>
        </div>
        <p v-else class="no-stats">Aucune statistique disponible</p>
      </div>
      
      <div class="detail-actions">
        <button class="btn-primary" @click="$emit('view-on-facebook')">
          👁️ Voir sur Facebook
        </button>
      </div>
    </div>
</template>

<script setup>


</script>