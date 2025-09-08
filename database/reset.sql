-- Se connecter à la base de données
\c fanamby_presence;

-- Désactiver temporairement les contraintes de clé étrangère (plus sûr que TRUNCATE CASCADE)
SET session_replication_role = replica;

-- Supprimer les données des tables dans l'ordre inverse des dépendances
-- Tables avec données utilisateur
DELETE FROM Composition;
DELETE FROM MatchFoot;
DELETE FROM Presence;
DELETE FROM Seance;
DELETE FROM Joueur;
DELETE FROM Club;

-- Supprimer les données des tables de référence
DELETE FROM StatutComposition;
DELETE FROM StatutSeance;
DELETE FROM PiedFort;
DELETE FROM NiveauMatch;
DELETE FROM NiveauArbitre;
DELETE FROM StatutJoueur;
DELETE FROM StatutPresence;
DELETE FROM TypeSeance;
DELETE FROM Poste;

-- Réactiver les contraintes de clé étrangère
SET session_replication_role = DEFAULT;

-- Réinitialiser les séquences (pour que les nouveaux IDs recommencent à 1)
ALTER SEQUENCE Composition_idComposition_seq RESTART WITH 1;
ALTER SEQUENCE MatchFoot_idMatch_seq RESTART WITH 1;
ALTER SEQUENCE Presence_idPresence_seq RESTART WITH 1;
ALTER SEQUENCE Seance_idSeance_seq RESTART WITH 1;
ALTER SEQUENCE Joueur_idJoueur_seq RESTART WITH 1;
ALTER SEQUENCE Club_idClub_seq RESTART WITH 1;
ALTER SEQUENCE StatutComposition_idStatutComposition_seq RESTART WITH 1;
ALTER SEQUENCE StatutSeance_idStatutSeance_seq RESTART WITH 1;
ALTER SEQUENCE PiedFort_idPiedFort_seq RESTART WITH 1;
ALTER SEQUENCE NiveauMatch_idNiveauMatch_seq RESTART WITH 1;
ALTER SEQUENCE NiveauArbitre_idNiveauArbitre_seq RESTART WITH 1;
ALTER SEQUENCE StatutJoueur_idStatutJoueur_seq RESTART WITH 1;
ALTER SEQUENCE StatutPresence_idStatutPresence_seq RESTART WITH 1;
ALTER SEQUENCE TypeSeance_idTypeSeance_seq RESTART WITH 1;
ALTER SEQUENCE Poste_idPoste_seq RESTART WITH 1;

-- Insérer les données de référence essentielles
-- Postes
-- Insertion des données dans les tables d'énumération
INSERT INTO Poste (libelle, description) VALUES 
('Gardien', 'Joueur protégeant les buts'),
('Defenseur', 'Joueur en défense'),
('Milieu', 'Joueur au milieu de terrain'),
('Attaquant', 'Joueur en attaque');

INSERT INTO TypeSeance (libelle, description) VALUES 
('Entrainement', 'Séance d entraînement régulière'),
('Match', 'Match');

INSERT INTO TypeMatch (libelle, description) VALUES
('Amical', 'Match sans enjeu compétitif'),
('Officiel', 'Match de championnat ou coupe');

INSERT INTO StatutPresence (libelle, code) VALUES 
('Present', 'P'),
('Absent', 'A');

INSERT INTO StatutJoueur (libelle, peutJouer) VALUES 
('Actif', TRUE),
('Blessé', FALSE),
('Suspendu', FALSE),
('Inactif', FALSE),
('En convalescence', FALSE);

INSERT INTO NiveauMatch (libelle) VALUES 
('Regional'), ('Departemental'), ('Ligue'), ('National');

INSERT INTO PiedFort (libelle) VALUES 
('Droit'), ('Gauche'), ('Ambidextre');

INSERT INTO StatutSeance (libelle) VALUES 
('Planifié'), ('Réalisé'), ('Annulé');

INSERT INTO StatutComposition (libelle) VALUES 
('Titulaire'), ('Remplaçant'), ('Blessé'), ('Suspendu'), ('Autre');

-- Insertion du club
INSERT INTO Club (
    nomClub, 
    ville, 
    dateCreation, 
    couleurs, 
    logo, 
    email, 
    motDePasse, 
    telephone, 
    adresse, 
    president, 
    dateFondation, 
    stadePrincipal, 
    siteWeb
) VALUES (
    'Akademia Fanamby', 
    'Antananarivo', 
    '2020-05-15', 
    'Rouge et Blanc', 
    'https://example.com/logo-akademia.png', 
    'contact@akademiafanamby.mg', 
    '123456',  -- Note: En production, stocker les mots de passe hashés
    '+261 34 12 345 67', 
    'Stade Municipal, Avenue de l Indépendance', 
    'Jean Rakotomalala', 
    2020, 
    'Stade Municipal de Mahamasina', 
    'https://akademiafanamby.mg'
);
