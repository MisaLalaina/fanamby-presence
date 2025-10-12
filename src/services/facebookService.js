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
    const formData = new FormData();
    formData.append('source', file);
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
      formData.append('published', 'false');

      const response = await axios.post(url, formData, {
        headers: {
          'Content-Type': 'multipart/form-data',
          ...formData.getHeaders()
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

// Uploader et publier une vidéo à partir d'un fichier
export async function uploadVideo(file, options = {}) {
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
        ...formData.getHeaders()
      },
      timeout: 300000,
    });

    return response.data;
  } catch (error) {
    console.error("Erreur lors de l'upload de la vidéo :", error.response?.data || error.message);
    throw error;
  }
}

// Vérifier les spécifications des fichiers
export function validateMediaFile(file, type = 'image') {
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

// Récupérer la liste des publications de la page (CORRIGÉ)
export async function getPagePosts(limit = 25) {
  const url = `${BASE_URL}/${FB_PAGE_ID}/posts`;

  try {
    const response = await axios.get(url, {
      params: {
        fields: 'id,message,created_time,permalink_url,attachments{media,subattachments}',
        access_token: FB_TOKEN,
        limit: limit
      }
    });

    return response.data;
  } catch (error) {
    console.error("Erreur lors de la récupération des publications :", error.response?.data || error.message);
    throw error;
  }
}

// Récupérer les statistiques détaillées d'une publication (CORRIGÉ avec métriques valides)
export async function getPostInsights(postId) {
  const url = `${BASE_URL}/${postId}/insights`;

  try {
    const response = await axios.get(url, {
      params: {
        // Métriques valides pour les posts
        metric: 'post_impressions,post_impressions_unique,post_reactions_by_type_total,post_clicks_by_type',
        access_token: FB_TOKEN
      }
    });

    return response.data;
  } catch (error) {
    console.error(`Erreur lors de la récupération des insights pour le post ${postId}:`, error.response?.data || error.message);
    
    // Retourner des données vides plutôt que de throw pour éviter de bloquer l'ensemble
    return {
      data: []
    };
  }
}

// Récupérer les réactions détaillées d'une publication
export async function getPostReactions(postId, limit = 100) {
  const url = `${BASE_URL}/${postId}/reactions`;

  try {
    const response = await axios.get(url, {
      params: {
        fields: 'id,name,type',
        access_token: FB_TOKEN,
        limit: limit,
        summary: 'total_count'
      }
    });

    return response.data;
  } catch (error) {
    console.error(`Erreur lors de la récupération des réactions pour le post ${postId}:`, error.response?.data || error.message);
    
    // Retourner une structure vide plutôt que de throw
    return {
      data: [],
      summary: { total_count: 0 }
    };
  }
}

// Récupérer les commentaires d'une publication
export async function getPostComments(postId, limit = 50) {
  const url = `${BASE_URL}/${postId}/comments`;

  try {
    const response = await axios.get(url, {
      params: {
        fields: 'id,message,created_time,from,like_count',
        access_token: FB_TOKEN,
        limit: limit,
        summary: 'total_count'
      }
    });

    return response.data;
  } catch (error) {
    console.error(`Erreur lors de la récupération des commentaires pour le post ${postId}:`, error.response?.data || error.message);
    
    // Retourner une structure vide plutôt que de throw
    return {
      data: [],
      summary: { total_count: 0 }
    };
  }
}

// Fonction pour déterminer le type de média basé sur les attachments
function getPostMediaType(post) {
  if (!post.attachments || !post.attachments.data || post.attachments.data.length === 0) {
    return 'status';
  }

  const attachment = post.attachments.data[0];
  
  if (attachment.media) {
    if (attachment.media.type === 'video') {
      return 'video';
    } else if (attachment.media.image) {
      return 'photo';
    }
  }

  if (attachment.subattachments && attachment.subattachments.data && attachment.subattachments.data.length > 1) {
    return 'album';
  }

  if (attachment.type === 'share') {
    return 'link';
  } else if (attachment.type === 'photo') {
    return 'photo';
  } else if (attachment.type === 'video') {
    return 'video';
  }

  return 'status';
}

// Fonction pour obtenir l'URL du média
function getMediaUrl(post) {
  if (!post.attachments || !post.attachments.data || post.attachments.data.length === 0) {
    return null;
  }

  const attachment = post.attachments.data[0];
  
  if (attachment.media && attachment.media.image) {
    return attachment.media.image.src;
  }
  
  if (attachment.media && attachment.media.source) {
    return attachment.media.source;
  }
  
  if (attachment.subattachments && attachment.subattachments.data && attachment.subattachments.data.length > 0) {
    const firstSubattachment = attachment.subattachments.data[0];
    if (firstSubattachment.media && firstSubattachment.media.image) {
      return firstSubattachment.media.image.src;
    }
  }

  return null;
}

// Fonction utilitaire pour calculer le taux d'engagement
function calculateEngagementRate(engagedUsers, impressions) {
  if (!impressions || impressions === 0) return 0;
  return parseFloat(((engagedUsers / impressions) * 100).toFixed(2));
}

// Récupérer le détail des réactions par type
async function getReactionsBreakdown(postId) {
  try {
    const reactions = await getPostReactions(postId);
    
    const counts = {
      like: 0,
      love: 0,
      wow: 0,
      haha: 0,
      sorry: 0,
      anger: 0
    };

    if (reactions.data) {
      reactions.data.forEach(reaction => {
        const current_type = String(reaction.type).toLowerCase()
        if (reaction.type && counts.hasOwnProperty(current_type)) {
          console.log("plus "+current_type);
          
          counts[current_type]++;
        }
      });
    }

    return counts;
  } catch (error) {
    console.error(`Erreur lors du décompte des réactions pour ${postId}:`, error);
    return {
      like: 0,
      love: 0,
      wow: 0,
      haha: 0,
      sorry: 0,
      anger: 0
    };
  }
}

// Fonction pour obtenir les statistiques de base d'un post (méthode alternative)
async function getPostEngagement(postId) {
  try {
    const url = `${BASE_URL}/${postId}`;
    const response = await axios.get(url, {
      params: {
        fields: 'reactions.summary(total_count),comments.summary(total_count),shares',
        access_token: FB_TOKEN
      }
    });

    const data = response.data;
    return {
      reactions: data.reactions?.summary?.total_count || 0,
      comments: data.comments?.summary?.total_count || 0,
      shares: data.shares?.count || 0
    };
  } catch (error) {
    console.error(`Erreur lors de la récupération de l'engagement pour ${postId}:`, error);
    return {
      reactions: 0,
      comments: 0,
      shares: 0
    };
  }
}

// Fonction complète pour récupérer toutes les publications avec leurs statistiques (CORRIGÉ)
export async function getAllPostsWithStats(limit = 25) {
  try {
    // Récupérer les publications de base
    const postsResponse = await getPagePosts(limit);
    
    if (!postsResponse.data || postsResponse.data.length === 0) {
      return {
        data: [],
        paging: null
      };
    }

    // Pour chaque publication, récupérer les statistiques détaillées
    const postsWithStats = await Promise.all(
      postsResponse.data.map(async (post) => {
        try {
          // Récupérer les insights (peut échouer pour certains posts)
          let insightsData = {};
          try {
            const insights = await getPostInsights(post.id);
            insightsData = insights.data.reduce((acc, insight) => {
              acc[insight.name] = insight.values[0].value;
              return acc;
            }, {});
          } catch (insightError) {
            console.log(`Insights non disponibles pour le post ${post.id}`);
          }

          // Récupérer l'engagement de base (méthode plus fiable)
          const engagement = await getPostEngagement(post.id);
          const reactionsBreakdown = await getReactionsBreakdown(post.id);

          // Récupérer quelques commentaires récents
          let commentsData = [];
          try {
            const comments = await getPostComments(post.id, 10);
            commentsData = comments.data || [];
          } catch (commentError) {
            console.log(`Commentaires non disponibles pour le post ${post.id}`);
          }

          return {
            id: post.id,
            message: post.message,
            created_time: post.created_time,
            permalink_url: post.permalink_url,
            media_type: getPostMediaType(post),
            media_url: getMediaUrl(post),
            attachments: post.attachments,
            stats: {
              // Données des insights (si disponibles)
              impressions: insightsData.post_impressions || 0,
              unique_impressions: insightsData.post_impressions_unique || 0,
              engaged_users: insightsData.post_engaged_users || 0,
              clicks: insightsData.post_clicks_by_type || 0,
              
              // Données d'engagement (toujours disponibles)
              total_reactions: engagement.reactions,
              reactions_breakdown: reactionsBreakdown,
              comments: engagement.comments,
              shares: engagement.shares,
              comments_list: commentsData,
              
              // Calcul du taux d'engagement
              engagement_rate: calculateEngagementRate(
                insightsData.post_engaged_users || engagement.reactions + engagement.comments + engagement.shares,
                insightsData.post_impressions || (engagement.reactions + engagement.comments + engagement.shares) * 10 // Estimation
              )
            }
          };
        } catch (error) {
          console.error(`Erreur majeure pour le post ${post.id}:`, error);
          // Retourner les données de base même en cas d'erreur
          return {
            id: post.id,
            message: post.message,
            created_time: post.created_time,
            permalink_url: post.permalink_url,
            media_type: getPostMediaType(post),
            media_url: getMediaUrl(post),
            attachments: post.attachments,
            stats: null,
            error: 'Données limitées disponibles'
          };
        }
      })
    );

    return {
      data: postsWithStats,
      paging: postsResponse.paging
    };

  } catch (error) {
    console.error("Erreur lors de la récupération des publications avec statistiques:", error);
    throw error;
  }
}

// Fonction simplifiée pour les tests (sans insights)
export async function getSimplePosts(limit = 25) {
  try {
    const response = await getPagePosts(limit);
    
    if (!response.data) {
      return {
        data: [],
        paging: null
      };
    }

    const simplePosts = response.data.map(post => ({
      id: post.id,
      message: post.message,
      created_time: post.created_time,
      permalink_url: post.permalink_url,
      media_type: getPostMediaType(post),
      media_url: getMediaUrl(post),
      attachments: post.attachments
    }));

    return {
      data: simplePosts,
      paging: response.paging
    };
  } catch (error) {
    console.error("Erreur lors de la récupération des publications simples:", error);
    throw error;
  }
}

// Récupérer les statistiques globales de la page
export async function getPageInsights(period = 'day', since = '30 days ago', until = 'today') {
  const url = `${BASE_URL}/${FB_PAGE_ID}/insights`;

  try {
    const response = await axios.get(url, {
      params: {
        metric: 'page_impressions,page_engaged_users,page_post_engagements,page_actions_post_reactions_total,page_consumptions',
        period: period,
        since: since,
        until: until,
        access_token: FB_TOKEN
      }
    });

    return response.data;
  } catch (error) {
    console.error("Erreur lors de la récupération des insights de la page:", error.response?.data || error.message);
    throw error;
  }
}

// Fonction pour récupérer une publication spécifique
export async function getPostDetails(postId) {
  try {
    const [postResponse, engagement] = await Promise.all([
      axios.get(`${BASE_URL}/${postId}`, {
        params: {
          fields: 'id,message,created_time,attachments{media,subattachments},permalink_url',
          access_token: FB_TOKEN
        }
      }),
      getPostEngagement(postId)
    ]);

    let insightsData = {};
    try {
      const insights = await getPostInsights(postId);
      insightsData = insights.data.reduce((acc, insight) => {
        acc[insight.name] = insight.values[0].value;
        return acc;
      }, {});
    } catch (insightError) {
      console.log('Insights non disponibles pour ce post');
    }

    const reactionsBreakdown = await getReactionsBreakdown(postId);
    const comments = await getPostComments(postId, 20);

    return {
      ...postResponse.data,
      media_type: getPostMediaType(postResponse.data),
      media_url: getMediaUrl(postResponse.data),
      stats: {
        impressions: insightsData.post_impressions || 0,
        unique_impressions: insightsData.post_impressions_unique || 0,
        engaged_users: insightsData.post_engaged_users || 0,
        clicks: insightsData.post_clicks_by_type || 0,
        total_reactions: engagement.reactions,
        reactions_breakdown: reactionsBreakdown,
        comments: engagement.comments,
        shares: engagement.shares,
        comments_list: comments.data || [],
        engagement_rate: calculateEngagementRate(
          insightsData.post_engaged_users || engagement.reactions + engagement.comments + engagement.shares,
          insightsData.post_impressions || (engagement.reactions + engagement.comments + engagement.shares) * 10
        )
      }
    };

  } catch (error) {
    console.error(`Erreur lors de la récupération des détails du post ${postId}:`, error);
    throw error;
  }
}