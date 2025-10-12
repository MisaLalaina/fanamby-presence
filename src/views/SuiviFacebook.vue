<template>
  <div class="posts-container">
    <div class="header">
      <h1>Mes Publications Facebook</h1>
      <p>Gérez et visualisez toutes vos publications</p>
    </div>

    <!-- Contrôles et filtres -->
    <div class="controls">
      <div class="filters">
        <div class="filter-group">
          <label>Type de publication :</label>
          <select v-model="filters.type" @change="applyFilters">
            <option value="all">Tous les types</option>
            <option value="photo">Photos</option>
            <option value="video">Vidéos</option>
            <option value="status">Statuts</option>
          </select>
        </div>

        <div class="filter-group">
          <label>Tri par :</label>
          <select v-model="sortBy" @change="applySorting">
            <option value="created_time">Date de publication</option>
            <option value="engagement">Taux d'engagement</option>
            <option value="reactions">Réactions</option>
            <option value="comments">Commentaires</option>
          </select>
        </div>

        <div class="filter-group">
          <label>Nombre :</label>
          <select v-model="postsLimit" @change="fetchPosts">
            <option value="10">10 publications</option>
            <option value="25">25 publications</option>
            <option value="50">50 publications</option>
            <option value="100">100 publications</option>
          </select>
        </div>
      </div>

      <div class="actions">
        <button class="refresh-btn" @click="fetchPosts" :disabled="loading">
          {{ loading ? 'Chargement...' : 'Actualiser' }}
        </button>
        <button class="new-post-btn" @click="createNewPost">
          ➕ Nouvelle publication
        </button>
      </div>
    </div>

    <!-- Statistiques rapides -->
    <div class="quick-stats">
      <div class="stat-item">
        <div class="stat-number">{{ totalPosts }}</div>
        <div class="stat-label">Publications totales</div>
      </div>
      <div class="stat-item">
        <div class="stat-number">{{ formatNumber(totalReactions) }}</div>
        <div class="stat-label">Réactions totales</div>
      </div>
      <div class="stat-item">
        <div class="stat-number">{{ formatNumber(totalComments) }}</div>
        <div class="stat-label">Commentaires</div>
      </div>
      <div class="stat-item">
        <div class="stat-number">{{ formatNumber(totalShares) }}</div>
        <div class="stat-label">Partages</div>
      </div>
    </div>

    <!-- Liste des publications -->
    <div class="posts-list">
      <div v-if="loading" class="loading-state">
        <div class="spinner">⏳</div>
        <p>Chargement de vos publications...</p>
      </div>

      <div v-else-if="error" class="error-state">
        <div class="error-icon">❌</div>
        <h3>Erreur lors du chargement</h3>
        <p>{{ error }}</p>
        <button class="retry-btn" @click="fetchPosts">Réessayer</button>
      </div>

      <div v-else-if="filteredPosts.length === 0" class="empty-state">
        <div class="empty-icon">📭</div>
        <h3>Aucune publication trouvée</h3>
        <p>Aucune publication ne correspond à vos critères de recherche.</p>
        <button class="new-post-btn" @click="createNewPost">
          Créer votre première publication
        </button>
      </div>

      <div v-else class="posts-grid">
        <div 
          v-for="post in filteredPosts" 
          :key="post.id" 
          class="post-card"
          :class="getPostTypeClass(post.media_type)"
        >
          <!-- En-tête de la publication -->
          <div class="post-header">
            <div class="post-type">
              <span class="type-icon">{{ getTypeIcon(post.media_type) }}</span>
              <span class="type-label">{{ getTypeLabel(post.media_type) }}</span>
            </div>
            <div class="post-date">
              {{ formatDate(post.created_time) }}
            </div>
          </div>

          <!-- Contenu de la publication -->
          <div class="post-content">
            <!-- Média -->
            <div v-if="post.media_type !== 'text'" class="post-media">
              <img 
                v-if="post.media_type === 'photo'" 
                :src="getMediaUrl(post)" 
                :alt="post.message"
                @error="handleImageError"
              />
              <div v-else-if="post.media_type === 'video'" class="video-placeholder">
                <span class="video-icon">🎥</span>
                <p>Vidéo</p>
              </div>
              <div v-else-if="post.media_type === 'album'" class="album-placeholder">
                <span class="album-icon">🖼️</span>
                <p>Album photo</p>
              </div>
            </div>

            <!-- Texte -->
            <div class="post-text" :class="{ 'has-media': post.media_type !== 'text' }">
              <p>{{ truncateText(post.message, 150) || 'Publication sans texte' }}</p>
            </div>
          </div>

          <!-- Statistiques -->
          <div class="post-stats">
            <div class="stat">
              <span class="stat-icon"></span>
              <span class="stat-value">{{ formatNumber(getTotalReactions(post)) }}</span>
            </div>
            <div class="stat">
              <span class="stat-icon"></span>
              <span class="stat-value">{{ formatNumber(post.stats?.comments || 0) }}</span>
            </div>
            <div class="stat">
              <span class="stat-icon"></span>
              <span class="stat-value">{{ formatNumber(post.stats?.shares || 0) }}</span>
            </div>
          </div>

          <!-- Actions -->
          <div class="post-actions">
            <button 
              class="action-btn view-btn"
              @click="viewOnFacebook(post.permalink_url)"
              title="Voir sur Facebook"
            >
              👁️ Voir
            </button>
            <button 
              class="action-btn stats-btn"
              @click="showPostDetails(post)"
              title="Voir les détails"
            >
              📊 Détails
            </button>
            <button 
              class="action-btn delete-btn"
              @click="confirmDeletePost(post)"
              title="Supprimer"
              v-if="false"
            >
              🗑️
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Chargement plus -->
    <div v-if="hasMorePosts && !loading" class="load-more">
      <button class="load-more-btn" @click="loadMorePosts">
        📥 Charger plus de publications
      </button>
    </div>

  </div>
