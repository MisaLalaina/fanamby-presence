<script>
import { ref, computed, reactive } from 'vue'
import axios from "axios"

export default {
  name: 'FacebookPublisher',
  setup() {
    // Configuration Facebook
    const FB_PAGE_ID = import.meta.env.VITE_FB_PAGE_ID;
    const FB_TOKEN = import.meta.env.VITE_FB_TOKEN;
    const BASE_URL = import.meta.env.VITE_FB_GRAPH_URL || 'https://graph.facebook.com/v18.0';

    // Fonctions API Facebook
    const feed = async (content) => {
      const url = `${BASE_URL}/${FB_PAGE_ID}/feed`;

      try {
        const response = await axios.post(
          url,
          {
            message: content,
            access_token: FB_TOKEN,
          },
          {
            headers: {
              "Content-Type": "application/json"
            },
          }
        );

        return response.data;
      } catch (error) {
        console.error("Erreur lors de la publication Facebook :", error.response?.data || error.message);
        throw error;
      }
    }

    const uploadPhoto = async (file, message = "") => {
      const url = `${BASE_URL}/${FB_PAGE_ID}/photos`;
      
      try {
        const formData = new FormData();
        formData.append('source', file);
        formData.append('message', message);
        formData.append('access_token', FB_TOKEN);

        const response = await axios.post(url, formData, {
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        });

        return response.data;
      } catch (error) {
        console.error("Erreur lors de l'upload de la photo :", error.response?.data || error.message);
        throw error;
      }
    }

    const uploadMultiplePhotos = async (files, message = "") => {
      const url = `${BASE_URL}/${FB_PAGE_ID}/photos`;
      
      try {
        const publishedPhotos = [];

        for (const file of files) {
          const formData = new FormData();
          formData.append('source', file);
          formData.append('message', message);
          formData.append('access_token', FB_TOKEN);
          formData.append('published', 'false');

          const response = await axios.post(url, formData, {
            headers: {
              'Content-Type': 'multipart/form-data',
            },
          });

          publishedPhotos.push(response.data.id);
        }

        const feedResponse = await axios.post(
          `${BASE_URL}/${FB_PAGE_ID}/feed`,
          {
            message: message,
            attached_media: publishedPhotos.map(photoId => ({ media_fbid: photoId })),
            access_token: FB_TOKEN,
          },
          {
            headers: {
              "Content-Type": "application/json"
            },
          }
        );

        return feedResponse.data;
      } catch (error) {
        console.error("Erreur lors de l'upload multiple de photos :", error.response?.data || error.message);
        throw error;
      }
    }

    const uploadVideo = async (file, options = {}) => {
      const url = `${BASE_URL}/${FB_PAGE_ID}/videos`;
      
      const {
        description = "",
        title = "",
        thumb = null
      } = options;

      try {
        const formData = new FormData();
        formData.append('source', file);
        formData.append('description', description);
        formData.append('title', title);
        formData.append('access_token', FB_TOKEN);

        if (thumb) {
          formData.append('thumb', thumb);
        }

        const response = await axios.post(url, formData, {
          headers: {
            'Content-Type': 'multipart/form-data',
          },
          timeout: 300000,
        });

        return response.data;
      } catch (error) {
        console.error("Erreur lors de l'upload de la vidéo :", error.response?.data || error.message);
        throw error;
      }
    }

    const validateMediaFile = (file, type = 'image') => {
      const constraints = {
        image: {
          maxSize: 4 * 1024 * 1024,
          allowedTypes: ['image/jpeg', 'image/png', 'image/gif', 'image/webp']
        },
        video: {
          maxSize: 1024 * 1024 * 1024,
          allowedTypes: ['video/mp4', 'video/mov', 'video/avi', 'video/quicktime']
        }
      };

      const constraint = constraints[type];

      if (!constraint) {
        throw new Error(`Type de média non supporté: ${type}`);
      }

      if (file.size > constraint.maxSize) {
        throw new Error(`Fichier trop volumineux. Maximum: ${constraint.maxSize / (1024 * 1024)}MB`);
      }

      if (!constraint.allowedTypes.includes(file.type)) {
        throw new Error(`Type de fichier non supporté. Types autorisés: ${constraint.allowedTypes.join(', ')}`);
      }

      return true;
    }

    // Données utilisateur
    const user = reactive({
      name: 'Akademia Fanamby',
      avatar: '/logo/logofotsy.jpg'
    })

    // Données de la publication
    const post = reactive({
      content: '',
      privacy: 'public'
    })

    // États réactifs
    const fileInput = ref(null)
    const mediaPreview = ref([])
    const isPublishing = ref(false)
    const uploadProgress = ref(0)
    const publishStatus = ref('')

    // Computed properties
    const characterCount = computed(() => post.content.length)
    
    const canPublish = computed(() => {
      return post.content.trim().length > 0 || mediaPreview.value.length > 0
    })

    // Méthodes
    const triggerFileInput = () => {
      fileInput.value?.click()
    }

    const handleFileUpload = (event) => {
      const files = Array.from(event.target.files)
      files.forEach(file => {
        try {
          // Valider le fichier
          const mediaType = file.type.startsWith('image/') ? 'image' : 'video'
          validateMediaFile(file, mediaType)
          
          const reader = new FileReader()
          reader.onload = (e) => {
            mediaPreview.value.push({
              url: e.target.result,
              type: mediaType,
              file: file
            })
          }
          reader.readAsDataURL(file)
        } catch (error) {
          alert(`Erreur avec le fichier ${file.name}: ${error.message}`)
        }
      })
      event.target.value = ''
    }

    const removeMedia = (index) => {
      mediaPreview.value.splice(index, 1)
    }

    const handleContentInput = (event) => {
      if (post.content.length > 5000) {
        post.content = post.content.substring(0, 5000)
      }
    }

    const publishToFacebook = async () => {
      if (!canPublish.value) return

      isPublishing.value = true
      uploadProgress.value = 0
      publishStatus.value = 'Début de la publication...'
      
      try {
        let result

        // Cas 1: Publication avec médias
        if (mediaPreview.value.length > 0) {
          const images = mediaPreview.value.filter(media => media.type === 'image')
          const videos = mediaPreview.value.filter(media => media.type === 'video')

          // Si on a des vidéos et des images, prioriser les vidéos
          if (videos.length > 0) {
            publishStatus.value = 'Upload de la vidéo...'
            const videoFile = videos[0].file
            result = await uploadVideo(videoFile, {
              description: post.content,
              title: `Vidéo de ${user.name}`
            })
          }
          // Si on a seulement des images
          else if (images.length > 0) {
            if (images.length === 1) {
              publishStatus.value = 'Upload de la photo...'
              result = await uploadPhoto(images[0].file, post.content)
            } else {
              publishStatus.value = 'Upload des photos...'
              const imageFiles = images.map(img => img.file)
              result = await uploadMultiplePhotos(imageFiles, post.content)
            }
          }
        }
        // Cas 2: Publication texte seule
        else {
          publishStatus.value = 'Publication du statut...'
          result = await feed(post.content)
        }

        console.log('Publication Facebook réussie:', result)
        publishStatus.value = 'Publication réussie !'
        
        // Réinitialiser le formulaire après un délai
        setTimeout(() => {
          resetForm()
          publishStatus.value = ''
        }, 2000)
        
      } catch (error) {
        console.error('Erreur lors de la publication Facebook:', error)
        publishStatus.value = 'Erreur lors de la publication'
        
        let errorMessage = 'Erreur lors de la publication sur Facebook'
        if (error.response?.data?.error) {
          const fbError = error.response.data.error
          errorMessage = `Facebook Error: ${fbError.message} (Code: ${fbError.code})`
        } else if (error.message) {
          errorMessage = error.message
        }
        
        alert(errorMessage)
      } finally {
        isPublishing.value = false
        uploadProgress.value = 0
      }
    }

    const publishPostWithProgress = async () => {
      if (!canPublish.value) return

      isPublishing.value = true
      uploadProgress.value = 0
      
      try {
        // Simuler la progression pour les vidéos
        if (mediaPreview.value.some(media => media.type === 'video')) {
          for (let i = 0; i <= 100; i += 10) {
            uploadProgress.value = i
            publishStatus.value = `Upload de la vidéo... ${i}%`
            await new Promise(resolve => setTimeout(resolve, 300))
          }
        }
        
        await publishToFacebook()
        
      } catch (error) {
        console.error('Erreur:', error)
      }
    }

    const resetForm = () => {
      post.content = ''
      post.privacy = 'public'
      mediaPreview.value = []
      uploadProgress.value = 0
      publishStatus.value = ''
    }

    const closePublisher = () => {
      if (post.content || mediaPreview.value.length > 0) {
        if (confirm('Voulez-vous vraiment quitter ? Votre publication ne sera pas sauvegardée.')) {
          resetForm()
        } else {
          return
        }
      }
    }

    // Méthode pour obtenir le type de publication
    const getPublicationType = () => {
      if (mediaPreview.value.length === 0) return 'text'
      if (mediaPreview.value.some(media => media.type === 'video')) return 'video'
      if (mediaPreview.value.length === 1) return 'single_photo'
      return 'multiple_photos'
    }

    return {
      // Data
      user,
      post,
      fileInput,
      mediaPreview,
      isPublishing,
      uploadProgress,
      publishStatus,
      
      // Computed
      characterCount,
      canPublish,
      
      // Methods
      triggerFileInput,
      handleFileUpload,
      removeMedia,
      handleContentInput,
      publishPost: publishPostWithProgress,
      closePublisher,
      getPublicationType
    }
  }
}
</script>

