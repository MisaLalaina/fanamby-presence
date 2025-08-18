import { BASE_URL } from './config';

export async function getAllPiedsFort() {
    const res = await fetch(`${BASE_URL}/piedforts`);
    if (!res.ok) throw new Error('Erreur récupération pieds fort');
    const data = await res.json();
    return data;
  }