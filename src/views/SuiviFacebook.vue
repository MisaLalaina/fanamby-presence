<template>
  <div class="facebook-analytics-container">
    <!-- En-tête -->
    <div class="analytics-header">
      <h1>📊 Analyse des Publications Facebook</h1>
      <p>Suivez les performances de vos publications sur Facebook</p>
    </div>

    <!-- Filtres et contrôles -->
    <div class="controls-section">
      <div class="filter-group">
        <div class="filter-item">
          <label for="date-range">Période :</label>
          <select id="date-range" v-model="selectedDateRange" @change="fetchPosts">
            <option value="7">7 derniers jours</option>
            <option value="30">30 derniers jours</option>
            <option value="90">3 derniers mois</option>
            <option value="all">Toutes les publications</option>
          </select>
        </div>
        
        <div class="filter-item">
          <label for="post-type">Type de contenu :</label>
          <select id="post-type" v-model="selectedPostType" @change="filterPosts">
            <option value="all">Tous les types</option>
            <option value="photo">Photos</option>
            <option value="video">Vidéos</option>
            <option value="status">Statuts</option>
          </select>
        </div>
      </div>
      
      <div class="refresh-section">
        <button @click="fetchPosts" class="refresh-btn" :disabled="loading">
          <span v-if="loading" class="spinner">⟳</span>
          {{ loading ? 'Actualisation...' : 'Actualiser' }}
        </button>
        <span class="last-update">Dernière mise à jour : {{ lastUpdateTime }}</span>
      </div>
    </div>

    <!-- Statistiques globales -->
    <div class="stats-overview">
      <div class="stat-card">
        <div class="stat-icon">📝</div>
        <div class="stat-content">
          <div class="stat-value">{{ totalPosts }}</div>
          <div class="stat-label">Publications</div>
        </div>
      </div>
      
      <div class="stat-card">
        <div class="stat-icon">👁️</div>
        <div class="stat-content">
          <div class="stat-value">{{ formatNumber(totalReach) }}</div>
          <div class="stat-label">Portée totale</div>
        </div>
      </div>
      
      <div class="stat-card">
        <div class="stat-icon">❤️</div>
        <div class="stat-content">
          <div class="stat-value">{{ formatNumber(totalEngagements) }}</div>
          <div class="stat-label">Engagements</div>
        </div>
      </div>
      
      <div class="stat-card">
        <div class="stat-icon">📈</div>
        <div class="stat-content">
          <div class="stat-value">{{ engagementRate }}%</div>
          <div class="stat-label">Taux d'engagement</div>
        </div>
      </div>
    </div>

    <!-- Liste des publications -->
    <div class="posts-section">
      <h2>Publications récentes</h2>
      
      <div v-if="loading" class="loading-container">
        <div class="loading-spinner">⏳</div>
        <p>Chargement des publications...</p>
      </div>
      
      <div v-else-if="filteredPosts.length === 0" class="empty-state">
        <div class="empty-icon">📭</div>
        <h3>Aucune publication trouvée</h3>
        <p>Aucune publication ne correspond à vos critères de recherche.</p>
      </div>
      
      <div v-else class="posts-list">
        <div 
          v-for="post in filteredPosts" 
          :key="post.id" 
          class="post-card"
          :class="{ expanded: expandedPostId === post.id }"
        >
          <!-- En-tête de la publication -->
          <div class="post-header" @click="togglePostDetails(post.id)">
            <div class="post-type-indicator">
              <span v-if="post.type === 'photo'">📷</span>
              <span v-else-if="post.type === 'video'">🎥</span>
              <span v-else>📝</span>
            </div>
            
            <div class="post-info">
              <div class="post-message" :title="post.message">
                {{ truncateText(post.message, 80) }}
              </div>
              <div class="post-date">{{ formatDate(post.created_time) }}</div>
            </div>
            
            <div class="post-engagement">
              <div class="engagement-item">
                <span class="engagement-icon">👁️</span>
                <span class="engagement-count">{{ formatNumber(post.reach || 0) }}</span>
              </div>
              <div class="engagement-item">
                <span class="engagement-icon">❤️</span>
                <span class="engagement-count">{{ formatNumber(post.total_reactions || 0) }}</span>
              </div>
              <div class="engagement-item">
                <span class="engagement-icon">💬</span>
                <span class="engagement-count">{{ formatNumber(post.comments_count || 0) }}</span>
              </div>
              <div class="engagement-item">
                <span class="engagement-icon">🔄</span>
                <span class="engagement-count">{{ formatNumber(post.shares_count || 0) }}</span>
              </div>
            </div>
            
            <div class="expand-icon">
              {{ expandedPostId === post.id ? '▼' : '►' }}
            </div>
          </div>
          
          <!-- Détails étendus de la publication -->
          <div v-if="expandedPostId === post.id" class="post-details">
            <!-- Message complet -->
            <div v-if="post.message" class="full-message">
              <h4>Message :</h4>
              <p>{{ post.message }}</p>
            </div>
            
            <!-- Média -->
            <div v-if="post.media_url" class="post-media">
              <h4>Média :</h4>
              <img 
                v-if="post.type === 'photo'" 
                :src="post.media_url" 
                :alt="post.message || 'Image de la publication'"
                class="media-preview"
                @click="openMediaModal(post.media_url)"
              />
              <video 
                v-else-if="post.type === 'video'" 
                :src="post.media_url" 
                controls
                class="media-preview"
              ></video>
            </div>
            
            <!-- Statistiques détaillées -->
            <div class="detailed-stats">
              <h4>Statistiques détaillées :</h4>
              <div class="stats-grid">
                <div class="stat-detail">
                  <div class="stat-detail-value">{{ formatNumber(post.reach || 0) }}</div>
                  <div class="stat-detail-label">Portée</div>
                </div>
                <div class="stat-detail">
                  <div class="stat-detail-value">{{ formatNumber(post.impressions || 0) }}</div>
                  <div class="stat-detail-label">Impressions</div>
                </div>
                <div class="stat-detail">
                  <div class="stat-detail-value">{{ formatNumber(post.engaged_users || 0) }}</div>
                  <div class="stat-detail-label">Personnes engagées</div>
                </div>
                <div class="stat-detail">
                  <div class="stat-detail-value">{{ post.engagement_rate || 0 }}%</div>
                  <div class="stat-detail-label">Taux d'engagement</div>
                </div>
              </div>
            </div>
            
            <!-- Réactions détaillées -->
            <div class="reactions-breakdown">
              <h4>Réactions :</h4>
              <div class="reactions-list">
                <div class="reaction-item">
                  <span class="reaction-emoji">❤️</span>
                  <span class="reaction-count">{{ formatNumber(post.reactions_like || 0) }}</span>
                </div>
                <div class="reaction-item">
                  <span class="reaction-emoji">😍</span>
                  <span class="reaction-count">{{ formatNumber(post.reactions_love || 0) }}</span>
                </div>
                <div class="reaction-item">
                  <span class="reaction-emoji">😂</span>
                  <span class="reaction-count">{{ formatNumber(post.reactions_haha || 0) }}</span>
                </div>
                <div class="reaction-item">
                  <span class="reaction-emoji">😮</span>
                  <span class="reaction-count">{{ formatNumber(post.reactions_wow || 0) }}</span>
                </div>
                <div class="reaction-item">
                  <span class="reaction-emoji">😢</span>
                  <span class="reaction-count">{{ formatNumber(post.reactions_sad || 0) }}</span>
                </div>
                <div class="reaction-item">
                  <span class="reaction-emoji">😠</span>
                  <span class="reaction-count">{{ formatNumber(post.reactions_angry || 0) }}</span>
                </div>
              </div>
            </div>
            
            <!-- Commentaires récents -->
            <div v-if="post.comments && post.comments.length > 0" class="recent-comments">
              <h4>Commentaires récents :</h4>
              <div class="comments-list">
                <div 
                  v-for="comment in post.comments.slice(0, 3)" 
                  :key="comment.id" 
                  class="comment-item"
                >
                  <div class="comment-author">{{ comment.from?.name || 'Utilisateur' }}</div>
                  <div class="comment-message">{{ comment.message }}</div>
                  <div class="comment-date">{{ formatDate(comment.created_time) }}</div>
                </div>
                <div v-if="post.comments_count > 3" class="more-comments">
                  + {{ post.comments_count - 3 }} autres commentaires
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Modal pour afficher l'image en grand -->
    <div v-if="showMediaModal" class="modal-overlay" @click="closeMediaModal">
      <div class="modal-content" @click.stop>
        <button class="modal-close" @click="closeMediaModal">×</button>
        <img :src="modalImageUrl" alt="Image de la publication" class="modal-image" />
      </div>
    </div>
  </div>
