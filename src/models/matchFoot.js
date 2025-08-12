export default class MatchFoot {
    constructor({
      idMatch,
      idSeance,
      competition,
      adversaire,
      domicile,
      scoreEquipe,
      scoreAdversaire,
      dateMatch,
      publicCount = null,
      tempsAdditionnel1 = 0,
      tempsAdditionnel2 = 0,
      incidents = null,
      observations = null,
    }) {
      this.idMatch = idMatch;
      this.idSeance = idSeance;
      this.competition = competition;
      this.adversaire = adversaire;
      this.domicile = domicile;
      this.scoreEquipe = scoreEquipe;
      this.scoreAdversaire = scoreAdversaire;
      this.dateMatch = dateMatch;
      this.public = publicCount;
      this.tempsAdditionnel1 = tempsAdditionnel1;
      this.tempsAdditionnel2 = tempsAdditionnel2;
      this.incidents = incidents;
      this.observations = observations;
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
      });
    }
  }
  