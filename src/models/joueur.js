export class Joueur {
    constructor({
      idjoueur,
      nom,
      prenom,
      datenaissance,
      nationalite,
      numeromaillot,
      idpostePoste
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
  