</template>

<script>
import { ref, computed, onMounted } from 'vue'
import { getAllPostsWithStats, getPagePosts } from '@/services/facebookService'

export default {
  name: 'FacebookPostsList',
  setup() {
    // États réactifs
    const posts = ref([])
    const loading = ref(false)
    const error = ref(null)
    const selectedPost = ref(null)
    const postsLimit = ref(25)
    const hasMorePosts = ref(false)

    // Filtres et tri
    const filters = ref({
      type: 'all'
    })
    const sortBy = ref('created_time')

    // Computed properties
    const filteredPosts = computed(() => {
      let filtered = [...posts.value]

      // Filtrage par type
      if (filters.value.type !== 'all') {
        filtered = filtered.filter(post => post.media_type === filters.value.type)
      }

      // Tri
      filtered.sort((a, b) => {
        switch (sortBy.value) {
          case 'engagement':
            const aEngagement = a.stats?.engagement_rate || 0
            const bEngagement = b.stats?.engagement_rate || 0
            return bEngagement - aEngagement

          case 'reactions':
            const aReactions = getTotalReactions(a)
            const bReactions = getTotalReactions(b)
            return bReactions - aReactions

          case 'comments':
            const aComments = a.stats?.comments || 0
            const bComments = b.stats?.comments || 0
            return bComments - aComments

          case 'created_time':
          default:
            return new Date(b.created_time) - new Date(a.created_time)
        }
      })

      return filtered
    })

    const totalPosts = computed(() => filteredPosts.value.length)
    const totalReactions = computed(() => 
      filteredPosts.value.reduce((sum, post) => sum + getTotalReactions(post), 0)
    )
    const totalComments = computed(() => 
      filteredPosts.value.reduce((sum, post) => sum + (post.stats?.comments || 0), 0)
    )
    const totalShares = computed(() => 
      filteredPosts.value.reduce((sum, post) => sum + (post.stats?.shares || 0), 0)
    )

    // Méthodes
    const fetchPosts = async () => {
      loading.value = true
      error.value = null
      
      try {
        // Essayer d'abord la méthode complète
        const response = await getAllPostsWithStats(postsLimit.value)
        posts.value = response.data
        hasMorePosts.value = !!response.paging?.next
        
        console.log('Publications chargées avec stats:', posts.value.length)
        console.log('Publications :', posts.value)
      } catch (err) {
        console.error('Erreur avec la méthode complète, tentative avec méthode simple:', err)
        
        // Fallback vers la méthode simple
        try {
          const simpleResponse = await getSimplePosts(postsLimit.value)
          posts.value = simpleResponse.data.map(post => ({
            ...post,
            stats: null // Pas de stats disponibles
          }))
          hasMorePosts.value = !!simpleResponse.paging?.next
          
          console.log('Publications chargées (sans stats):', posts.value.length)
          error.value = 'Statistiques non disponibles, mais publications chargées'
        } catch (simpleErr) {
          console.error('Erreur même avec méthode simple:', simpleErr)
          error.value = simpleErr.message || 'Erreur lors du chargement des publications'
          
          // Données de démonstration en dernier recours
          posts.value = generateDemoPosts()
        }
      } finally {
        loading.value = false
      }
    }

    const loadMorePosts = async () => {
      // Implémentation pour charger plus de posts
      console.log('Chargement de publications supplémentaires...')
    }

    const applyFilters = () => {
      // Les computed properties se mettent à jour automatiquement
    }

    const applySorting = () => {
      // Les computed properties se mettent à jour automatiquement
    }

    const getTotalReactions = (post) => {
      if (!post.stats) return 0
      
      if (post.stats.reactions_breakdown) {
        return Object.values(post.stats.reactions_breakdown).reduce((sum, count) => sum + count, 0)
      }
      
      return post.stats.total_reactions || 0
    }

    const getMediaUrl = (post) => {
      if (post.attachments?.data?.[0]?.media?.image?.src) {
        return post.attachments.data[0].media.image.src
      }
      return '/placeholder-image.jpg'
    }

    const handleImageError = (event) => {
      event.target.src = '/placeholder-image.jpg'
    }

    const viewOnFacebook = (url) => {
      if (url) {
        window.open(url, '_blank')
      } else {
        alert('URL non disponible pour cette publication')
      }
    }

    const showPostDetails = (post) => {
      selectedPost.value = post
    }

    const createNewPost = () => {
      // Rediriger vers le composant de création de publication
      // ou ouvrir un modal de création
      alert('Fonctionnalité de création de publication à implémenter')
    }

    const confirmDeletePost = (post) => {
      if (confirm(`Êtes-vous sûr de vouloir supprimer cette publication ?`)) {
        deletePost(post.id)
      }
    }

    const deletePost = async (postId) => {
      try {
        // Implémentation de la suppression
        console.log('Suppression de la publication:', postId)
      } catch (err) {
        console.error('Erreur lors de la suppression:', err)
        alert('Erreur lors de la suppression de la publication')
      }
    }

    // Utilitaires
    const formatNumber = (num) => {
      if (num >= 1000000) {
        return (num / 1000000).toFixed(1) + 'M'
      } else if (num >= 1000) {
        return (num / 1000).toFixed(1) + 'K'
      }
      return num.toString()
    }

    const formatDate = (dateString) => {
      return new Date(dateString).toLocaleDateString('fr-FR', {
        year: 'numeric',
        month: 'short',
        day: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
      })
    }

    const truncateText = (text, length) => {
      if (!text) return ''
      return text.length > length ? text.substring(0, length) + '...' : text
    }

    const getTypeIcon = (type) => {
      const icons = {
        photo: '📷',
        video: '🎥',
        album: '🖼️',
        text: '📝'
      }
      return icons[type] || '📝'
    }

    const getTypeLabel = (type) => {
      const labels = {
        photo: 'Photo',
        video: 'Vidéo',
        album: 'Album',
        text: 'Statut'
      }
      return labels[type] || 'Publication'
    }

    const getPostTypeClass = (type) => {
      return `post-type-${type}`
    }

    // Données de démonstration
    const generateDemoPosts = () => {
      const types = ['photo', 'video', 'text', 'album']
      const demoPosts = []
      
      for (let i = 0; i < 15; i++) {
        const type = types[Math.floor(Math.random() * types.length)]
        const hasStats = Math.random() > 0.2 // 80% ont des stats
        
        demoPosts.push({
          id: `demo_${i}`,
          message: `Ceci est une publication de démonstration ${i + 1}. Elle montre comment le contenu sera affiché dans la liste.`,
          created_time: new Date(Date.now() - Math.random() * 30 * 24 * 60 * 60 * 1000).toISOString(),
          permalink_url: `https://facebook.com/demo_post_${i}`,
          media_type: type,
          attachments: type !== 'text' ? {
            data: [{
              media: {
                image: {
                  src: `https://picsum.photos/400/300?random=${i}`
                }
              }
            }]
          } : null,
          stats: hasStats ? {
            impressions: Math.floor(Math.random() * 5000),
            comments: Math.floor(Math.random() * 50),
            shares: Math.floor(Math.random() * 20),
            engagement_rate: (Math.random() * 15).toFixed(1),
            reactions_breakdown: {
              like: Math.floor(Math.random() * 100),
              love: Math.floor(Math.random() * 20),
              wow: Math.floor(Math.random() * 10),
              haha: Math.floor(Math.random() * 15),
              sorry: Math.floor(Math.random() * 5),
              anger: Math.floor(Math.random() * 3)
            }
          } : null
        })
      }
      
      return demoPosts
    }

    // Lifecycle
    onMounted(() => {
      fetchPosts()
    })

    return {
      // Data
      filteredPosts,
      loading,
      error,
      selectedPost,
      filters,
      sortBy,
      postsLimit,
      hasMorePosts,
      
      // Computed
      totalPosts,
      totalReactions,
      totalComments,
      totalShares,
      
      // Methods
      fetchPosts,
      loadMorePosts,
      applyFilters,
      applySorting,
      getTotalReactions,
      getMediaUrl,
      handleImageError,
      viewOnFacebook,
      showPostDetails,
      createNewPost,
      confirmDeletePost,
      
      // Utils
      formatNumber,
      formatDate,
      truncateText,
      getTypeIcon,
      getTypeLabel,
      getPostTypeClass
    }
  }
}

