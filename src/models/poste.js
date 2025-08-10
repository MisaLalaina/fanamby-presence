export class Poste {
    constructor({ idposte, libelle, description }) {
      this.id = idposte;
      this.libelle = libelle;
      this.description = description;
    }
  
    static fromApiData(data) {
      return new Poste(data);
    }
  
    static listFromApiData(apiResponse) {
      if (
        apiResponse?.status === 200 &&
        apiResponse?.data?.content instanceof Array
      ) {
        return apiResponse.data.content.map(p => Poste.fromApiData(p));
      }
      return [];
    }
  }
  