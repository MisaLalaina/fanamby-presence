export class Joueur {
    constructor(data) {
      this.id = data.idjoueur;
      this.email = data.email;
      this.idJoueur = data.idjoueur;
      this.fullName = `${data.nom} ${data.prenom}`;
      this.nom = data.nom ;
      this.prenom = data.prenom;
      this.poste = data.idpostePoste?.libelle?.toUpperCase() || 'INCONNU';
      this.dateNaissance = data.datenaissance;
      this.datenaissance = data.datenaissance;
      this.nationalite = data.nationalite || 'Inconnue';
      this.numeromaillot = data.numeromaillot;
      this.dateInscription = data.dateinscription;
      this.dateinscription = data.dateinscription;
      this.dateQuitter = data.datequitter;
      this.datequitter = data.datequitter;
      this.status = data.idstatutjoueurStatutjoueur?.libelle
      this.taille = data.taille
      this.poids = data.poids
      this.telephone = data.telephone
      this.idclubClub = data.idclubClub;
      this.idpostePoste = data.idpostePoste;
      this.idstatutjoueurStatutjoueur = data.idstatutjoueurStatutjoueur;
      this.idpiedfortPiedfort = data.idpiedfortPiedfort;
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

    getDTO(){
      return {
        idjoueur: this.id,
        email : this.email,
        idjoueur : this.idJoueur ,
        nom : this.nom ,
        prenom : this.prenom ,
        datenaissance : this.dateNaissance ,
        nationalite  : this.nationalite,
        numeromaillot : this.numeromaillot ,
        dateinscription : this.dateInscription ,
        datequitter : this.dateQuitter ,
        idstatutjoueurStatutjoueur  : this.idstatutjoueurStatutjoueur ,
        idclubClub  : this.idclubClub ,
        taille  : this.taille ,
        poids  : this.poids ,
        telephone  : this.telephone ,
        idclubClub : this.idclubClub ,
        idpostePoste : this.idpostePoste ,
        idstatutjoueurStatutjoueur : this.idstatutjoueurStatutjoueur ,
        idpiedfortPiedfort : this.idpiedfortPiedfort ,
      }
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