-- 1. Créer la base de données
CREATE DATABASE fanamby_presence;

-- 2. Créer l'utilisateur
CREATE USER fanamby WITH PASSWORD 'fanamby';

-- 3. Donner tous les privilèges à l'utilisateur sur la base
GRANT ALL PRIVILEGES ON DATABASE fanamby_presence TO fanamby;

\c fanamby_presence;

GRANT ALL PRIVILEGES ON SCHEMA public TO fanamby;

-- ###########################
-- ## TABLES D'ÉNUMÉRATION ##
-- ###########################

-- Poste
CREATE TABLE Poste (
    idPoste SERIAL PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255)
);

INSERT INTO Poste (libelle, description) VALUES 
('Gardien', 'Joueur protégeant les buts'),
('Defenseur', 'Joueur en défense'),
('Milieu', 'Joueur au milieu de terrain'),
('Attaquant', 'Joueur en attaque');

-- Type de Séance
CREATE TABLE TypeSeance (
    idTypeSeance SERIAL PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255)
);

INSERT INTO TypeSeance (libelle, description) VALUES 
('Entrainement', 'Séance d entraînement régulière'),
('Match amical', 'Match sans enjeu compétitif'),
('Match officiel', 'Match de championnat ou coupe'),
('Seance physique', 'Séance axée sur la condition physique'),
('Seance tactique', 'Séance axée sur la tactique d équipe');

-- Statut Présence
CREATE TABLE StatutPresence (
    idStatutPresence SERIAL PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL UNIQUE,
    code VARCHAR(10) NOT NULL UNIQUE
);

INSERT INTO StatutPresence (libelle, code) VALUES 
('Present', 'P'),
('Absent', 'A'),
('Retard', 'R'),
('Excusé', 'E');

-- Statut Joueur
CREATE TABLE StatutJoueur (
    idStatutJoueur SERIAL PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL UNIQUE,
    peutJouer BOOLEAN NOT NULL DEFAULT TRUE
);

INSERT INTO StatutJoueur (libelle, peutJouer) VALUES 
('Actif', TRUE),
('Blesse', FALSE),
('Suspendu', FALSE),
('Inactif', FALSE),
('En convalescence', FALSE);

-- Niveau Arbitre
CREATE TABLE NiveauArbitre (
    idNiveauArbitre SERIAL PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL UNIQUE
);

INSERT INTO NiveauArbitre (libelle) VALUES 
('Federal'), ('Regional'), ('Departemental'), ('Jeune');

-- Niveau Match
CREATE TABLE NiveauMatch (
    idNiveauMatch SERIAL PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL UNIQUE
);

INSERT INTO NiveauMatch (libelle) VALUES 
('Regional'), ('Departemental'), ('Ligue'), ('National');

-- Pied Fort
CREATE TABLE PiedFort (
    idPiedFort SERIAL PRIMARY KEY,
    libelle VARCHAR(20) NOT NULL UNIQUE
);

INSERT INTO PiedFort (libelle) VALUES 
('Droit'), ('Gauche'), ('Ambidextre');

-- Statut Séance
CREATE TABLE StatutSeance (
    idStatutSeance SERIAL PRIMARY KEY,
    libelle VARCHAR(20) NOT NULL UNIQUE
);

INSERT INTO StatutSeance (libelle) VALUES 
('Planifie'), ('Realise'), ('Annule');

-- Statut Composition
CREATE TABLE StatutComposition (
    idStatutComposition SERIAL PRIMARY KEY,
    libelle VARCHAR(20) NOT NULL UNIQUE
);

INSERT INTO StatutComposition (libelle) VALUES 
('Titulaire'), ('Remplacant'), ('Blesse'), ('Suspendu'), ('Autre');

-- ###########################
-- ## TABLES PRINCIPALES ##
-- ###########################

-- Club
CREATE TABLE Club (
    idClub SERIAL PRIMARY KEY,
    nomClub VARCHAR(100) NOT NULL,
    ville VARCHAR(50) NOT NULL,
    dateCreation DATE,
    couleurs VARCHAR(50),
    logo VARCHAR(255),
    email VARCHAR(100) UNIQUE NOT NULL,
    motDePasse VARCHAR(255) NOT NULL,
    telephone VARCHAR(20),
    adresse TEXT,
    president VARCHAR(100),
    dateFondation INTEGER,
    stadePrincipal VARCHAR(100),
    siteWeb VARCHAR(255),
    CONSTRAINT chk_email CHECK (email ~* '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$')
);

-- Arbitre
CREATE TABLE Arbitre (
    idArbitre SERIAL PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    prenom VARCHAR(50) NOT NULL,
    dateNaissance DATE,
    licence VARCHAR(50) UNIQUE,
    idNiveauArbitre INT NOT NULL,
    telephone VARCHAR(20),
    email VARCHAR(100),
    dateDebutArbitrage DATE,
    matchesDiriges INT DEFAULT 0,
    FOREIGN KEY (idNiveauArbitre) REFERENCES NiveauArbitre(idNiveauArbitre),
    CONSTRAINT unq_arbitre UNIQUE (nom, prenom, dateNaissance)
);

