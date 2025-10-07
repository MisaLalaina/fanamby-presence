import axios from "axios";
import FormData from 'form-data';

const FB_PAGE_ID = import.meta.env.VITE_FB_PAGE_ID;
const FB_TOKEN = import.meta.env.VITE_FB_TOKEN;
const BASE_URL = import.meta.env.VITE_FB_GRAPH_URL;

// Fonction existante pour publier un statut simple
export async function feed(content) {
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

// Uploader et publier une photo à partir d'un fichier
export async function uploadPhoto(file, message = "") {
  const url = `${BASE_URL}/${FB_PAGE_ID}/photos`;
  
  try {
    // Créer FormData pour l'upload de fichier
    const formData = new FormData();
    formData.append('source', file); // Le fichier image
    formData.append('message', message);
    formData.append('access_token', FB_TOKEN);

    const response = await axios.post(url, formData, {
      headers: {
        'Content-Type': 'multipart/form-data',
        ...formData.getHeaders()
      },
    });

    return response.data;
  } catch (error) {
    console.error("Erreur lors de l'upload de la photo :", error.response?.data || error.message);
    throw error;
  }
}

// Uploader et publier plusieurs photos (album)
export async function uploadMultiplePhotos(files, message = "") {
  const url = `${BASE_URL}/${FB_PAGE_ID}/photos`;
  
  try {
    const publishedPhotos = [];

    for (const file of files) {
      const formData = new FormData();
      formData.append('source', file);
      formData.append('message', message);
      formData.append('access_token', FB_TOKEN);
      formData.append('published', 'false'); // Ne pas publier individuellement

      const response = await axios.post(url, formData, {
        headers: {
          'Content-Type': 'multipart/form-data',
          ...formData.getHeaders()
        },
      });

      publishedPhotos.push(response.data.id);
    }

    // Créer un post avec toutes les photos
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

// Uploader et publier une vidéo à partir d'un fichier
export async function uploadVideo(file, options = {}) {
  const url = `${BASE_URL}/${FB_PAGE_ID}/videos`;
  
  const {
    description = "",
    title = "",
    thumb = null // Image de miniature optionnelle
  } = options;

  try {
    const formData = new FormData();
    formData.append('source', file); // Le fichier vidéo
    formData.append('description', description);
    formData.append('title', title);
    formData.append('access_token', FB_TOKEN);

    // Ajouter la miniature si fournie
    if (thumb) {
      formData.append('thumb', thumb);
    }

    const response = await axios.post(url, formData, {
      headers: {
        'Content-Type': 'multipart/form-data',
        ...formData.getHeaders()
      },
      // Timeout plus long pour les vidéos
      timeout: 300000, // 5 minutes
    });

    return response.data;
  } catch (error) {
    console.error("Erreur lors de l'upload de la vidéo :", error.response?.data || error.message);
    throw error;
  }
}

// Uploader une vidéo avec progression (pour les grosses vidéos)
export async function uploadVideoWithProgress(file, options = {}, onProgress = null) {
  const startUrl = `${BASE_URL}/${FB_PAGE_ID}/videos`;
  
  const {
    description = "",
    title = "",
    file_size = null
  } = options;

  try {
    const formData = new FormData();
    formData.append('source', file);
    formData.append('description', description);
    formData.append('title', title);
    formData.append('access_token', FB_TOKEN);
    
    if (file_size) {
      formData.append('file_size', file_size);
    }

    const response = await axios.post(startUrl, formData, {
      headers: {
        'Content-Type': 'multipart/form-data',
        ...formData.getHeaders()
      },
      timeout: 300000,
      onUploadProgress: (progressEvent) => {
        if (onProgress && progressEvent.total) {
          const percentCompleted = Math.round((progressEvent.loaded * 100) / progressEvent.total);
          onProgress(percentCompleted);
        }
      }
    });

    return response.data;
  } catch (error) {
    console.error("Erreur lors de l'upload de la vidéo avec progression :", error.response?.data || error.message);
    throw error;
  }
}

// Vérifier le statut d'upload d'une vidéo
export async function checkVideoUploadStatus(videoId) {
  const url = `${BASE_URL}/${videoId}`;
  
  try {
    const response = await axios.get(url, {
      params: {
        fields: 'status,processing_phase',
        access_token: FB_TOKEN
      }
    });

    return response.data;
  } catch (error) {
    console.error("Erreur lors de la vérification du statut vidéo :", error.response?.data || error.message);
    throw error;
  }
}

// Uploader une story photo
export async function uploadPhotoStory(file) {
  const url = `${BASE_URL}/${FB_PAGE_ID}/photos`;
  
  try {
    const formData = new FormData();
    formData.append('source', file);
    formData.append('access_token', FB_TOKEN);
    formData.append('published', 'false');

    const response = await axios.post(url, formData, {
      headers: {
        'Content-Type': 'multipart/form-data',
        ...formData.getHeaders()
      },
    });

    // Utiliser l'ID de la photo pour créer une story
    const storyResponse = await axios.post(
      `${BASE_URL}/${FB_PAGE_ID}/story_attachments`,
      {
        photo: response.data.id,
        access_token: FB_TOKEN,
      },
      {
        headers: {
          "Content-Type": "application/json"
        },
      }
    );

    return storyResponse.data;
  } catch (error) {
    console.error("Erreur lors de l'upload de la story photo :", error.response?.data || error.message);
    throw error;
  }
}

// Uploader une story vidéo
export async function uploadVideoStory(file) {
  const url = `${BASE_URL}/${FB_PAGE_ID}/videos`;
  
  try {
    const formData = new FormData();
    formData.append('source', file);
    formData.append('access_token', FB_TOKEN);
    formData.append('published', 'false');

    const response = await axios.post(url, formData, {
      headers: {
        'Content-Type': 'multipart/form-data',
        ...formData.getHeaders()
      },
      timeout: 300000,
    });

    return response.data;
  } catch (error) {
    console.error("Erreur lors de l'upload de la story vidéo :", error.response?.data || error.message);
    throw error;
  }
}

// Fonction utilitaire pour convertir File/Blob en Buffer (si nécessaire)
export function fileToBuffer(file) {
  return new Promise((resolve, reject) => {
    const reader = new FileReader();
    reader.onload = () => resolve(reader.result);
    reader.onerror = reject;
    reader.readAsArrayBuffer(file);
  });
}

// Vérifier les spécifications des fichiers
export function validateMediaFile(file, type = 'image') {
  const constraints = {
    image: {
      maxSize: 4 * 1024 * 1024, // 4MB
      allowedTypes: ['image/jpeg', 'image/png', 'image/gif', 'image/webp']
    },
    video: {
      maxSize: 1024 * 1024 * 1024, // 1GB
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