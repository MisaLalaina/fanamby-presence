CREATE OR REPLACE VIEW vue_statistiques_presence_individuelles AS
SELECT 
    j.idJoueur,
    j.nom,
    j.prenom,
    j.numeroMaillot,
    p.libelle AS poste,
    c.nomClub,
    
    -- Informations temporelles pour filtrage
    EXTRACT(YEAR FROM s.dateSeance) AS annee,
    EXTRACT(MONTH FROM s.dateSeance) AS mois,
    TO_CHAR(s.dateSeance, 'YYYY-MM') AS annee_mois,
    
    -- Statistiques générales
    SUM(CASE WHEN sp.code = 'P' THEN 1 ELSE 0 END) AS presentes,
    SUM(CASE WHEN sp.code = 'A' THEN 1 ELSE 0 END) AS absences,
    
    -- Détails par type de séance
    SUM(CASE WHEN ts.libelle = 'Entrainement' AND sp.code = 'P' THEN 1 ELSE 0 END) AS entrainements_presents,
    SUM(CASE WHEN ts.libelle = 'Entrainement' AND sp.code = 'A' THEN 1 ELSE 0 END) AS entrainements_absents,
    SUM(CASE WHEN ts.libelle = 'Match' AND sp.code = 'P' THEN 1 ELSE 0 END) AS matches_presents,
    SUM(CASE WHEN ts.libelle = 'Match' AND sp.code = 'A' THEN 1 ELSE 0 END) AS matches_absents,

FROM Joueur j
INNER JOIN Club c ON j.idClub = c.idClub
INNER JOIN Poste p ON j.idPoste = p.idPoste
LEFT JOIN Presence pres ON j.idJoueur = pres.idJoueur
LEFT JOIN Seance s ON pres.idSeance = s.idSeance
LEFT JOIN TypeSeance ts ON s.idTypeSeance = ts.idTypeSeance
LEFT JOIN StatutPresence sp ON pres.idStatutPresence = sp.idStatutPresence

WHERE j.idStatutJoueur IN (SELECT idStatutJoueur FROM StatutJoueur WHERE peutJouer = TRUE)

GROUP BY 
    j.idJoueur, 
    j.nom, 
    j.prenom, 
    j.numeroMaillot, 
    p.libelle, 
    c.nomClub,
    EXTRACT(YEAR FROM s.dateSeance),
    EXTRACT(MONTH FROM s.dateSeance),
    TO_CHAR(s.dateSeance, 'YYYY-MM')
    
ORDER BY annee DESC, mois DESC, c.nomClub, j.nom, j.prenom;

--- 

CREATE OR REPLACE VIEW vue_statistiques_presence_generales AS
SELECT 
    c.idClub,
    c.nomClub,
    
    -- Totaux généraux
    COUNT(DISTINCT j.idJoueur) AS total_joueurs,
    COUNT(DISTINCT s.idSeance) AS total_seances,
    COUNT(pres.idPresence) AS total_presences_enregistrees,
    
    -- Statistiques de présence
    SUM(CASE WHEN sp.code = 'P' THEN 1 ELSE 0 END) AS total_presents,
    SUM(CASE WHEN sp.code = 'A' THEN 1 ELSE 0 END) AS total_absents,
    SUM(CASE WHEN sp.code = 'R' THEN 1 ELSE 0 END) AS total_retards,
    SUM(CASE WHEN sp.code = 'E' THEN 1 ELSE 0 END) AS total_exemples,
    
    -- Taux moyens
    ROUND(
        (SUM(CASE WHEN sp.code = 'P' THEN 1 ELSE 0 END) * 100.0 / 
        NULLIF(COUNT(pres.idPresence), 0)
    ), 2) AS taux_presence_moyen,
    
    -- Par type de séance
    COUNT(DISTINCT CASE WHEN ts.libelle = 'Entrainement' THEN s.idSeance END) AS total_entrainements,
    COUNT(DISTINCT CASE WHEN ts.libelle = 'Match' THEN s.idSeance END) AS total_matches,
    
    -- Présence par type
    SUM(CASE WHEN ts.libelle = 'Entrainement' AND sp.code = 'P' THEN 1 ELSE 0 END) AS entrainements_presents,
    SUM(CASE WHEN ts.libelle = 'Match' AND sp.code = 'P' THEN 1 ELSE 0 END) AS matches_presents,
    
    -- Période
    MIN(s.dateSeance) AS date_debut_periode,
    MAX(s.dateSeance) AS date_fin_periode,
    
    -- Joueurs les plus assidus
    (SELECT j.nom || ' ' || j.prenom 
     FROM Joueur j
     INNER JOIN Presence p ON j.idJoueur = p.idJoueur
     INNER JOIN StatutPresence sp2 ON p.idStatutPresence = sp2.idStatutPresence
     WHERE j.idClub = c.idClub AND sp2.code = 'P'
     GROUP BY j.idJoueur, j.nom, j.prenom
     ORDER BY COUNT(*) DESC 
     LIMIT 1) AS joueur_plus_assidu,
    
    -- Dernière activité
    MAX(s.dateSeance) AS derniere_activite

FROM Club c
LEFT JOIN Joueur j ON c.idClub = j.idClub
LEFT JOIN Presence pres ON j.idJoueur = pres.idJoueur
LEFT JOIN Seance s ON pres.idSeance = s.idSeance
LEFT JOIN TypeSeance ts ON s.idTypeSeance = ts.idTypeSeance
LEFT JOIN StatutPresence sp ON pres.idStatutPresence = sp.idStatutPresence

WHERE j.idStatutJoueur IN (SELECT idStatutJoueur FROM StatutJoueur WHERE peutJouer = TRUE)

GROUP BY c.idClub, c.nomClub
ORDER BY c.nomClub;