<template>
  <div class="container">
    <div class="publisher-header">
      <h2>Créer une publication Facebook</h2>
    </div>

    <!-- En-tête utilisateur -->
    <div class="user-info">
      <img :src="user.avatar" alt="Avatar" class="user-avatar">
      <div class="user-details">
        <span class="user-name">{{ user.name }}</span>
        <div class="privacy-selector">
          <select v-model="post.privacy" class="privacy-dropdown">
            <option value="public">Public</option>
            <option value="only_me">Privé</option>
          </select>
        </div>
      </div>
    </div>

    <!-- Zone de texte -->
    <div class="content-area">
      <textarea
        v-model="post.content"
        placeholder="Quoi de neuf ?"
        class="post-textarea"
        rows="4"
        @input="handleContentInput"
      ></textarea>
      
     
    </div>

    <!-- Barre de progression -->
    <div v-if="isPublishing && uploadProgress > 0" class="progress-container">
      <div class="progress-bar">
        <div 
          class="progress-fill" 
          :style="{ width: uploadProgress + '%' }"
        ></div>
      </div>
      <div class="progress-text">{{ uploadProgress }}%</div>
    </div>

    <!-- Statut de publication -->
    <div v-if="publishStatus" class="status-message">
      {{ publishStatus }}
    </div>

    <!-- Prévisualisation des médias -->
    <div v-if="mediaPreview.length > 0" class="media-preview">
      <div 
        v-for="(media, index) in mediaPreview" 
        :key="index" 
        class="media-item"
      >
        <img 
          v-if="media.type === 'image'" 
          :src="media.url" 
          alt="Preview" 
          class="preview-image"
        >
        <video 
          v-else-if="media.type === 'video'" 
          :src="media.url" 
          controls
          class="preview-video"
        ></video>
        <button 
          @click="removeMedia(index)" 
          class="remove-media-btn"
          :disabled="isPublishing"
        >
          ×
        </button>
        <div class="media-type-badge">
          {{ media.type === 'image' ? '📷' : '🎥' }}
        </div>
      </div>
    </div>

    <!-- Options de publication -->
    <div class="publishing-options">
      <div class="options-title">Ajouter à votre publication</div>
      <div class="options-grid">
        <button 
          @click="triggerFileInput" 
          class="option-btn"
          :disabled="isPublishing"
        >
          <span class="option-icon">📷</span>
          Photo/Video
        </button>
      </div>
    </div>

    <!-- Informations sur le type de publication -->
    <div v-if="mediaPreview.length > 0" class="publication-info">
      <div class="info-icon">ℹ️</div>
      <div class="info-text">
        <span v-if="getPublicationType() === 'single_photo'">
          📷 Publication d'une photo
        </span>
        <span v-else-if="getPublicationType() === 'multiple_photos'">
          🖼️ Publication de {{ mediaPreview.length }} photos
        </span>
        <span v-else-if="getPublicationType() === 'video'">
          🎥 Publication d'une vidéo
        </span>
        <span v-else>
          ✏️ Publication de statut
        </span>
      </div>
    </div>

    <!-- Input fichier caché -->
    <input
      type="file"
      ref="fileInput"
      @change="handleFileUpload"
      multiple
      accept="image/*,video/*"
      style="display: none"
      :disabled="isPublishing"
    >

    <!-- Boutons d'action -->
    <div class="action-buttons">
      <button 
        @click="closePublisher" 
        class="cancel-btn"
        :disabled="isPublishing"
      >
        Annuler
      </button>
      <button 
        @click="publishPost" 
        :disabled="!canPublish || isPublishing"
        class="publish-btn"
        :class="{ 
          'disabled': !canPublish || isPublishing,
          'publishing': isPublishing 
        }"
      >
        <span v-if="isPublishing" class="publishing-spinner">⏳</span>
        {{ isPublishing ? 'Publication...' : 'Publier sur Facebook' }}
      </button>
    </div>
  </div>
