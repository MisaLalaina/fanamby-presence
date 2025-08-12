export class TypeSeance {
    constructor(data) {
      this.idTypeSeance = data.idtypeseance;
      this.libelle = data.libelle;
      this.description = data.description;
    }
  
    static formatTypeSeances(apiData) {
      return apiData.map(item => new TypeSeance(item));
    }
  }