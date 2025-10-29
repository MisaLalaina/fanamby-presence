export default class MatchFoot {
    constructor(data) {
      this.idMatch = data.idMatch;
      this.idSeance = data.idSeance;
      this.competition = data.competition;
      this.adversaire = data.adversaire;
      this.domicile = data.domicile;
      this.scoreEquipe = data.scoreEquipe;
      this.scoreAdversaire = data.scoreAdversaire;
      this.dateMatch = data.dateMatch;
      this.public = data.publicCount;
      this.tempsAdditionnel1 = data.tempsAdditionnel1;
      this.tempsAdditionnel2 = data.tempsAdditionnel2;
      this.incidents = data.incidents;
      this.observations = data.observations;
      this.idtypematchTypematch = data.typeMatch
    }
  
    // Static factory method to create MatchFoot from raw API data
    static fromApi(apiData) {
      return new MatchFoot({
        idMatch: apiData.idmatch,
        idSeance: apiData.idseanceSeance?.idseance || null,
        competition: apiData.competition || '',
        adversaire: apiData.adversaire || '',
        domicile: Boolean(apiData.domicile),
        scoreEquipe: apiData.scoreequipe || 0,
        scoreAdversaire: apiData.scoreadversaire || 0,
        dateMatch: apiData.idseanceSeance?.dateseance || '',
        // No public count in API, default to null
        publicCount: null,
        tempsAdditionnel1: apiData.tempsadditionnel1 || 0,
        tempsAdditionnel2: apiData.tempsadditionnel2 || 0,
        incidents: apiData.incidents || null,
        observations: apiData.observations || null,
        typeMatch: apiData.idtypematchTypematch,
      });
    }
  }
  