</template>

<style scoped>
.container {
  max-width: 500px;
  margin: 2rem auto;
  padding: 2rem;
  background: #ffffff;
  border-radius: 12px;
  box-shadow: 0 10px 25px rgba(178, 185, 185, 0.1);
}

h2 {
  text-align: center;
  color: #1877f2;
  margin-bottom: 1.8rem;
  font-weight: 600;
  font-size: 1.8rem;
}

.publisher-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1.5rem;
}

.user-info {
  display: flex;
  align-items: center;
  margin-bottom: 1.5rem;
}

.user-avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  margin-right: 12px;
}

.user-details {
  display: flex;
  flex-direction: column;
}

.user-name {
  font-weight: 600;
  margin-bottom: 4px;
  color: #555;
}

.privacy-dropdown {
  border: 1px solid #ddd;
  background: #f9f9f9;
  border-radius: 8px;
  padding: 4px 8px;
  font-size: 0.9rem;
  cursor: pointer;
  color: #555;
}

.content-area {
  margin-bottom: 1.5rem;
}

.post-textarea {
  width: 100%;
  padding: 0.85rem 1rem;
  border: 1px solid #ddd;
  border-radius: 8px;
  min-height: 120px;
  resize: vertical;
  font-size: 1rem;
  font-family: inherit;
  outline: none;
}

