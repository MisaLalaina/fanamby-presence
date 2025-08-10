import { BASE_URL } from './config';

export async function createJoueur(joueur) {
  try {
    const response = await fetch(`${BASE_URL}/joueurs`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(joueur)
    });

    if (!response.ok) {
      throw new Error(`Erreur API : ${response.status}`);
    }

    return await response.json();
  } catch (error) {
    console.error('Erreur lors de la création du joueur :', error);
    throw error;
  }
}

export async function getAllJoueurs() {
    const res = await fetch(`${BASE_URL}/joueurs`);
    if (!res.ok) throw new Error('Erreur récupération joueurs');
    const data = await res.json();
    return data;
}
