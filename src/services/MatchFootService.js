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


export async function createMatch(matchData) {
  try {
    const payload = {
      idseanceSeance: {
        idseance: matchData.idSeance,
      },
      competition: matchData.competition || '',
      adversaire: matchData.adversaire || '',
      domicile: Boolean(matchData.domicile),
      scoreequipe: matchData.scoreEquipe || 0,
      scoreadversaire: matchData.scoreAdversaire || 0,
      tempsadditionnel1: 0,
      tempsadditionnel2: 0,
      incidents: matchData.incidents || '',
      observations: matchData.observations || '',
    };

    const response = await fetch(`${BASE_URL}/matchfoots`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(payload),
    });

    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }

    const json = await response.json();

    if (json.returnCode !== 1) {
      throw new Error(`API error: ${json.message || 'Unknown error'}`);
    }
    return MatchFoot.fromApi(json.data);

  } catch (error) {
    console.error('Error creating match:', error);
    throw error;
  }
}