.post-textarea:focus {
  border-color: #1877f2;
}

.character-counter {
  text-align: right;
  font-size: 0.85rem;
  color: #65676b;
  margin-top: 8px;
}

.character-counter.near-limit {
  color: #f02849;
}

/* Barre de progression */
.progress-container {
  margin: 1rem 0;
  padding: 1rem;
  background: #f0f2f5;
  border-radius: 8px;
}

.progress-bar {
  width: 100%;
  height: 8px;
  background: #e4e6eb;
  border-radius: 4px;
  overflow: hidden;
}

.progress-fill {
  height: 100%;
  background: #1877f2;
  transition: width 0.3s ease;
}

.progress-text {
  text-align: center;
  font-size: 0.9rem;
  color: #65676b;
  margin-top: 8px;
}

/* Statut de publication */
.status-message {
  padding: 0.75rem;
  border-radius: 8px;
  margin: 1rem 0;
  text-align: center;
  font-weight: 500;
  background: #e7f3ff;
  color: #1877f2;
  border: 1px solid #b3d4fc;
}

.media-preview {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
  margin-bottom: 1.5rem;
  padding: 1rem;
  border: 1px solid #eee;
  border-radius: 8px;
  background: #f9f9f9;
}

.media-item {
  position: relative;
  width: 100px;
  height: 100px;
}

.preview-image,
.preview-video {
  width: 100%;
  height: 100%;
  object-fit: cover;
  border-radius: 8px;
  border: 1px solid #ddd;
}

.remove-media-btn {
  position: absolute;
  top: -8px;
  right: -8px;
  background: white;
  border: none;
  border-radius: 50%;
  width: 24px;
  height: 24px;
  cursor: pointer;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  font-size: 14px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.remove-media-btn:hover:not(:disabled) {
  transform: translateY(-2px);
}

.remove-media-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.media-type-badge {
  position: absolute;
  bottom: -5px;
  left: -5px;
  background: rgba(0, 0, 0, 0.7);
  color: white;
  border-radius: 50%;
  width: 20px;
  height: 20px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 10px;
}

.publishing-options {
  margin-bottom: 1.5rem;
}

.options-title {
  font-size: 0.95rem;
  color: #555;
  margin-bottom: 12px;
  font-weight: 600;
}

.options-grid {
  display: flex;
  gap: 1.5rem;
}

.option-btn {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 12px;
  border: 1px solid #ddd;
  background: #f9f9f9;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s ease;
  min-width: 80px;
}

.option-btn:hover:not(:disabled) {
  transform: translateY(-2px);
  background: #e9e9e9;
}

.option-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.option-icon {
  font-size: 20px;
  margin-bottom: 4px;
}

/* Informations publication */
.publication-info {
  display: flex;
  align-items: center;
  padding: 0.75rem;
  background: #f0f2f5;
  border-radius: 8px;
  margin-bottom: 1rem;
}

.info-icon {
  margin-right: 8px;
  font-size: 1.1rem;
}

.info-text {
  font-size: 0.9rem;
  color: #65676b;
  font-weight: 500;
}

.action-buttons {
  display: flex;
  gap: 12px;
  margin-top: 1.5rem;
}

.cancel-btn {
  flex: 1;
  background: #e4e6eb;
  color: #050505;
  padding: 0.85rem 1.5rem;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  font-size: 1rem;
  font-weight: 600;
  transition: all 0.3s ease;
}

.cancel-btn:hover:not(:disabled) {
  background: #d8dadf;
}

.cancel-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.publish-btn {
  flex: 2;
  background: #1877f2;
  color: white;
  padding: 0.85rem 1.5rem;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  font-size: 1rem;
  font-weight: 600;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
}

.publish-btn:hover:not(.disabled) {
  background: #166fe5;
  transform: translateY(-2px);
}

.publish-btn.disabled {
  background: #bdc3c7;
  cursor: not-allowed;
  transform: none;
}

.publish-btn.publishing {
  background: #42a5f5;
}

.publishing-spinner {
  animation: spin 1s linear infinite;
}

@keyframes spin {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

/* Responsive */
@media (max-width: 600px) {
  .container {
    margin: 1rem;
    padding: 1.5rem;
  }
  
  .action-buttons {
    flex-direction: column;
  }
}
</style>