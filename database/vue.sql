create or REPLACE VIEW joueur_cpl as
select
    j.*,
    c.nomClub,
    p.libelle as nomPoste,
    sj.libelle as statusJoueur,
    sj.peutJouer,
    pf.libelle as piedFort
FROM Joueur j
INNER JOIN Club c ON j.idClub = c.idClub
INNER JOIN Poste p ON j.idPoste = p.idPoste
INNER JOIN StatutJoueur sj ON j.idStatutJoueur = sj.idStatutJoueur
INNER JOIN PiedFort pf ON j.idPiedFort = pf.idPiedFort

create or REPLACE view seance_cpl as
select
    s.*,
    c.nomClub,
    ts.libelle as typeSeance,
    ss.libelle as statutSeance
From Seance s
INNER JOIN Club c ON s.idClub = c.idClub
INNER JOIN TypeSeance ts ON ts.idTypeSeance = s.idTypeSeance
INNER JOIN StatutSeance ss ON ss.idStatutSeance = s.idStatutSeance;


select
    jc.idJoueur,
    jc.nom,
    jc.prenom,
    jc.numeroMaillot,
    jc.poste,
    jc.nomClub,


From joueur_cpl jc
LEFT JOIN Presence p on jc.idJoueur = p.idJoueur
LEFT JOIN seance_cpl sc on p.idSeance = sc.idSeance

create or REPLACE view presence_cpl as
select 
    pres.*,
    sp.libelle as statutPresence,
    s.idClub,
    s.nomClub,
    s.idTypeSeance,
    s.typeSeance,
    s.idStatutSeance,
    s.statutSeance
FROM Presence pres
LEFT JOIN seance_cpl s ON pres.idSeance = s.idSeance
LEFT JOIN StatutPresence sp ON pres.idStatutPresence = sp.idStatutPresence



select
    jc.idJoueur,
    pc.idSeance,
    pc.idPresence,
    pc.idTypeSeance,
    pc.typeSeance,
    pc.idStatutPresence,
    pc.statutPresence
From joueur_cpl jc
LEFT JOIN presence_cpl pc ON jc.idJoueur = pc.idJoueur
WHERE pc.idTypeSeance = 1

-- Stat Entrainement'
create or replace view v_presence_entrainement as
select
    jc.idJoueur,
    jc.nom,
    jc.prenom,
    jc.numeroMaillot,
    jc.nomposte,
    pc.idstatutpresence,
    pc.statutpresence,
    sca.*
from joueur_cpl jc
inner JOIN presence_cpl pc on pc.idJoueur = jc.idJoueur
INNER JOIN (
    select
        sc.*,
        EXTRACT(YEAR FROM sc.dateSeance) AS annee,
        EXTRACT(MONTH FROM sc.dateSeance) AS mois,
        TO_CHAR(sc.dateSeance, 'YYYY-MM') AS annee_mois
    from seance_cpl sc where sc.dateSeance <= CURRENT_DATE AND sc.idStatutSeance = 2 AND sc.idTypeSeance = 1
) sca on sca.idSeance = pc.idSeance


-- Stat Match'
create or replace view v_presence_match as
select
    jc.idJoueur,
    jc.nom,
    jc.prenom,
    jc.numeroMaillot,
    jc.nomposte,
    pc.idstatutpresence,
    pc.statutpresence,
    sca.*
from joueur_cpl jc
inner JOIN presence_cpl pc on pc.idJoueur = jc.idJoueur
INNER JOIN (
    select
        sc.*,
        EXTRACT(YEAR FROM sc.dateSeance) AS annee,
        EXTRACT(MONTH FROM sc.dateSeance) AS mois,
        TO_CHAR(sc.dateSeance, 'YYYY-MM') AS annee_mois
    from seance_cpl sc where sc.dateSeance <= CURRENT_DATE AND sc.idStatutSeance = 2 AND sc.idTypeSeance = 2
) sca on sca.idSeance = pc.idSeance
