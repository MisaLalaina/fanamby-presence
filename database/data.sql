-- Insertion des données dans les tables d'énumération
INSERT INTO Poste (libelle, description) VALUES 
('Gardien', 'Joueur protégeant les buts'),
('Defenseur', 'Joueur en défense'),
('Milieu', 'Joueur au milieu de terrain'),
('Attaquant', 'Joueur en attaque');

INSERT INTO TypeSeance (libelle, description) VALUES 
('Entrainement', 'Séance d entraînement régulière'),
('Match amical', 'Match sans enjeu compétitif'),
('Match officiel', 'Match de championnat ou coupe'),
('Seance physique', 'Séance axée sur la condition physique'),
('Seance tactique', 'Séance axée sur la tactique d équipe');

INSERT INTO StatutPresence (libelle, code) VALUES 
('Present', 'P'),
('Absent', 'A'),
('Retard', 'R'),
('Excusé', 'E');

INSERT INTO StatutJoueur (libelle, peutJouer) VALUES 
('Actif', TRUE),
('Blessé', FALSE),
('Suspendu', FALSE),
('Inactif', FALSE),
('En convalescence', FALSE);

INSERT INTO NiveauArbitre (libelle) VALUES 
('Federal'), ('Regional'), ('Departemental'), ('Jeune');

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

-- Insertion de 5 joueurs
INSERT INTO Joueur (
    idClub, idPoste, idStatutJoueur, nom, prenom, dateNaissance, 
    lieuNaissance, nationalite, idPiedFort, taille, poids, 
    numeroMaillot, telephone, dateInscription
) VALUES 
(1, 1, 1, 'Rakoto', 'Jean', '1995-03-15', 'Antananarivo', 'Malagasy', 1, 185, 80, 1, '+261 34 11 111 11', '2023-01-10'),
(1, 2, 1, 'Rabe', 'Paul', '1998-07-22', 'Antsirabe', 'Malagasy', 1, 178, 75, 4, '+261 34 22 222 22', '2023-01-10'),
(1, 3, 1, 'Randria', 'Pierre', '1997-11-05', 'Fianarantsoa', 'Malagasy', 2, 172, 68, 8, '+261 34 33 333 33', '2023-01-10'),
(1, 4, 1, 'Rasoa', 'Jacques', '1999-02-28', 'Toamasina', 'Malagasy', 1, 180, 77, 9, '+261 34 44 444 44', '2023-01-10'),
(1, 2, 1, 'Ramanana', 'Thomas', '1996-09-17', 'Mahajanga', 'Malagasy', 1, 182, 79, 5, '+261 34 55 555 55', '2023-01-10');

-- Insertion d'une séance d'entraînement
INSERT INTO Seance (
    idClub, idTypeSeance, dateSeance, heureDebut, heureFin, lieu, objectif, idStatutSeance
) VALUES (
    1, 1, '2023-11-15', '15:00:00', '17:00:00', 'Stade Municipal', 'Travail technique et physique', 2
)
RETURNING idSeance;

-- Insertion d'un match officiel (en utilisant l'ID de séance retourné précédemment)
INSERT INTO MatchFoot (
    idSeance, competition, adversaire, domicile, scoreEquipe, scoreAdversaire
) VALUES (
    1, 'Championnat National', 'AS Adema', TRUE, 2, 1
)
RETURNING idMatch;

-- Insertion des présences pour les 5 joueurs à la séance
INSERT INTO Presence (idSeance, idJoueur, idStatutPresence, heureArrivee) VALUES
(1, 1, 1, '14:45:00'), -- Rakoto Jean (Présent)
(1, 2, 1, '14:50:00'), -- Rabe Paul (Présent)
(1, 3, 3, '15:15:00'), -- Randria Pierre (Retard)
(1, 4, 1, '14:55:00'), -- Rasoa Jacques (Présent)
(1, 5, 2, NULL);       -- Ramanana Thomas (Absent)

-- Insertion de la composition pour le match
INSERT INTO Composition (idMatch, idJoueur, idStatutComposition, numeroMaillot, isCapitaine) VALUES
(1, 1, 1, 1, FALSE),  -- Rakoto Jean (Titulaire)
(1, 2, 1, 4, TRUE),   -- Rabe Paul (Titulaire et capitaine)
(1, 3, 2, 8, FALSE),  -- Randria Pierre (Remplaçant)
(1, 4, 1, 9, FALSE),  -- Rasoa Jacques (Titulaire)
(1, 5, 3, 5, FALSE);  -- Ramanana Thomas (Blessé)

-- Insertion d'une deuxième séance (match amical)
INSERT INTO Seance (
    idClub, idTypeSeance, dateSeance, heureDebut, heureFin, lieu, objectif, idStatutSeance
) VALUES (
    1, 2, '2023-11-20', '16:00:00', '18:00:00', 'Stade Municipal', 'Match de préparation', 2
)
RETURNING idSeance;

-- Insertion du match amical
INSERT INTO MatchFoot (
    idSeance, competition, adversaire, domicile, scoreEquipe, scoreAdversaire
) VALUES (
    2, 'Match amical', 'Dynamique FC', FALSE, 1, 1
)
RETURNING idMatch;

-- Insertion des présences pour la deuxième séance
INSERT INTO Presence (idSeance, idJoueur, idStatutPresence, heureArrivee) VALUES
(2, 1, 1, '15:45:00'),
(2, 2, 1, '15:50:00'),
(2, 3, 1, '15:55:00'),
(2, 4, 4, NULL),      -- Excusé
(2, 5, 2, NULL);      -- Absent

-- Insertion de la composition pour le match amical
INSERT INTO Composition (idMatch, idJoueur, idStatutComposition, numeroMaillot, isCapitaine) VALUES
(2, 1, 1, 1, FALSE),
(2, 2, 1, 4, TRUE),
(2, 3, 1, 8, FALSE),
(2, 4, 4, 9, FALSE),  -- Suspendu
(2, 5, 3, 5, FALSE);  -- Blessé