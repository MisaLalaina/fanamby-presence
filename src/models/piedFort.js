export class PiedFort {
    constructor({ idpiedfort, libelle }) {
      this.id = idpiedfort;
      this.libelle = libelle;
    }
  
    static fromApiData(data) {
      return new PiedFort(data);
    }
  
    static listFromApiData(apiResponse) {
      if (
        apiResponse?.status === 200 &&
        apiResponse?.data?.content instanceof Array
      ) {
        return apiResponse.data.content.map(p => PiedFort.fromApiData(p));
      }
      return [];
    }
  }
  