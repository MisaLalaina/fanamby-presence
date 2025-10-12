import { BASE_URL } from './config.js';
import { fetchAllPages } from './api.js';

export async function createPresence(presenceData) {
  try {
    const payload = {
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

export async function searchPresence(payload){
    const response = await fetchAllPages(`${BASE_URL}/presences/search`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(payload),
    });
    if (response.returnCode !== 1) {
      throw new Error(`API error: ${json.message || 'Unknown error'}`);
    }
    const data = response.data.content;
    return data;
}

export async function getPresencesByIdSeance(idSeance) {
  try {
    const payload = {
      idseanceSeance: {
        idseance: idSeance,
      },
    }
    const response = await searchPresence(payload)
    console.log("Données des présences :", response);
    // Extract all presences
    const allPresences = response;
    const simplified = allPresences.map(p => ({
      idPresence: p.idpresence,
      idJoueur: p.idjoueurJoueur.idjoueur,
      nom: p.idjoueurJoueur.nom,
      prenom: p.idjoueurJoueur.prenom,
      poste: p.idjoueurJoueur.idpostePoste?.libelle || '',
      presenceStatus: p.idstatutpresenceStatutpresence?.libelle || null,
      idStatutPresence: p.idstatutpresenceStatutpresence?.idstatutpresence || null,
      commentaire: p.commentaires || '',
      heureArrivee: p.heurearrivee || null,
      motifAbsence: p.motifabsence || null,
      signature: p.signature || null,
    }));

    return simplified;

  } catch (error) {
    console.error('Error fetching presences:', error);
    throw error;
  }
}
