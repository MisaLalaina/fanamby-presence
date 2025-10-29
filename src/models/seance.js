export class Seance {
    constructor(data) {
      this.idSeance = data.idseance;
      this.idTypeSeance = data.idtypeseanceTypeseance?.idtypeseance;
      this.idtypeseanceTypeseance = data.idtypeseanceTypeseance;

      this.typeSeance = data.idtypeseanceTypeseance?.libelle;
      this.idtypeseanceTypeseance = data.idtypeseanceTypeseance;
      
      this.type = data.idtypeseanceTypeseance?.libelle;
      this.dateSeance = data.dateseance;
      this.heureDebut = data.heuredebut?.substring(0, 5); // Format to HH:MM
      this.heureFin = data.heurefin?.substring(0, 5); // Format to HH:MM
      this.lieu = data.lieu;
      this.objectif = data.objectif;
      this.bilan = data.bilan;

      this.statut = data.idstatutseanceStatutseance?.libelle;
      this.idstatutseanceStatutseance = data.idstatutseanceStatutseance;

      this.club = data.idclubClub?.nomclub;
      this.idclubClub = data.idclubClub;
    }
  
    static formatSeances(apiData) {
      return apiData.map(item => new Seance(item));
    }
  
    static getDefaultSeance() {
      return {
        idSeance: null,
        idTypeSeance: 1,
        dateSeance: new Date().toISOString().slice(0, 10),
        heureDebut: '',
        heureFin: '',
        lieu: '',
        objectif: '',
        bilan: '',    
        idstatutseanceStatutseance: {
          idstatutseance:''
        }
      };
    }

    setRealised(){
      this.idstatutseanceStatutseance.idstatutseance = 2
    }
    
    payload(){
      return {
        idseance : this.idSeance,
        idstatutseanceStatutseance: {
          idstatutseance : this.idstatutseanceStatutseance.idseance
        }
      }
    }
}

export class SeanceSpecification {
  status;

  constructor({
    status,
  }){
    this.status = status
  }

  getSearchPayload(){
    let payload = {
      idstatutseanceStatutseance : {
        idstatutseance: this.status
      },
    }
    return payload
  }
}