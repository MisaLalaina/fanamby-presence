import { BASE_URL } from './config';

export async function getAllPostes() {
    const res = await fetch(`${BASE_URL}/postes`);
    if (!res.ok) throw new Error('Erreur récupération postes');
    const data = await res.json();
    return data;
  }