</template>

<script>
import { ref, computed, onMounted } from 'vue'

export default {
  name: 'FacebookAnalytics',
  setup() {
    // Variables réactives
    const posts = ref([])
    const loading = ref(false)
    const selectedDateRange = ref('7')
    const selectedPostType = ref('all')
    const expandedPostId = ref(null)
    const showMediaModal = ref(false)
    const modalImageUrl = ref('')
    const lastUpdateTime = ref('')

    // Configuration Facebook
    const FB_PAGE_ID = import.meta.env.VITE_FB_PAGE_ID
    const FB_TOKEN = import.meta.env.VITE_FB_TOKEN
    const BASE_URL = import.meta.env.VITE_FB_GRAPH_URL || 'https://graph.facebook.com/v18.0'

    // Fonction pour récupérer les publications
    const fetchPosts = async () => {
      loading.value = true
      
      try {
        // Calculer la date de début en fonction de la période sélectionnée
        let sinceDate = ''
        if (selectedDateRange.value !== 'all') {
          const days = parseInt(selectedDateRange.value)
          const date = new Date()
          date.setDate(date.getDate() - days)
          sinceDate = `&since=${Math.floor(date.getTime() / 1000)}`
        }
        
        // Récupérer les posts avec leurs statistiques de base
        const postsResponse = await fetch(
          `${BASE_URL}/${FB_PAGE_ID}/posts?` +
          `fields=id,message,created_time,full_picture,attachments{media,subattachments},` +
          `reactions.type(LIKE).limit(0).summary(total_count).as(reactions_like),` +
          `reactions.type(LOVE).limit(0).summary(total_count).as(reactions_love),` +
          `reactions.type(HAHA).limit(0).summary(total_count).as(reactions_haha),` +
          `reactions.type(WOW).limit(0).summary(total_count).as(reactions_wow),` +
          `reactions.type(SAD).limit(0).summary(total_count).as(reactions_sad),` +
          `reactions.type(ANGRY).limit(0).summary(total_count).as(reactions_angry),` +
          `comments.limit(5){from,message,created_time},shares,` +
          `insights.metric(post_impressions,post_impressions_unique,post_engaged_users,post_engagement_rate)` +
          `${sinceDate}&access_token=${FB_TOKEN}`
        )
        
        const postsData = await postsResponse.json()
        
        if (postsData.error) {
          console.error('Erreur Facebook:', postsData.error)
          throw new Error(postsData.error.message)
        }
        
        // Traiter les données des posts
        posts.value = await Promise.all(
          postsData.data.map(async (post) => {
            // Déterminer le type de post
            let postType = 'status'
            let mediaUrl = post.full_picture || null
            
            if (post.attachments && post.attachments.data.length > 0) {
              const attachment = post.attachments.data[0]
              if (attachment.media && attachment.media.image) {
                postType = 'photo'
                mediaUrl = attachment.media.image.src
              } else if (attachment.subattachments) {
                postType = 'photo'
                mediaUrl = attachment.subattachments.data[0].media.image.src
              } else if (attachment.type === 'video') {
                postType = 'video'
                mediaUrl = attachment.media.source
              }
            }
            
            // Calculer les totaux
            const totalReactions = 
              (post.reactions_like?.summary?.total_count || 0) +
              (post.reactions_love?.summary?.total_count || 0) +
              (post.reactions_haha?.summary?.total_count || 0) +
              (post.reactions_wow?.summary?.total_count || 0) +
              (post.reactions_sad?.summary?.total_count || 0) +
              (post.reactions_angry?.summary?.total_count || 0)
            
            // Extraire les insights
            let reach = 0
            let impressions = 0
            let engagedUsers = 0
            let engagementRate = 0
            
            if (post.insights && post.insights.data.length > 0) {
              post.insights.data.forEach(insight => {
                if (insight.name === 'post_impressions_unique') {
                  reach = insight.values[0].value
                } else if (insight.name === 'post_impressions') {
                  impressions = insight.values[0].value
                } else if (insight.name === 'post_engaged_users') {
                  engagedUsers = insight.values[0].value
                } else if (insight.name === 'post_engagement_rate') {
                  engagementRate = insight.values[0].value
                }
              })
            }
            
            return {
              id: post.id,
              message: post.message || '',
              created_time: post.created_time,
              type: postType,
              media_url: mediaUrl,
              reach: reach,
              impressions: impressions,
              engaged_users: engagedUsers,
              engagement_rate: engagementRate,
              total_reactions: totalReactions,
              reactions_like: post.reactions_like?.summary?.total_count || 0,
              reactions_love: post.reactions_love?.summary?.total_count || 0,
              reactions_haha: post.reactions_haha?.summary?.total_count || 0,
              reactions_wow: post.reactions_wow?.summary?.total_count || 0,
              reactions_sad: post.reactions_sad?.summary?.total_count || 0,
              reactions_angry: post.reactions_angry?.summary?.total_count || 0,
              comments_count: post.comments?.data?.length || 0,
              comments: post.comments?.data || [],
              shares_count: post.shares?.count || 0
            }
          })
        )
        
        // Mettre à jour l'heure de dernière mise à jour
        lastUpdateTime.value = new Date().toLocaleTimeString('fr-FR')
        
      } catch (error) {
        console.error('Erreur lors de la récupération des publications:', error)
        alert(`Erreur: ${error.message}`)
      } finally {
        loading.value = false
      }
    }

    // Filtrer les posts par type
    const filteredPosts = computed(() => {
      if (selectedPostType.value === 'all') {
        return posts.value
      }
      return posts.value.filter(post => post.type === selectedPostType.value)
    })

    // Calculer les statistiques globales
    const totalPosts = computed(() => filteredPosts.value.length)
    
    const totalReach = computed(() => 
      filteredPosts.value.reduce((sum, post) => sum + (post.reach || 0), 0)
    )
    
    const totalEngagements = computed(() => 
      filteredPosts.value.reduce((sum, post) => 
        sum + (post.total_reactions || 0) + (post.comments_count || 0) + (post.shares_count || 0), 0)
    )
    
    const engagementRate = computed(() => {
      if (totalReach.value === 0) return 0
      return ((totalEngagements.value / totalReach.value) * 100).toFixed(2)
    })

    // Fonctions utilitaires
    const formatNumber = (num) => {
      if (num >= 1000000) {
        return (num / 1000000).toFixed(1) + 'M'
      } else if (num >= 1000) {
        return (num / 1000).toFixed(1) + 'k'
      }
      return num.toString()
    }

    const formatDate = (dateString) => {
      const date = new Date(dateString)
      return date.toLocaleDateString('fr-FR', {
        day: 'numeric',
        month: 'short',
        year: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
      })
    }

    const truncateText = (text, maxLength) => {
      if (!text) return 'Aucun message'
      if (text.length <= maxLength) return text
      return text.substring(0, maxLength) + '...'
    }

    const togglePostDetails = (postId) => {
      expandedPostId.value = expandedPostId.value === postId ? null : postId
    }

    const openMediaModal = (imageUrl) => {
      modalImageUrl.value = imageUrl
      showMediaModal.value = true
    }

    const closeMediaModal = () => {
      showMediaModal.value = false
      modalImageUrl.value = ''
    }

    // Charger les données au montage du composant
    onMounted(() => {
      fetchPosts()
    })

    return {
      // Data
      posts,
      loading,
      selectedDateRange,
      selectedPostType,
      expandedPostId,
      showMediaModal,
      modalImageUrl,
      lastUpdateTime,
      
      // Computed
      filteredPosts,
      totalPosts,
      totalReach,
      totalEngagements,
      engagementRate,
      
      // Methods
      fetchPosts,
      filterPosts: () => {}, // Utilisé uniquement pour l'événement @change
      formatNumber,
      formatDate,
      truncateText,
      togglePostDetails,
      openMediaModal,
      closeMediaModal
    }
  }
}
</script>

