import { BASE_URL } from './config';

export async function getAllPresenceStatus() {
    const res = await fetch(`${BASE_URL}/statutpresences`);
    if (!res.ok) throw new Error('Erreur récupération status presence');
    const data = await res.json();
    return data;
}