// Composant pour les détails de publication (simplifié)
const PostDetails = {
  props: ['post'],
  template: `
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
  `
}
</script>

<style scoped>
.posts-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 2rem;
  background: #f8f9fa;
  min-height: 100vh;
}

.header {
  text-align: center;
  margin-bottom: 2rem;
}

.header h1 {
  color: #1877f2;
  margin-bottom: 0.5rem;
  font-size: 2.5rem;
}

.header p {
  color: #65676b;
  font-size: 1.1rem;
}

.controls {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 2rem;
  background: white;
  padding: 1.5rem;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
}

.filters {
  display: flex;
  gap: 2rem;
  align-items: center;
}

.filter-group {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.filter-group label {
  font-weight: 600;
  color: #555;
  font-size: 0.9rem;
}

.filter-group select {
  padding: 0.5rem 1rem;
  border: 1px solid #ddd;
  border-radius: 8px;
  background: white;
  cursor: pointer;
}

.actions {
  display: flex;
  gap: 1rem;
}

.refresh-btn, .new-post-btn {
  padding: 0.75rem 1.5rem;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  font-weight: 600;
  transition: all 0.3s;
}

.refresh-btn {
  background: #1877f2;
  color: white;
}

.refresh-btn:hover:not(:disabled) {
  background: #166fe5;
}

.refresh-btn:disabled {
  background: #bdc3c7;
  cursor: not-allowed;
}

.new-post-btn {
  background: #42b883;
  color: white;
}

.new-post-btn:hover {
  background: #3aa876;
}

.quick-stats {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1rem;
  margin-bottom: 2rem;
}

.stat-item {
  background: white;
  padding: 1.5rem;
  border-radius: 12px;
  text-align: center;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
}

.stat-number {
  font-size: 2rem;
  font-weight: 700;
  color: #1877f2;
  margin-bottom: 0.5rem;
}

.stat-label {
  color: #65676b;
  font-size: 0.9rem;
}

.loading-state, .error-state, .empty-state {
  text-align: center;
  padding: 4rem 2rem;
  background: white;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
}

.spinner, .error-icon, .empty-icon {
  font-size: 3rem;
  margin-bottom: 1rem;
}

.spinner {
  animation: spin 1s linear infinite;
}

@keyframes spin {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

.retry-btn {
  background: #1877f2;
  color: white;
  border: none;
  padding: 0.75rem 1.5rem;
  border-radius: 8px;
  cursor: pointer;
  margin-top: 1rem;
}

.posts-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
  gap: 1.5rem;
  margin-bottom: 2rem;
}

.post-card {
  background: white;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
  overflow: hidden;
  transition: transform 0.3s, box-shadow 0.3s;
}

.post-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 4px 16px rgba(0,0,0,0.15);
}