<style scoped>
.facebook-analytics-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 2rem;
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  color: #333;
}

.analytics-header {
  text-align: center;
  margin-bottom: 2rem;
}

.analytics-header h1 {
  font-size: 2.5rem;
  margin-bottom: 0.5rem;
  color: #1877f2;
}

.analytics-header p {
  font-size: 1.1rem;
  color: #666;
}

/* Section des contrôles */
.controls-section {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 2rem;
  padding: 1.5rem;
  background: #f7f9fc;
  border-radius: 12px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
}

.filter-group {
  display: flex;
  gap: 1.5rem;
}

.filter-item {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.filter-item label {
  font-weight: 600;
  color: #555;
  font-size: 0.9rem;
}

.filter-item select {
  padding: 0.5rem 1rem;
  border: 1px solid #ddd;
  border-radius: 8px;
  background: white;
  font-size: 1rem;
  cursor: pointer;
  transition: border-color 0.3s;
}

.filter-item select:focus {
  outline: none;
  border-color: #1877f2;
}

.refresh-section {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  gap: 0.5rem;
}

.refresh-btn {
  padding: 0.5rem 1.5rem;
  background: #1877f2;
  color: white;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  font-weight: 600;
  transition: background 0.3s;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.refresh-btn:hover:not(:disabled) {
  background: #166fe5;
}

.refresh-btn:disabled {
  background: #bdc3c7;
  cursor: not-allowed;
}

.spinner {
  animation: spin 1s linear infinite;
}

@keyframes spin {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

.last-update {
  font-size: 0.85rem;
  color: #777;
}

/* Statistiques globales */
.stats-overview {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1.5rem;
  margin-bottom: 2rem;
}

.stat-card {
  display: flex;
  align-items: center;
  padding: 1.5rem;
  background: white;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  transition: transform 0.3s;
}

.stat-card:hover {
  transform: translateY(-5px);
}

.stat-icon {
  font-size: 2.5rem;
  margin-right: 1rem;
}

.stat-content {
  display: flex;
  flex-direction: column;
}

.stat-value {
  font-size: 2rem;
  font-weight: 700;
  color: #1877f2;
}

.stat-label {
  font-size: 0.9rem;
  color: #666;
  margin-top: 0.25rem;
}

/* Section des publications */
.posts-section h2 {
  margin-bottom: 1.5rem;
  color: #333;
  font-size: 1.8rem;
}

.loading-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 3rem;
  color: #666;
}

.loading-spinner {
  font-size: 3rem;
  margin-bottom: 1rem;
  animation: spin 2s linear infinite;
}

.empty-state {
  text-align: center;
  padding: 3rem;
  color: #666;
}

.empty-icon {
  font-size: 4rem;
  margin-bottom: 1rem;
}

.empty-state h3 {
  margin-bottom: 0.5rem;
  color: #555;
}

/* Liste des publications */
.posts-list {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.post-card {
  background: white;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  overflow: hidden;
  transition: box-shadow 0.3s;
}

.post-card:hover {
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.12);
}

.post-card.expanded {
  box-shadow: 0 6px 20px rgba(0, 0, 0, 0.15);
}

.post-header {
  display: flex;
  align-items: center;
  padding: 1.5rem;
  cursor: pointer;
  transition: background 0.2s;
}

.post-header:hover {
  background: #f8f9fa;
}

.post-type-indicator {
  font-size: 1.5rem;
  margin-right: 1rem;
}

.post-info {
  flex: 1;
  margin-right: 1rem;
}

.post-message {
  font-weight: 500;
  margin-bottom: 0.5rem;
  line-height: 1.4;
}

.post-date {
  font-size: 0.85rem;
  color: #777;
}

.post-engagement {
  display: flex;
  gap: 1.5rem;
  margin-right: 1rem;
}

.engagement-item {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.engagement-icon {
  font-size: 1.2rem;
}

.engagement-count {
  font-weight: 600;
  color: #555;
}

.expand-icon {
  font-size: 1.2rem;
  color: #777;
  transition: transform 0.3s;
}

.post-card.expanded .expand-icon {
  transform: rotate(180deg);
}

/* Détails de la publication */
.post-details {
  padding: 1.5rem;
  border-top: 1px solid #eee;
  background: #fafbfc;
}

.full-message, .post-media, .detailed-stats, .reactions-breakdown, .recent-comments {
  margin-bottom: 1.5rem;
}

.full-message h4, .post-media h4, .detailed-stats h4, .reactions-breakdown h4, .recent-comments h4 {
  margin-bottom: 0.75rem;
  color: #444;
  font-size: 1.1rem;
}

.full-message p {
  line-height: 1.5;
  color: #555;
}

.media-preview {
  max-width: 100%;
  max-height: 300px;
  border-radius: 8px;
  cursor: pointer;
  transition: transform 0.3s;
}

.media-preview:hover {
  transform: scale(1.02);
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
  gap: 1rem;
}

.stat-detail {
  text-align: center;
  padding: 1rem;
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
}

.stat-detail-value {
  font-size: 1.5rem;
  font-weight: 700;
  color: #1877f2;
  margin-bottom: 0.25rem;
}

.stat-detail-label {
  font-size: 0.85rem;
  color: #666;
}

.reactions-list {
  display: flex;
  flex-wrap: wrap;
  gap: 1rem;
}

.reaction-item {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.5rem 1rem;
  background: white;
  border-radius: 20px;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.05);
}

.reaction-emoji {
  font-size: 1.2rem;
}

.reaction-count {
  font-weight: 600;
  color: #555;
}

.comments-list {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.comment-item {
  padding: 1rem;
  background: white;
  border-radius: 8px;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.05);
}

.comment-author {
  font-weight: 600;
  margin-bottom: 0.5rem;
  color: #1877f2;
}

.comment-message {
  line-height: 1.4;
  margin-bottom: 0.5rem;
}

.comment-date {
  font-size: 0.8rem;
  color: #777;
}

.more-comments {
  text-align: center;
  padding: 0.75rem;
  color: #1877f2;
  font-weight: 500;
  cursor: pointer;
}

.more-comments:hover {
  text-decoration: underline;
}

/* Modal */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.8);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.modal-content {
  position: relative;
  max-width: 90%;
  max-height: 90%;
}

.modal-close {
  position: absolute;
  top: -40px;
  right: 0;
  background: none;
  border: none;
  color: white;
  font-size: 2rem;
  cursor: pointer;
  width: 40px;
  height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.modal-image {
  max-width: 100%;
  max-height: 80vh;
  border-radius: 8px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
}

/* Responsive */
@media (max-width: 768px) {
  .facebook-analytics-container {
    padding: 1rem;
  }
  
  .controls-section {
    flex-direction: column;
    gap: 1rem;
    align-items: stretch;
  }
  
  .filter-group {
    flex-direction: column;
    gap: 1rem;
  }
  
  .refresh-section {
    align-items: center;
  }
  
  .stats-overview {
    grid-template-columns: 1fr 1fr;
  }
  
  .post-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 1rem;
  }
  
  .post-engagement {
    width: 100%;
    justify-content: space-between;
  }
  
  .engagement-item {
    flex-direction: column;
    gap: 0.25rem;
    text-align: center;
  }
}
</style>