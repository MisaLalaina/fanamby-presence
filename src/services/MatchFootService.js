import { BASE_URL } from './config.js';
import MatchFoot from '../models/matchFoot.js';

export async function getAllMatches() {
  try {
    const response = await fetch(`${BASE_URL}/matchfoots`);
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    const json = await response.json();

    // Check for returnCode or status for success
    if (json.returnCode !== 1) {
      throw new Error(`API error: ${json.message || 'Unknown error'}`);
    }

    // Extract the raw matches array
    const rawMatches = json.data.content || [];

    // Map raw matches to frontend model format
    const formattedMatches = rawMatches.map(rawMatch => {
      return MatchFoot.fromApi(rawMatch);
    });

    return formattedMatches;

  } catch (error) {
    console.error('Error fetching matches:', error);
    throw error;
  }
}