.post-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem 1.5rem;
  border-bottom: 1px solid #f0f0f0;
}

.post-type {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.type-icon {
  font-size: 1.2rem;
}

.type-label {
  font-weight: 600;
  color: #555;
}

.post-date {
  color: #666;
  font-size: 0.85rem;
}

.post-content {
  padding: 1.5rem;
}

.post-media {
  margin-bottom: 1rem;
  border-radius: 8px;
  overflow: hidden;
}

.post-media img {
  width: 100%;
  height: 200px;
  object-fit: cover;
}

.video-placeholder, .album-placeholder {
  height: 200px;
  background: #f8f9fa;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  color: #666;
  border: 2px dashed #ddd;
}

.video-icon, .album-icon {
  font-size: 2rem;
  margin-bottom: 0.5rem;
}

.post-text p {
  margin: 0;
  line-height: 1.5;
  color: #333;
}

.post-text.has-media p {
  font-size: 0.9rem;
}

.post-stats {
  display: flex;
  justify-content: space-around;
  padding: 1rem 1.5rem;
  border-top: 1px solid #f0f0f0;
  border-bottom: 1px solid #f0f0f0;
  background: #f8f9fa;
}

.stat {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.stat-icon {
  font-size: 1.1rem;
}

.stat-value {
  font-weight: 600;
  color: #333;
}

.post-actions {
  display: flex;
  padding: 1rem 1.5rem;
  gap: 0.5rem;
}

.action-btn {
  flex: 1;
  padding: 0.5rem 1rem;
  border: 1px solid #ddd;
  border-radius: 6px;
  background: white;
  cursor: pointer;
  font-size: 0.85rem;
  transition: all 0.3s;
}

.action-btn:hover {
  background: #f8f9fa;
  transform: translateY(-1px);
}

.view-btn {
  color: #1877f2;
  border-color: #1877f2;
}

.stats-btn {
  color: #42b883;
  border-color: #42b883;
}

.delete-btn {
  color: #f02849;
  border-color: #f02849;
  flex: 0.5;
}

.load-more {
  text-align: center;
  margin-top: 2rem;
}

.load-more-btn {
  background: #1877f2;
  color: white;
  border: none;
  padding: 1rem 2rem;
  border-radius: 8px;
  cursor: pointer;
  font-weight: 600;
  transition: background 0.3s;
}

.load-more-btn:hover {
  background: #166fe5;
}

.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0,0,0,0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.modal-content {
  background: white;
  border-radius: 12px;
  max-width: 600px;
  width: 90%;
  max-height: 80vh;
  overflow: auto;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1.5rem;
  border-bottom: 1px solid #eee;
}

.close-btn {
  background: none;
  border: none;
  font-size: 1.5rem;
  cursor: pointer;
  color: #666;
}

.modal-body {
  padding: 1.5rem;
}

/* Styles responsives */
@media (max-width: 768px) {
  .posts-container {
    padding: 1rem;
  }
  
  .controls {
    flex-direction: column;
    gap: 1rem;
  }
  
  .filters {
    flex-direction: column;
    width: 100%;
  }
  
  .posts-grid {
    grid-template-columns: 1fr;
  }
  
  .quick-stats {
    grid-template-columns: 1fr 1fr;
  }
}
</style>