import { BASE_URL } from './config.js';

export async function createPresence(presenceData) {
  try {
    const payload = {
      idpresence: 0,
      idseanceSeance: {
        idseance: presenceData.idSeance,
      },
      idjoueurJoueur: {
        idjoueur: presenceData.idJoueur,
      },
      idstatutpresenceStatutpresence: {
        idstatutpresence: presenceData.idStatutPresence,
      },
      commentaires: presenceData.commentaire || '',
    };

    const response = await fetch(`${BASE_URL}/presences`, {
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
    return json.data; 

  } catch (error) {
    console.error('Error creating presence:', error);
    throw error;
  }
}
