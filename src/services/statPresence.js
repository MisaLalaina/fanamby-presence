// statService.js
import { BASE_URL } from './config';

/**
 * Fetches all player presence statistics by handling pagination
 * @returns {Promise} The complete player presence statistics data
 */
export async function getAllPlayerPresenceStats() {
  try {
    const initialUrl = `${BASE_URL}/presence-v2/statpresencejoueurs?page=0`;
    const res = await fetch(initialUrl);
    
    if (!res.ok) throw new Error('Erreur récupération statistiques présence joueurs');
    
    const data = await res.json();
    let page = data.data.page;
    
    // Handle pagination if there are more pages
    while (page.totalPages > page.number + 1) {
      const nextUrl = `${BASE_URL}/presence-v2/statpresencejoueurs?page=${page.number + 1}`;
      const nextRes = await fetch(nextUrl);
      
      if (!nextRes.ok) throw new Error('Erreur récupération page suivante');
      
      const nextData = await nextRes.json();
      data.data.content = data.data.content.concat(nextData.data.content);
      page = nextData.data.page;
    }
    
    return data;
  } catch (error) {
    console.error('Erreur lors de la récupération des statistiques présence joueurs :', error);
    throw error;
  }
}

/**
 * Fetches all global session statistics by handling pagination
 * @returns {Promise} The complete global session statistics data
 */
export async function getAllGlobalSessionStats() {
  try {
    const initialUrl = `${BASE_URL}/presence-v2/statseanceglobales?page=0`;
    const res = await fetch(initialUrl);
    
    if (!res.ok) throw new Error('Erreur récupération statistiques séances globales');
    
    const data = await res.json();
    let page = data.data.page;
    
    // Handle pagination if there are more pages
    while (page.totalPages > page.number + 1) {
      const nextUrl = `${BASE_URL}/presence-v2/statseanceglobales?page=${page.number + 1}`;
      const nextRes = await fetch(nextUrl);
      
      if (!nextRes.ok) throw new Error('Erreur récupération page suivante');
      
      const nextData = await nextRes.json();
      data.data.content = data.data.content.concat(nextData.data.content);
      page = nextData.data.page;
    }
    
    return data;
  } catch (error) {
    console.error('Erreur lors de la récupération des statistiques séances globales :', error);
    throw error;
  }
}

/**
 * Gets dashboard statistics including both player presence and global session stats
 * @returns {Promise} Combined dashboard statistics
 */
export async function getDashboardStats() {
  try {
    const [playerStats, sessionStats] = await Promise.all([
      getAllPlayerPresenceStats(),
      getAllGlobalSessionStats()
    ]);
    
    return {
      playerPresenceStats: playerStats.data,
      globalSessionStats: sessionStats.data
    };
  } catch (error) {
    console.error('Erreur lors de la récupération des statistiques du dashboard :', error);
    throw error;
  }
}