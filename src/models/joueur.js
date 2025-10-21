export class Joueur {
    constructor({
      idjoueur,
      nom,
      prenom,
      datenaissance,
      nationalite,
      numeromaillot,
      idpostePoste,
      dateinscription,
      datequitter,
      idstatutjoueurStatutjoueur,
      idpiedfortPiedfort,
      idclubClub,
      email,
      taille,
      poids,
      telephone
    }) {
      this.id = idjoueur;
      this.email = email;
      this.idJoueur = idjoueur;
      this.fullName = `${nom} ${prenom}`;
      this.nom = nom ;
      this.prenom = prenom;
      this.poste = idpostePoste?.libelle?.toUpperCase() || 'INCONNU';
      this.idpostePoste = idpostePoste;
      this.idpiedfortPiedfort = idpiedfortPiedfort;
      this.dateNaissance = datenaissance;
      this.nationalite = nationalite || 'Inconnue';
      this.numero = numeromaillot;
      this.dateInscription = dateinscription;
      this.dateQuitter = datequitter;
      this.status = idstatutjoueurStatutjoueur?.libelle
      this.idstatutjoueurStatutjoueur = idstatutjoueurStatutjoueur
      this.idclubClub = idclubClub
      this.taille = taille
      this.poids = poids
      this.telephone = telephone
    }
  
    static fromApiData(data) {
      return new Joueur(data);
    }
  
    static listFromApiData(apiResponse) {
      if (
        apiResponse?.status === 200 &&
        apiResponse?.data?.content instanceof Array
      ) {
        return apiResponse.data.content.map(j => Joueur.fromApiData(j));
      }
      return [];
    }
  }
  
export class JoueurSpecification {
  nom;
  prenom;
  dateInscriptionMin;
  dateInscriptionMax;
  poste;

  constructor({
    nom,
    prenom,
    dateInscriptionMin,
    dateInscriptionMax,
    poste,
  }){
    this.nom = nom;
    this.prenom = prenom;
    if (dateInscriptionMin && dateInscriptionMin != '') {
      this.dateInscriptionMin = dateInscriptionMin;
    }
    if (dateInscriptionMax && dateInscriptionMax != '') {
      this.dateInscriptionMax = dateInscriptionMax;
    }
    this.poste = ''
    if (poste && String(poste).toLocaleLowerCase() !== "tous") {
      this.poste = poste
    }
  }

  getSearchPayload(){
    let payload = {
      nom : this.nom,
      prenom : this.prenom,
      dateinscriptionMin : this.dateInscriptionMin,
      dateinscriptionMax : this.dateInscriptionMax,
    }
    if (this.poste !== '') {
      payload.idpostePoste = {
        idposte: this.poste
      }
    }
    return payload
  }
}