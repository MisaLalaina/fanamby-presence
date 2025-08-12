export class Seance {
    constructor(data) {
      this.idSeance = data.idseance;
      this.idTypeSeance = data.idtypeseanceTypeseance?.idtypeseance;
      this.typeSeance = data.idtypeseanceTypeseance?.libelle;
      this.type = data.idtypeseanceTypeseance?.libelle;
      this.dateSeance = data.dateseance;
      this.heureDebut = data.heuredebut?.substring(0, 5); // Format to HH:MM
      this.heureFin = data.heurefin?.substring(0, 5); // Format to HH:MM
      this.lieu = data.lieu;
      this.objectif = data.objectif;
      this.bilan = data.bilan;
      this.statut = data.idstatutseanceStatutseance?.libelle;
      this.club = data.idclubClub?.nomclub;
    }
  
    static formatSeances(apiData) {
      return apiData.map(item => new Seance(item));
    }
  
    static getDefaultSeance() {
      return {
        idSeance: null,
        idTypeSeance: 1,
        dateSeance: '',
        heureDebut: '',
        heureFin: '',
        lieu: '',
        objectif: '',
        bilan: ''
      };
    }
    
}