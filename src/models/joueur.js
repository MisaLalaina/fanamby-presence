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
    }) {
      this.id = idjoueur;
      this.idJoueur = idjoueur;
      this.nom = `${nom} ${prenom}`;
      this.poste = idpostePoste?.libelle?.toUpperCase() || 'INCONNU';
      this.dateNaissance = datenaissance
        ? new Date(datenaissance).toLocaleDateString('fr-FR')
        : 'Inconnue';
      this.nationalite = nationalite || 'Inconnue';
      this.numero = numeromaillot || '-';
      this.dateInscription = dateinscription;
      this.dateQuitter = datequitter;
      this.status = idstatutjoueurStatutjoueur?.libelle
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
      dateInscriptionMin : this.dateInscriptionMin,
      dateInscriptionMax : this.dateInscriptionMax,
    }
    if (this.poste !== '') {
      payload.idpostePoste = {
        idposte: this.poste
      }
    }
    return payload
  }
}