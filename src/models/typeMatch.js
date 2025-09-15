export class TypeMatch {
    constructor(data) {
      this.idTypeMatch = data.idtypematch;
      this.libelle = data.libelle;
      this.description = data.description;
    }
  
    static formatTypeMatch(apiData) {
      return apiData.map(item => new TypeMatch(item));
    }
  }