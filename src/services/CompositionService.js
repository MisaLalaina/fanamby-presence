import { BASE_URL } from './config';

export async function getAllCompositions() {
    const res = await fetch(`${BASE_URL}/compositions`);
    if (!res.ok) throw new Error('Erreur récupération compositions');
    const data = await res.json();
    return data.data.content;
}

export async function getAllCompositionsByMatchId(matchId) {
  const compositions = await getAllCompositions();

  return compositions
    .filter(c => c.idmatchMatchfoot?.idmatch === matchId)
    .map(c => ({
      idComposition: c.idcomposition,
      idMatch: c.idmatchMatchfoot?.idmatch || null,
      idJoueur: c.idjoueurJoueur?.idjoueur || null,
      idStatutComposition: c.idstatutcompositionStatutcomposition?.idstatutcomposition || null,
      numeroMaillot: c.numeromaillot || null,
      position: c.position || null,
      isCapitaine: Boolean(c.iscapitaine),
      commentaire: c.commentaire || '',
      nom: c.idjoueurJoueur?.nom || '',
      prenom: c.idjoueurJoueur?.prenom || '',
      poste: c.idjoueurJoueur?.idpostePoste?.libelle || ''
    }));
}

export async function getAllStatutCompositions() {
    const res = await fetch(`${BASE_URL}/statutcompositions`);
    if (!res.ok) throw new Error('Erreur récupération statut compositions');
  
    const { data } = await res.json();
    const statusesArray = Array.isArray(data?.content) ? data.content : [];
  
    return statusesArray.map(s => ({
      idStatutComposition: s.idstatutcomposition,
      libelle: s.libelle
    }));
}

export async function createComposition(form) {
  const body = {
    idmatchMatchfoot: {
      idmatch: form.idMatch
    },
    idjoueurJoueur: {
      idjoueur: form.idJoueur
    },
    idstatutcompositionStatutcomposition: {
      idstatutcomposition: form.idStatutComposition
    },
    numeromaillot: form.numeroMaillot || null,
    position: form.position || null,
    iscapitaine: !!form.isCapitaine,
    commentaire: form.commentaire || ''
  };

  const res = await fetch(`${BASE_URL}/compositions`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(body)
  });

  if (!res.ok) {
    const errorText = await res.text();
    throw new Error(`Erreur création composition: ${errorText}`);
  }

  return await res.json();

}