-- Arbitrage
CREATE TABLE Arbitrage (
    idArbitrage SERIAL PRIMARY KEY,
    idArbitrePrincipal INT NOT NULL,
    idArbitreAssistant1 INT,
    idArbitreAssistant2 INT,
    idDelegue INT,
    dateCertification DATE,
    idNiveauMatch INT NOT NULL,
    FOREIGN KEY (idNiveauMatch) REFERENCES NiveauMatch(idNiveauMatch),
    FOREIGN KEY (idArbitrePrincipal) REFERENCES Arbitre(idArbitre),
    FOREIGN KEY (idArbitreAssistant1) REFERENCES Arbitre(idArbitre),
    FOREIGN KEY (idArbitreAssistant2) REFERENCES Arbitre(idArbitre)
);

-- Joueur
CREATE TABLE Joueur (
    idJoueur SERIAL PRIMARY KEY,
    idClub INT NOT NULL,
    idPoste INT NOT NULL,
    idStatutJoueur INT NOT NULL DEFAULT 1,
    nom VARCHAR(50) NOT NULL,
    prenom VARCHAR(50) NOT NULL,
    dateNaissance DATE NOT NULL,
    lieuNaissance VARCHAR(100),
    nationalite VARCHAR(50),
    idPiedFort INT NOT NULL,
    taille INT CHECK (taille BETWEEN 100 AND 250),
    poids INT CHECK (poids BETWEEN 30 AND 150),
    photo VARCHAR(255),
    numeroMaillot INT CHECK (numeroMaillot BETWEEN 1 AND 99),
    telephone VARCHAR(20),
    email VARCHAR(100),
    nomPere VARCHAR(100),
    nomMere VARCHAR(100),
    telParent VARCHAR(20),
    certificatMedical VARCHAR(255),
    dateValiditeCertificat DATE,
    numeroLicence VARCHAR(50) UNIQUE,
    dateInscription DATE NOT NULL,
    FOREIGN KEY (idClub) REFERENCES Club(idClub),
    FOREIGN KEY (idPoste) REFERENCES Poste(idPoste),
    FOREIGN KEY (idStatutJoueur) REFERENCES StatutJoueur(idStatutJoueur),
    FOREIGN KEY (idPiedFort) REFERENCES PiedFort(idPiedFort),
    CONSTRAINT chk_email_joueur CHECK (email IS NULL OR email ~* '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$'),
    CONSTRAINT chk_date_certificat CHECK (dateValiditeCertificat IS NULL OR dateValiditeCertificat >= CURRENT_DATE)
);

-- Seance
CREATE TABLE Seance (
    idSeance SERIAL PRIMARY KEY,
    idClub INT NOT NULL,
    idTypeSeance INT NOT NULL,
    dateSeance DATE NOT NULL,
    heureDebut TIME NOT NULL,
    heureFin TIME NOT NULL,
    lieu VARCHAR(100) NOT NULL,
    objectif TEXT,
    bilan TEXT,
    idStatutSeance INT DEFAULT 1,
    FOREIGN KEY (idClub) REFERENCES Club(idClub),
    FOREIGN KEY (idTypeSeance) REFERENCES TypeSeance(idTypeSeance),
    FOREIGN KEY (idStatutSeance) REFERENCES StatutSeance(idStatutSeance),
    CONSTRAINT chk_heure_seance CHECK (heureFin > heureDebut)
);

-- Presence
CREATE TABLE Presence (
    idPresence SERIAL PRIMARY KEY,
    idSeance INT NOT NULL,
    idJoueur INT NOT NULL,
    idStatutPresence INT NOT NULL,
    motifAbsence VARCHAR(255),
    signature VARCHAR(255),
    heureArrivee TIME,
    commentaires TEXT,
    FOREIGN KEY (idSeance) REFERENCES Seance(idSeance),
    FOREIGN KEY (idJoueur) REFERENCES Joueur(idJoueur),
    FOREIGN KEY (idStatutPresence) REFERENCES StatutPresence(idStatutPresence),
    CONSTRAINT unq_presence UNIQUE (idSeance, idJoueur)
);

-- MatchFoot
CREATE TABLE MatchFoot (
    idMatch SERIAL PRIMARY KEY,
    idSeance INT NOT NULL,
    idArbitrage INT,
    competition VARCHAR(100),
    adversaire VARCHAR(100) NOT NULL,
    domicile BOOLEAN DEFAULT TRUE,
    scoreEquipe INT CHECK (scoreEquipe >= 0),
    scoreAdversaire INT CHECK (scoreAdversaire >= 0),
    tempsAdditionnel1 INT DEFAULT 0,
    tempsAdditionnel2 INT DEFAULT 0,
    public INT,
    incidents TEXT,
    observations TEXT,
    FOREIGN KEY (idSeance) REFERENCES Seance(idSeance),
    FOREIGN KEY (idArbitrage) REFERENCES Arbitrage(idArbitrage),
    CONSTRAINT chk_temps_additionnel CHECK (tempsAdditionnel1 >= 0 AND tempsAdditionnel2 >= 0)
);

-- Composition
CREATE TABLE Composition (
    idComposition SERIAL PRIMARY KEY,
    idMatch INT NOT NULL,
    idJoueur INT NOT NULL,
    idStatutComposition INT NOT NULL,
    numeroMaillot INT CHECK (numeroMaillot BETWEEN 1 AND 99),
    position VARCHAR(50),
    commentaire TEXT,
    isCapitaine BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (idMatch) REFERENCES MatchFoot(idMatch),
    FOREIGN KEY (idJoueur) REFERENCES Joueur(idJoueur),
    FOREIGN KEY (idStatutComposition) REFERENCES StatutComposition(idStatutComposition),
    CONSTRAINT unq_composition UNIQUE (idMatch, idJoueur)
);

