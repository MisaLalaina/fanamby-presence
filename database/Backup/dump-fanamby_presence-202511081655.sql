--
-- PostgreSQL database dump
--

-- Dumped from database version 17.2
-- Dumped by pg_dump version 17.2

-- Started on 2025-11-08 16:55:27

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 236 (class 1259 OID 116125)
-- Name: club; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.club (
    idclub integer NOT NULL,
    nomclub character varying(100) NOT NULL,
    ville character varying(50) NOT NULL,
    datecreation date,
    couleurs character varying(50),
    logo character varying(255),
    email character varying(100) NOT NULL,
    motdepasse character varying(255) NOT NULL,
    telephone character varying(20),
    adresse text,
    president character varying(100),
    datefondation integer,
    stadeprincipal character varying(100),
    siteweb character varying(255),
    CONSTRAINT chk_email CHECK (((email)::text ~* '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$'::text))
);


ALTER TABLE public.club OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 116124)
-- Name: club_idclub_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.club_idclub_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.club_idclub_seq OWNER TO postgres;

--
-- TOC entry 5050 (class 0 OID 0)
-- Dependencies: 235
-- Name: club_idclub_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.club_idclub_seq OWNED BY public.club.idclub;


--
-- TOC entry 246 (class 1259 OID 116251)
-- Name: composition; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.composition (
    idcomposition integer NOT NULL,
    idmatch integer NOT NULL,
    idjoueur integer NOT NULL,
    idstatutcomposition integer NOT NULL,
    numeromaillot integer,
    "position" character varying(50),
    commentaire text,
    iscapitaine boolean DEFAULT false,
    CONSTRAINT composition_numeromaillot_check CHECK (((numeromaillot >= 1) AND (numeromaillot <= 99)))
);


ALTER TABLE public.composition OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 116250)
-- Name: composition_idcomposition_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.composition_idcomposition_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.composition_idcomposition_seq OWNER TO postgres;

--
-- TOC entry 5051 (class 0 OID 0)
-- Dependencies: 245
-- Name: composition_idcomposition_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.composition_idcomposition_seq OWNED BY public.composition.idcomposition;


--
-- TOC entry 238 (class 1259 OID 116137)
-- Name: joueur; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.joueur (
    idjoueur integer NOT NULL,
    idclub integer NOT NULL,
    idposte integer NOT NULL,
    idstatutjoueur integer DEFAULT 1 NOT NULL,
    nom character varying(50) NOT NULL,
    prenom character varying(50) NOT NULL,
    datenaissance date NOT NULL,
    lieunaissance character varying(100),
    nationalite character varying(50),
    idpiedfort integer NOT NULL,
    taille integer,
    poids integer,
    photo character varying(255),
    numeromaillot integer,
    telephone character varying(20),
    email character varying(100),
    nompere character varying(100),
    nommere character varying(100),
    telparent character varying(20),
    certificatmedical character varying(255),
    datevaliditecertificat date,
    numerolicence character varying(50),
    dateinscription date NOT NULL,
    datequitter date,
    CONSTRAINT chk_date_certificat CHECK (((datevaliditecertificat IS NULL) OR (datevaliditecertificat >= CURRENT_DATE))),
    CONSTRAINT chk_email_joueur CHECK (((email IS NULL) OR ((email)::text ~* '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$'::text))),
    CONSTRAINT joueur_numeromaillot_check CHECK (((numeromaillot >= 1) AND (numeromaillot <= 99))),
    CONSTRAINT joueur_poids_check CHECK (((poids >= 30) AND (poids <= 150))),
    CONSTRAINT joueur_taille_check CHECK (((taille >= 100) AND (taille <= 250)))
);


ALTER TABLE public.joueur OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 116098)
-- Name: piedfort; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.piedfort (
    idpiedfort integer NOT NULL,
    libelle character varying(20) NOT NULL
);


ALTER TABLE public.piedfort OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 116041)
-- Name: poste; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.poste (
    idposte integer NOT NULL,
    libelle character varying(50) NOT NULL,
    description character varying(255)
);


ALTER TABLE public.poste OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 116079)
-- Name: statutjoueur; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.statutjoueur (
    idstatutjoueur integer NOT NULL,
    libelle character varying(50) NOT NULL,
    peutjouer boolean DEFAULT true NOT NULL
);


ALTER TABLE public.statutjoueur OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 116293)
-- Name: joueur_cpl; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.joueur_cpl AS
 SELECT j.idjoueur,
    j.idclub,
    j.idposte,
    j.idstatutjoueur,
    j.nom,
    j.prenom,
    j.datenaissance,
    j.lieunaissance,
    j.nationalite,
    j.idpiedfort,
    j.taille,
    j.poids,
    j.photo,
    j.numeromaillot,
    j.telephone,
    j.email,
    j.nompere,
    j.nommere,
    j.telparent,
    j.certificatmedical,
    j.datevaliditecertificat,
    j.numerolicence,
    j.dateinscription,
    c.nomclub,
    p.libelle AS nomposte,
    sj.libelle AS statusjoueur,
    sj.peutjouer,
    pf.libelle AS piedfort
   FROM ((((public.joueur j
     JOIN public.club c ON ((j.idclub = c.idclub)))
     JOIN public.poste p ON ((j.idposte = p.idposte)))
     JOIN public.statutjoueur sj ON ((j.idstatutjoueur = sj.idstatutjoueur)))
     JOIN public.piedfort pf ON ((j.idpiedfort = pf.idpiedfort)));


ALTER VIEW public.joueur_cpl OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 116136)
-- Name: joueur_idjoueur_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.joueur_idjoueur_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.joueur_idjoueur_seq OWNER TO postgres;

--
-- TOC entry 5052 (class 0 OID 0)
-- Dependencies: 237
-- Name: joueur_idjoueur_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.joueur_idjoueur_seq OWNED BY public.joueur.idjoueur;


--
-- TOC entry 244 (class 1259 OID 116226)
-- Name: matchfoot; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.matchfoot (
    idmatch integer NOT NULL,
    idseance integer NOT NULL,
    idtypematch integer NOT NULL,
    competition character varying(100),
    adversaire character varying(100) NOT NULL,
    domicile boolean DEFAULT true,
    scoreequipe integer,
    scoreadversaire integer,
    tempsadditionnel1 integer DEFAULT 0,
    tempsadditionnel2 integer DEFAULT 0,
    incidents text,
    observations text,
    CONSTRAINT chk_temps_additionnel CHECK (((tempsadditionnel1 >= 0) AND (tempsadditionnel2 >= 0))),
    CONSTRAINT matchfoot_scoreadversaire_check CHECK ((scoreadversaire >= 0)),
    CONSTRAINT matchfoot_scoreequipe_check CHECK ((scoreequipe >= 0))
);


ALTER TABLE public.matchfoot OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 116225)
-- Name: matchfoot_idmatch_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.matchfoot_idmatch_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.matchfoot_idmatch_seq OWNER TO postgres;

--
-- TOC entry 5053 (class 0 OID 0)
-- Dependencies: 243
-- Name: matchfoot_idmatch_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.matchfoot_idmatch_seq OWNED BY public.matchfoot.idmatch;


--
-- TOC entry 228 (class 1259 OID 116089)
-- Name: niveaumatch; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.niveaumatch (
    idniveaumatch integer NOT NULL,
    libelle character varying(50) NOT NULL
);


ALTER TABLE public.niveaumatch OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 116088)
-- Name: niveaumatch_idniveaumatch_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.niveaumatch_idniveaumatch_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.niveaumatch_idniveaumatch_seq OWNER TO postgres;

--
-- TOC entry 5054 (class 0 OID 0)
-- Dependencies: 227
-- Name: niveaumatch_idniveaumatch_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.niveaumatch_idniveaumatch_seq OWNED BY public.niveaumatch.idniveaumatch;


--
-- TOC entry 229 (class 1259 OID 116097)
-- Name: piedfort_idpiedfort_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.piedfort_idpiedfort_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.piedfort_idpiedfort_seq OWNER TO postgres;

--
-- TOC entry 5055 (class 0 OID 0)
-- Dependencies: 229
-- Name: piedfort_idpiedfort_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.piedfort_idpiedfort_seq OWNED BY public.piedfort.idpiedfort;


--
-- TOC entry 217 (class 1259 OID 116040)
-- Name: poste_idposte_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.poste_idposte_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.poste_idposte_seq OWNER TO postgres;

--
-- TOC entry 5056 (class 0 OID 0)
-- Dependencies: 217
-- Name: poste_idposte_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.poste_idposte_seq OWNED BY public.poste.idposte;


--
-- TOC entry 242 (class 1259 OID 116200)
-- Name: presence; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.presence (
    idpresence integer NOT NULL,
    idseance integer NOT NULL,
    idjoueur integer NOT NULL,
    idstatutpresence integer NOT NULL,
    motifabsence character varying(255),
    signature character varying(255),
    heurearrivee time without time zone,
    commentaires text
);


ALTER TABLE public.presence OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 116174)
-- Name: seance; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.seance (
    idseance integer NOT NULL,
    idclub integer,
    idtypeseance integer,
    dateseance date NOT NULL,
    heuredebut time without time zone NOT NULL,
    heurefin time without time zone NOT NULL,
    lieu character varying(100) NOT NULL,
    objectif text,
    bilan text,
    idstatutseance integer DEFAULT 1
);


ALTER TABLE public.seance OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 116107)
-- Name: statutseance; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.statutseance (
    idstatutseance integer NOT NULL,
    libelle character varying(20) NOT NULL
);


ALTER TABLE public.statutseance OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 116050)
-- Name: typeseance; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.typeseance (
    idtypeseance integer NOT NULL,
    libelle character varying(50) NOT NULL,
    description character varying(255)
);


ALTER TABLE public.typeseance OWNER TO postgres;

--
-- TOC entry 248 (class 1259 OID 116298)
-- Name: seance_cpl; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.seance_cpl AS
 SELECT s.idseance,
    s.idclub,
    s.idtypeseance,
    s.dateseance,
    s.heuredebut,
    s.heurefin,
    s.lieu,
    s.objectif,
    s.bilan,
    s.idstatutseance,
    c.nomclub,
    ts.libelle AS typeseance,
    ss.libelle AS statutseance
   FROM (((public.seance s
     JOIN public.club c ON ((s.idclub = c.idclub)))
     JOIN public.typeseance ts ON ((ts.idtypeseance = s.idtypeseance)))
     JOIN public.statutseance ss ON ((ss.idstatutseance = s.idstatutseance)));


ALTER VIEW public.seance_cpl OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 116068)
-- Name: statutpresence; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.statutpresence (
    idstatutpresence integer NOT NULL,
    libelle character varying(50) NOT NULL,
    code character varying(10) NOT NULL
);


ALTER TABLE public.statutpresence OWNER TO postgres;

--
-- TOC entry 249 (class 1259 OID 116303)
-- Name: presence_cpl; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.presence_cpl AS
 SELECT pres.idpresence,
    pres.idseance,
    pres.idjoueur,
    pres.idstatutpresence,
    pres.motifabsence,
    pres.signature,
    pres.heurearrivee,
    pres.commentaires,
    sp.libelle AS statutpresence,
    s.idclub,
    s.nomclub,
    s.idtypeseance,
    s.typeseance,
    s.idstatutseance,
    s.statutseance
   FROM ((public.presence pres
     LEFT JOIN public.seance_cpl s ON ((pres.idseance = s.idseance)))
     LEFT JOIN public.statutpresence sp ON ((pres.idstatutpresence = sp.idstatutpresence)));


ALTER VIEW public.presence_cpl OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 116199)
-- Name: presence_idpresence_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.presence_idpresence_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.presence_idpresence_seq OWNER TO postgres;

--
-- TOC entry 5057 (class 0 OID 0)
-- Dependencies: 241
-- Name: presence_idpresence_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.presence_idpresence_seq OWNED BY public.presence.idpresence;


--
-- TOC entry 239 (class 1259 OID 116173)
-- Name: seance_idseance_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seance_idseance_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seance_idseance_seq OWNER TO postgres;

--
-- TOC entry 5058 (class 0 OID 0)
-- Dependencies: 239
-- Name: seance_idseance_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.seance_idseance_seq OWNED BY public.seance.idseance;


--
-- TOC entry 250 (class 1259 OID 116308)
-- Name: v_presence_entrainement; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_presence_entrainement AS
 SELECT jc.idjoueur,
    jc.nom,
    jc.prenom,
    jc.numeromaillot,
    jc.nomposte,
    pc.idstatutpresence,
    pc.statutpresence,
    sca.idseance,
    sca.idclub,
    sca.idtypeseance,
    sca.dateseance,
    sca.heuredebut,
    sca.heurefin,
    sca.lieu,
    sca.objectif,
    sca.bilan,
    sca.idstatutseance,
    sca.nomclub,
    sca.typeseance,
    sca.statutseance,
    sca.annee,
    sca.mois,
    sca.annee_mois
   FROM ((public.joueur_cpl jc
     JOIN public.presence_cpl pc ON ((pc.idjoueur = jc.idjoueur)))
     JOIN ( SELECT sc.idseance,
            sc.idclub,
            sc.idtypeseance,
            sc.dateseance,
            sc.heuredebut,
            sc.heurefin,
            sc.lieu,
            sc.objectif,
            sc.bilan,
            sc.idstatutseance,
            sc.nomclub,
            sc.typeseance,
            sc.statutseance,
            EXTRACT(year FROM sc.dateseance) AS annee,
            EXTRACT(month FROM sc.dateseance) AS mois,
            to_char((sc.dateseance)::timestamp with time zone, 'YYYY-MM'::text) AS annee_mois
           FROM public.seance_cpl sc
          WHERE ((sc.dateseance <= CURRENT_DATE) AND (sc.idstatutseance = 2) AND (sc.idtypeseance = 1))) sca ON ((sca.idseance = pc.idseance)));


ALTER VIEW public.v_presence_entrainement OWNER TO postgres;

--
-- TOC entry 251 (class 1259 OID 116313)
-- Name: v_presence_match; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_presence_match AS
 SELECT jc.idjoueur,
    jc.nom,
    jc.prenom,
    jc.numeromaillot,
    jc.nomposte,
    pc.idstatutpresence,
    pc.statutpresence,
    sca.idseance,
    sca.idclub,
    sca.idtypeseance,
    sca.dateseance,
    sca.heuredebut,
    sca.heurefin,
    sca.lieu,
    sca.objectif,
    sca.bilan,
    sca.idstatutseance,
    sca.nomclub,
    sca.typeseance,
    sca.statutseance,
    sca.annee,
    sca.mois,
    sca.annee_mois
   FROM ((public.joueur_cpl jc
     JOIN public.presence_cpl pc ON ((pc.idjoueur = jc.idjoueur)))
     JOIN ( SELECT sc.idseance,
            sc.idclub,
            sc.idtypeseance,
            sc.dateseance,
            sc.heuredebut,
            sc.heurefin,
            sc.lieu,
            sc.objectif,
            sc.bilan,
            sc.idstatutseance,
            sc.nomclub,
            sc.typeseance,
            sc.statutseance,
            EXTRACT(year FROM sc.dateseance) AS annee,
            EXTRACT(month FROM sc.dateseance) AS mois,
            to_char((sc.dateseance)::timestamp with time zone, 'YYYY-MM'::text) AS annee_mois
           FROM public.seance_cpl sc
          WHERE ((sc.dateseance <= CURRENT_DATE) AND (sc.idstatutseance = 2) AND (sc.idtypeseance = 2))) sca ON ((sca.idseance = pc.idseance)));


ALTER VIEW public.v_presence_match OWNER TO postgres;

--
-- TOC entry 252 (class 1259 OID 116318)
-- Name: v_presence_joueurs_generale; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_presence_joueurs_generale AS
 SELECT v_presence_entrainement.idjoueur,
    v_presence_entrainement.nom,
    v_presence_entrainement.prenom,
    v_presence_entrainement.numeromaillot,
    v_presence_entrainement.nomposte,
    v_presence_entrainement.idstatutpresence,
    v_presence_entrainement.statutpresence,
    v_presence_entrainement.idseance,
    v_presence_entrainement.idclub,
    v_presence_entrainement.idtypeseance,
    v_presence_entrainement.dateseance,
    v_presence_entrainement.heuredebut,
    v_presence_entrainement.heurefin,
    v_presence_entrainement.lieu,
    v_presence_entrainement.objectif,
    v_presence_entrainement.bilan,
    v_presence_entrainement.idstatutseance,
    v_presence_entrainement.nomclub,
    v_presence_entrainement.typeseance,
    v_presence_entrainement.statutseance,
    v_presence_entrainement.annee,
    v_presence_entrainement.mois,
    v_presence_entrainement.annee_mois
   FROM public.v_presence_entrainement
UNION ALL
 SELECT v_presence_match.idjoueur,
    v_presence_match.nom,
    v_presence_match.prenom,
    v_presence_match.numeromaillot,
    v_presence_match.nomposte,
    v_presence_match.idstatutpresence,
    v_presence_match.statutpresence,
    v_presence_match.idseance,
    v_presence_match.idclub,
    v_presence_match.idtypeseance,
    v_presence_match.dateseance,
    v_presence_match.heuredebut,
    v_presence_match.heurefin,
    v_presence_match.lieu,
    v_presence_match.objectif,
    v_presence_match.bilan,
    v_presence_match.idstatutseance,
    v_presence_match.nomclub,
    v_presence_match.typeseance,
    v_presence_match.statutseance,
    v_presence_match.annee,
    v_presence_match.mois,
    v_presence_match.annee_mois
   FROM public.v_presence_match;


ALTER VIEW public.v_presence_joueurs_generale OWNER TO postgres;

--
-- TOC entry 253 (class 1259 OID 116323)
-- Name: stat_presence_joueur; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.stat_presence_joueur AS
 SELECT idjoueur,
    nom,
    prenom,
    sum(
        CASE
            WHEN ((statutpresence)::text = 'Present'::text) THEN 1
            ELSE 0
        END) AS totalpresences,
    sum(
        CASE
            WHEN ((statutpresence)::text = 'Absent'::text) THEN 1
            ELSE 0
        END) AS totalabsences,
    sum(
        CASE
            WHEN ((idtypeseance = 1) AND ((statutpresence)::text = 'Present'::text)) THEN 1
            ELSE 0
        END) AS entpresences,
    sum(
        CASE
            WHEN ((idtypeseance = 1) AND ((statutpresence)::text = 'Absent'::text)) THEN 1
            ELSE 0
        END) AS entabsences,
    sum(
        CASE
            WHEN ((idtypeseance = 2) AND ((statutpresence)::text = 'Present'::text)) THEN 1
            ELSE 0
        END) AS matpresences,
    sum(
        CASE
            WHEN ((idtypeseance = 2) AND ((statutpresence)::text = 'Absent'::text)) THEN 1
            ELSE 0
        END) AS matabsences
   FROM public.v_presence_joueurs_generale vpe
  GROUP BY idjoueur, nom, prenom;


ALTER VIEW public.stat_presence_joueur OWNER TO postgres;

--
-- TOC entry 254 (class 1259 OID 118335)
-- Name: stat_seance_globale; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.stat_seance_globale AS
 SELECT t.idtypeseance,
    t.libelle AS typeseance,
    count(sc.idseance) AS nbseance,
    (avg(((NULLIF(present.nbpresences, 0))::numeric / (NULLIF(total.nbjoueurs, 0))::numeric)) * (100)::numeric) AS taux
   FROM (((public.typeseance t
     FULL JOIN ( SELECT s.idseance,
            s.idclub,
            s.idtypeseance,
            s.dateseance,
            s.heuredebut,
            s.heurefin,
            s.lieu,
            s.objectif,
            s.bilan,
            s.idstatutseance,
            s.nomclub,
            s.typeseance,
            s.statutseance
           FROM public.seance_cpl s
          WHERE (s.idstatutseance = 2)) sc ON ((t.idtypeseance = sc.idtypeseance)))
     LEFT JOIN ( SELECT presence_cpl.idseance,
            count(*) AS nbpresences
           FROM public.presence_cpl
          WHERE ((presence_cpl.statutpresence)::text = 'Present'::text)
          GROUP BY presence_cpl.idseance) present ON ((present.idseance = sc.idseance)))
     LEFT JOIN ( SELECT presence_cpl.idseance,
            count(*) AS nbjoueurs
           FROM public.presence_cpl
          GROUP BY presence_cpl.idseance) total ON ((total.idseance = sc.idseance)))
  GROUP BY t.idtypeseance, t.libelle;


ALTER VIEW public.stat_seance_globale OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 116116)
-- Name: statutcomposition; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.statutcomposition (
    idstatutcomposition integer NOT NULL,
    libelle character varying(20) NOT NULL
);


ALTER TABLE public.statutcomposition OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 116115)
-- Name: statutcomposition_idstatutcomposition_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.statutcomposition_idstatutcomposition_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.statutcomposition_idstatutcomposition_seq OWNER TO postgres;

--
-- TOC entry 5059 (class 0 OID 0)
-- Dependencies: 233
-- Name: statutcomposition_idstatutcomposition_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.statutcomposition_idstatutcomposition_seq OWNED BY public.statutcomposition.idstatutcomposition;


--
-- TOC entry 225 (class 1259 OID 116078)
-- Name: statutjoueur_idstatutjoueur_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.statutjoueur_idstatutjoueur_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.statutjoueur_idstatutjoueur_seq OWNER TO postgres;

--
-- TOC entry 5060 (class 0 OID 0)
-- Dependencies: 225
-- Name: statutjoueur_idstatutjoueur_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.statutjoueur_idstatutjoueur_seq OWNED BY public.statutjoueur.idstatutjoueur;


--
-- TOC entry 223 (class 1259 OID 116067)
-- Name: statutpresence_idstatutpresence_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.statutpresence_idstatutpresence_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.statutpresence_idstatutpresence_seq OWNER TO postgres;

--
-- TOC entry 5061 (class 0 OID 0)
-- Dependencies: 223
-- Name: statutpresence_idstatutpresence_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.statutpresence_idstatutpresence_seq OWNED BY public.statutpresence.idstatutpresence;


--
-- TOC entry 231 (class 1259 OID 116106)
-- Name: statutseance_idstatutseance_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.statutseance_idstatutseance_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.statutseance_idstatutseance_seq OWNER TO postgres;

--
-- TOC entry 5062 (class 0 OID 0)
-- Dependencies: 231
-- Name: statutseance_idstatutseance_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.statutseance_idstatutseance_seq OWNED BY public.statutseance.idstatutseance;


--
-- TOC entry 222 (class 1259 OID 116059)
-- Name: typematch; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.typematch (
    idtypematch integer NOT NULL,
    libelle character varying(50) NOT NULL,
    description character varying(255)
);


ALTER TABLE public.typematch OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 116058)
-- Name: typematch_idtypematch_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.typematch_idtypematch_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.typematch_idtypematch_seq OWNER TO postgres;

--
-- TOC entry 5063 (class 0 OID 0)
-- Dependencies: 221
-- Name: typematch_idtypematch_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.typematch_idtypematch_seq OWNED BY public.typematch.idtypematch;


--
-- TOC entry 219 (class 1259 OID 116049)
-- Name: typeseance_idtypeseance_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.typeseance_idtypeseance_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.typeseance_idtypeseance_seq OWNER TO postgres;

--
-- TOC entry 5064 (class 0 OID 0)
-- Dependencies: 219
-- Name: typeseance_idtypeseance_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.typeseance_idtypeseance_seq OWNED BY public.typeseance.idtypeseance;


--
-- TOC entry 4753 (class 2604 OID 116128)
-- Name: club idclub; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.club ALTER COLUMN idclub SET DEFAULT nextval('public.club_idclub_seq'::regclass);


--
-- TOC entry 4763 (class 2604 OID 116254)
-- Name: composition idcomposition; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.composition ALTER COLUMN idcomposition SET DEFAULT nextval('public.composition_idcomposition_seq'::regclass);


--
-- TOC entry 4754 (class 2604 OID 116140)
-- Name: joueur idjoueur; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.joueur ALTER COLUMN idjoueur SET DEFAULT nextval('public.joueur_idjoueur_seq'::regclass);


--
-- TOC entry 4759 (class 2604 OID 116229)
-- Name: matchfoot idmatch; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matchfoot ALTER COLUMN idmatch SET DEFAULT nextval('public.matchfoot_idmatch_seq'::regclass);


--
-- TOC entry 4749 (class 2604 OID 116092)
-- Name: niveaumatch idniveaumatch; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.niveaumatch ALTER COLUMN idniveaumatch SET DEFAULT nextval('public.niveaumatch_idniveaumatch_seq'::regclass);


--
-- TOC entry 4750 (class 2604 OID 116101)
-- Name: piedfort idpiedfort; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.piedfort ALTER COLUMN idpiedfort SET DEFAULT nextval('public.piedfort_idpiedfort_seq'::regclass);


--
-- TOC entry 4743 (class 2604 OID 116044)
-- Name: poste idposte; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.poste ALTER COLUMN idposte SET DEFAULT nextval('public.poste_idposte_seq'::regclass);


--
-- TOC entry 4758 (class 2604 OID 116203)
-- Name: presence idpresence; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.presence ALTER COLUMN idpresence SET DEFAULT nextval('public.presence_idpresence_seq'::regclass);


--
-- TOC entry 4756 (class 2604 OID 116177)
-- Name: seance idseance; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seance ALTER COLUMN idseance SET DEFAULT nextval('public.seance_idseance_seq'::regclass);


--
-- TOC entry 4752 (class 2604 OID 116119)
-- Name: statutcomposition idstatutcomposition; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.statutcomposition ALTER COLUMN idstatutcomposition SET DEFAULT nextval('public.statutcomposition_idstatutcomposition_seq'::regclass);


--
-- TOC entry 4747 (class 2604 OID 116082)
-- Name: statutjoueur idstatutjoueur; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.statutjoueur ALTER COLUMN idstatutjoueur SET DEFAULT nextval('public.statutjoueur_idstatutjoueur_seq'::regclass);


--
-- TOC entry 4746 (class 2604 OID 116071)
-- Name: statutpresence idstatutpresence; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.statutpresence ALTER COLUMN idstatutpresence SET DEFAULT nextval('public.statutpresence_idstatutpresence_seq'::regclass);


--
-- TOC entry 4751 (class 2604 OID 116110)
-- Name: statutseance idstatutseance; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.statutseance ALTER COLUMN idstatutseance SET DEFAULT nextval('public.statutseance_idstatutseance_seq'::regclass);


--
-- TOC entry 4745 (class 2604 OID 116062)
-- Name: typematch idtypematch; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.typematch ALTER COLUMN idtypematch SET DEFAULT nextval('public.typematch_idtypematch_seq'::regclass);


--
-- TOC entry 4744 (class 2604 OID 116053)
-- Name: typeseance idtypeseance; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.typeseance ALTER COLUMN idtypeseance SET DEFAULT nextval('public.typeseance_idtypeseance_seq'::regclass);


--
-- TOC entry 5033 (class 0 OID 116125)
-- Dependencies: 236
-- Data for Name: club; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.club VALUES (1, 'Akademia Fanamby', 'Antananarivo', '2020-05-15', 'Rouge et Blanc', 'https://example.com/logo-akademia.png', 'contact@akademiafanamby.mg', '123456', '+261 34 12 345 67', 'Stade Municipal, Avenue de l Indépendance', 'Jean Rakotomalala', 2020, 'Stade Municipal de Mahamasina', 'https://akademiafanamby.mg');


--
-- TOC entry 5043 (class 0 OID 116251)
-- Dependencies: 246
-- Data for Name: composition; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.composition VALUES (19, 21, 41, 1, 13, NULL, '', false);
INSERT INTO public.composition VALUES (20, 21, 42, 1, 1, NULL, '', false);
INSERT INTO public.composition VALUES (21, 21, 20, 1, 15, NULL, '', false);
INSERT INTO public.composition VALUES (22, 21, 9, 1, 3, NULL, '', false);
INSERT INTO public.composition VALUES (23, 21, 27, 1, 6, NULL, '', false);
INSERT INTO public.composition VALUES (24, 21, 8, 1, 8, NULL, '', false);
INSERT INTO public.composition VALUES (25, 21, 19, 1, 21, NULL, '', false);
INSERT INTO public.composition VALUES (26, 21, 21, 1, 20, NULL, '', false);
INSERT INTO public.composition VALUES (27, 21, 23, 1, 11, NULL, '', false);
INSERT INTO public.composition VALUES (28, 21, 12, 2, 9, NULL, '', false);
INSERT INTO public.composition VALUES (29, 21, 14, 2, 19, NULL, '', false);
INSERT INTO public.composition VALUES (30, 21, 17, 2, 2, NULL, '', false);
INSERT INTO public.composition VALUES (31, 21, 15, 2, 48, NULL, '', false);
INSERT INTO public.composition VALUES (32, 21, 7, 2, 10, NULL, '', false);


--
-- TOC entry 5035 (class 0 OID 116137)
-- Dependencies: 238
-- Data for Name: joueur; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.joueur VALUES (8, 1, 3, 1, 'RANDRIANARISON ', 'Rico', '2015-10-29', '', 'Malagasy  ', 1, 150, 40, '', NULL, '', 'fanambyakademia@gmail.com', '', '', '', '', NULL, '', '2025-09-02', NULL);
INSERT INTO public.joueur VALUES (9, 1, 2, 1, 'FAZAVANA', 'Abdoul(Rwalhayck)', '2012-01-23', '', 'M', 1, 150, 36, '', NULL, '', 'fanambyakademia@gmail.com', '', '', '', '', NULL, '', '2025-09-02', NULL);
INSERT INTO public.joueur VALUES (10, 1, 2, 1, 'TOAVINIRIANA ', 'Ywanne Prosper', '2012-07-16', '', 'Malagasy  ', 1, 150, 35, '', NULL, '', 'fanambyakademia@gmail.com', '', '', '', '', NULL, '', '2025-09-02', NULL);
INSERT INTO public.joueur VALUES (13, 1, 4, 1, 'FAZAVANA', 'Abdou Kiffayattullah', '2016-10-15', '', 'Malagasy  ', 1, 150, 40, '', NULL, '', 'fanambyakademia@gmail.com', '', '', '', '', NULL, '', '2025-09-02', NULL);
INSERT INTO public.joueur VALUES (14, 1, 4, 1, 'Rakotoarisoa Nomyh', 'Lanja Ny Aina Kevin', '2011-09-16', '', 'Malagasy  ', 1, 150, 37, '', NULL, '', 'fanambyakademia@gmail.com', '', '', '', '', NULL, '', '2025-09-02', NULL);
INSERT INTO public.joueur VALUES (15, 1, 4, 1, 'RABENAH', 'Rio Zeidee', '2015-01-22', '', 'Malagasy  ', 1, 150, 39, '', NULL, '', 'fanambyakademia@gmail.com', '', '', '', '', NULL, '', '2025-09-02', NULL);
INSERT INTO public.joueur VALUES (16, 1, 4, 1, 'ANDRIANANTENAINA', 'Ricardo', '2013-02-23', '', 'Malagasy  ', 1, 148, 35, '', NULL, '', 'fanambyakademia@gmail.com', '', '', '', '', NULL, '', '2025-09-02', NULL);
INSERT INTO public.joueur VALUES (17, 1, 3, 1, 'RAVELOJAONA', 'Ritchy', '2014-09-26', '', 'Malagasy  ', 1, 140, 30, '', NULL, '', 'fanambyakademia@gmail.com', '', '', '', '', NULL, '', '2025-09-03', NULL);
INSERT INTO public.joueur VALUES (18, 1, 3, 1, 'HERITIANA ', 'Andy Royanne', '2014-02-21', '', 'Malagasy  ', 1, 150, 40, '', NULL, '', 'fanambyakademia@gmail.com', '', '', '', '', NULL, '', '2025-09-03', NULL);
INSERT INTO public.joueur VALUES (19, 1, 3, 1, 'RAVELOJAONA', 'Rica', '2011-06-23', '', 'Malagasy  ', 2, 160, 52, '', NULL, '', 'fanambyakademia@gmail.com', '', '', '', '', NULL, '', '2025-09-03', NULL);
INSERT INTO public.joueur VALUES (20, 1, 2, 1, 'RAKOTOARISON', 'FANOMEZANTSOA Maicon', '2012-11-09', '', 'Malagasy  ', 1, 153, 45, '', NULL, '', 'fanambyakademia@gmail.com', '', '', '', '', NULL, '', '2025-09-03', NULL);
INSERT INTO public.joueur VALUES (21, 1, 4, 1, 'RAZAKARISON', 'Andriniaina Tonny', '2012-02-15', '', 'Malagasy  ', 1, 155, 43, '', NULL, '', 'fanambyakademia@gmail.com', '', '', '', '', NULL, '', '2025-09-03', NULL);
INSERT INTO public.joueur VALUES (22, 1, 4, 1, 'RAZAFIARIVONY', 'Jucot Henri', '2012-10-29', '', 'Malagasy  ', 1, 150, 45, '', NULL, '', 'fanambyakademia@gmail.com', '', '', '', '', NULL, '', '2025-09-03', NULL);
INSERT INTO public.joueur VALUES (23, 1, 4, 1, 'RAKOTOMALALA', 'Gregoire', '2011-03-13', '', 'Malagasy  ', 1, 150, 40, '', NULL, '', 'fanambyakademia@gmail.com', '', '', '', '', NULL, '', '2025-09-03', NULL);
INSERT INTO public.joueur VALUES (25, 1, 4, 1, 'ANRIAMAROMAMPIANINA', 'Isco Rodriguez', '2015-02-16', '', 'Malagasy  ', 1, 150, 40, '', NULL, '', 'fanambyakademia@gmail.com', '', '', '', '', NULL, '', '2025-09-03', NULL);
INSERT INTO public.joueur VALUES (26, 1, 4, 1, 'VAHATRINIAINA', 'Nekena', '2011-12-11', '', 'Malagasy  ', 1, 154, 54, '', NULL, '', 'fanambyakademia@gmail.com', '', '', '', '', NULL, '', '2025-09-03', NULL);
INSERT INTO public.joueur VALUES (27, 1, 3, 1, 'HARINASANDRATRA ', 'Sandaniaina Mirado', '2014-06-29', '', 'Malagasy  ', 1, 150, 42, '', NULL, '', 'fanambyakademia@gmail.com', '', '', '', '', NULL, '', '2025-09-03', NULL);
INSERT INTO public.joueur VALUES (12, 1, 4, 1, 'RALAIARITIANA', 'Ravakiniaina Jean  Chris', '2012-06-09', '', 'Malagasy  ', 1, 140, 32, '', NULL, '', 'fanambyakademia@gmail.com', '', '', '', '', NULL, '', '2025-09-02', NULL);
INSERT INTO public.joueur VALUES (24, 1, 1, 1, 'ANDRIANASOLO', 'Bruto Romual', '2010-05-23', '', 'Malagasy  ', 1, 160, 58, '', NULL, '', 'fanambyakademia@gmail.com', '', '', '', '', NULL, '', '2025-09-03', NULL);
INSERT INTO public.joueur VALUES (11, 1, 4, 1, 'KANTONIAINA', 'Fiderana', '2012-12-08', '', 'Malagasy  ', 1, 150, 39, '', NULL, '', 'fanambyakademia@gmail.com', '', '', '', '', NULL, '', '2025-09-02', NULL);
INSERT INTO public.joueur VALUES (40, 1, 1, 1, 'EL Fanock', 'Anasse', '2013-01-16', NULL, 'Malagasy  ', 1, 160, 43, NULL, NULL, NULL, 'fanambyakademia@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, '2025-09-06', NULL);
INSERT INTO public.joueur VALUES (41, 1, 1, 1, 'RAKOTONIMANANA', 'Jean Lova', '2009-08-28', NULL, 'Malagasy  ', 1, 160, 48, NULL, NULL, NULL, 'fanambyakademia@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, '2025-09-06', NULL);
INSERT INTO public.joueur VALUES (42, 1, 2, 1, 'RANDRIAMBOLATSOA', 'Tambiniaina', '2010-08-05', NULL, 'Malagasy  ', 1, 155, 42, NULL, NULL, NULL, 'fanambyakademia@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, '2025-09-06', NULL);
INSERT INTO public.joueur VALUES (43, 1, 2, 1, 'ANDRIAMIARITSOA', 'Faniriniaina', '2012-01-20', NULL, 'Malagasy  ', 1, 155, 43, NULL, NULL, NULL, 'fanambyakademia@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, '2025-09-06', NULL);
INSERT INTO public.joueur VALUES (44, 1, 1, 1, 'TAHIANJANAHARY', 'Tiavina Stelly', '2010-03-05', NULL, 'Malagasy  ', 1, 148, 42, NULL, NULL, NULL, 'fanambyakademia@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, '2025-09-06', NULL);
INSERT INTO public.joueur VALUES (7, 1, 3, 1, 'Randriamihaja', 'Mahaliana Elie', '2012-04-18', NULL, 'Malagasy', 2, NULL, NULL, NULL, NULL, '', 'fanambyakademia@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, '2025-09-02', NULL);
INSERT INTO public.joueur VALUES (47, 1, 1, 4, 'TEST', 'titi', '2005-10-23', NULL, 'Malagasy', 1, 170, 50, NULL, 9, '+261 38 81 559 70', 'fanambyakademia@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-23', '2025-10-24');
INSERT INTO public.joueur VALUES (48, 1, 3, 1, 'RATOJOMIARAMANANA ', 'Royan', '2010-09-29', NULL, 'Malagasy', 1, 175, 45, NULL, 2, '+261 38 48 941 73', 'fanambyakademia@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-05', NULL);
INSERT INTO public.joueur VALUES (50, 1, 1, 1, 'RANDRIAMALALA', 'Tonnie Cedric', '2008-05-31', NULL, 'Malagasy', 1, 160, 58, NULL, 27, '+261 34 97 960 31', 'fanambyakademia@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-25', NULL);
INSERT INTO public.joueur VALUES (51, 1, 1, 1, 'AVOTRA ', 'Fidelio', '2010-02-26', NULL, 'Malagasy', 1, 165, 55, NULL, 99, '+261 38 60 403 94', 'fanambyakademia@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-25', NULL);
INSERT INTO public.joueur VALUES (52, 1, 3, 1, 'RAMAZIMANANA', 'Fetraniaina Sarobidy', '2010-07-14', NULL, 'Malagasy', 1, 160, 55, NULL, 26, '+261 38 55 877 13', 'fanambyakademia@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-01', NULL);


--
-- TOC entry 5041 (class 0 OID 116226)
-- Dependencies: 244
-- Data for Name: matchfoot; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.matchfoot VALUES (21, 22, 2, 'Tournoi', 'BAYERN', true, 5, 4, 0, 0, '', '');
INSERT INTO public.matchfoot VALUES (22, 23, 2, 'Tournoi', 'LA MASIA', true, 1, 3, 0, 0, '', '');
INSERT INTO public.matchfoot VALUES (23, 24, 2, 'Tournoi', 'SOFERA', true, 4, 0, 0, 0, '', '');
INSERT INTO public.matchfoot VALUES (24, 25, 2, 'Tournoi', 'LA MISIA', true, 1, 0, 0, 0, '', '');


--
-- TOC entry 5025 (class 0 OID 116089)
-- Dependencies: 228
-- Data for Name: niveaumatch; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.niveaumatch VALUES (1, 'Regional');
INSERT INTO public.niveaumatch VALUES (2, 'Departemental');
INSERT INTO public.niveaumatch VALUES (3, 'Ligue');
INSERT INTO public.niveaumatch VALUES (4, 'National');


--
-- TOC entry 5027 (class 0 OID 116098)
-- Dependencies: 230
-- Data for Name: piedfort; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.piedfort VALUES (1, 'Droit');
INSERT INTO public.piedfort VALUES (2, 'Gauche');
INSERT INTO public.piedfort VALUES (3, 'Ambidextre');


--
-- TOC entry 5015 (class 0 OID 116041)
-- Dependencies: 218
-- Data for Name: poste; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.poste VALUES (1, 'Gardien', 'Joueur protégeant les buts');
INSERT INTO public.poste VALUES (2, 'Defenseur', 'Joueur en défense');
INSERT INTO public.poste VALUES (3, 'Milieu', 'Joueur au milieu de terrain');
INSERT INTO public.poste VALUES (4, 'Attaquant', 'Joueur en attaque');


--
-- TOC entry 5039 (class 0 OID 116200)
-- Dependencies: 242
-- Data for Name: presence; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.presence VALUES (18, 2, 12, 1, '', '', NULL, '');
INSERT INTO public.presence VALUES (19, 2, 7, 1, '', '', NULL, '');
INSERT INTO public.presence VALUES (20, 2, 13, 1, '', '', NULL, '');
INSERT INTO public.presence VALUES (21, 2, 11, 1, '', '', NULL, '');
INSERT INTO public.presence VALUES (22, 2, 9, 1, '', '', NULL, '');
INSERT INTO public.presence VALUES (23, 2, 8, 1, '', '', NULL, '');
INSERT INTO public.presence VALUES (24, 2, 10, 1, '', '', NULL, '');
INSERT INTO public.presence VALUES (25, 2, 16, 1, '', '', NULL, '');
INSERT INTO public.presence VALUES (26, 2, 15, 1, '', '', NULL, '');
INSERT INTO public.presence VALUES (27, 2, 14, 1, '', '', NULL, '');
INSERT INTO public.presence VALUES (504, 42, 21, 2, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (514, 42, 12, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (516, 42, 40, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (519, 42, 43, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (524, 42, 48, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (526, 42, 19, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (531, 42, 50, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (413, 23, 12, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (428, 23, 17, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (432, 23, 44, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (34, 9, 11, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (35, 9, 13, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (37, 9, 9, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (36, 9, 8, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (38, 9, 15, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (39, 9, 7, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (40, 9, 20, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (41, 9, 10, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (42, 9, 14, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (43, 9, 18, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (44, 9, 16, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (45, 9, 19, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (46, 9, 22, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (47, 9, 21, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (48, 9, 24, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (49, 9, 23, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (51, 9, 17, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (52, 9, 25, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (53, 9, 12, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (50, 9, 26, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (54, 9, 27, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (65, 2, 17, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (66, 2, 19, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (67, 2, 18, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (68, 2, 20, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (69, 2, 25, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (70, 2, 22, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (71, 2, 21, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (72, 2, 23, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (73, 2, 24, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (74, 2, 27, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (75, 2, 26, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (76, 11, 11, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (77, 11, 7, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (78, 11, 10, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (79, 11, 8, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (80, 11, 9, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (81, 11, 12, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (82, 11, 16, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (83, 11, 15, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (84, 11, 13, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (85, 11, 14, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (86, 11, 18, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (87, 11, 21, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (88, 11, 22, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (89, 11, 17, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (90, 11, 25, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (91, 11, 24, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (92, 11, 20, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (93, 11, 23, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (94, 11, 19, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (95, 11, 27, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (96, 11, 26, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (172, 20, 10, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (168, 20, 7, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (171, 20, 11, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (169, 20, 8, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (167, 20, 9, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (170, 20, 13, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (173, 20, 17, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (174, 20, 16, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (175, 20, 19, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (176, 20, 18, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (177, 20, 21, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (178, 20, 20, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (179, 20, 23, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (180, 20, 22, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (181, 20, 26, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (182, 20, 27, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (183, 22, 7, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (184, 22, 8, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (185, 22, 10, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (186, 22, 9, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (187, 22, 11, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (188, 22, 12, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (189, 22, 13, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (190, 22, 18, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (191, 22, 14, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (192, 22, 16, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (193, 22, 19, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (194, 22, 17, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (197, 22, 22, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (506, 42, 22, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (508, 42, 23, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (521, 42, 44, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (522, 42, 17, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (530, 42, 20, 2, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (532, 42, 51, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (410, 23, 7, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (414, 23, 13, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (416, 23, 16, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (433, 23, 43, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (207, 24, 26, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (213, 24, 44, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (224, 24, 14, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (229, 25, 8, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (232, 25, 12, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (238, 25, 15, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (253, 25, 43, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (507, 42, 11, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (520, 42, 42, 2, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (529, 42, 16, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (408, 23, 11, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (417, 23, 18, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (419, 23, 20, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (421, 23, 22, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (424, 23, 25, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (202, 24, 27, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (203, 24, 24, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (205, 24, 9, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (208, 24, 40, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (209, 24, 13, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (211, 24, 42, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (212, 24, 43, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (215, 24, 10, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (217, 24, 12, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (218, 24, 17, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (219, 24, 16, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (221, 24, 18, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (230, 25, 9, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (233, 25, 13, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (234, 25, 10, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (237, 25, 18, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (241, 25, 21, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (242, 25, 17, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (243, 25, 22, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (244, 25, 23, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (246, 25, 24, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (247, 25, 25, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (248, 25, 40, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (250, 25, 27, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (251, 25, 42, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (222, 24, 19, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (226, 24, 23, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (505, 42, 9, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (510, 42, 24, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (511, 42, 8, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (515, 42, 13, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (518, 42, 15, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (525, 42, 14, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (411, 23, 10, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (415, 23, 15, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (429, 23, 23, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (528, 42, 18, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (225, 24, 21, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (206, 24, 8, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (204, 24, 25, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (210, 24, 41, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (214, 24, 7, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (216, 24, 11, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (220, 24, 15, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (228, 25, 7, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (231, 25, 11, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (235, 25, 16, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (236, 25, 14, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (239, 25, 20, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (240, 25, 19, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (245, 25, 26, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (249, 25, 41, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (252, 25, 44, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (223, 24, 20, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (227, 24, 22, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (503, 42, 7, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (509, 42, 25, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (512, 42, 26, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (513, 42, 27, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (517, 42, 41, 2, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (523, 42, 47, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (412, 23, 8, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (422, 23, 14, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (425, 23, 26, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (427, 23, 40, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (430, 23, 42, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (527, 42, 10, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (409, 23, 9, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (418, 23, 19, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (420, 23, 21, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (423, 23, 24, 2, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (426, 23, 27, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (431, 23, 41, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (438, 20, 14, 2, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (440, 20, 44, 2, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (477, 31, 11, 2, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (492, 31, 22, 2, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (501, 31, 44, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (199, 22, 23, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (201, 22, 27, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (434, 20, 43, 2, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (482, 31, 13, 2, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (485, 31, 12, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (489, 31, 19, 2, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (496, 31, 23, 2, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (499, 31, 40, 2, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (436, 20, 42, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (478, 31, 8, 2, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (479, 31, 15, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (483, 31, 14, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (486, 31, 16, 2, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (488, 31, 18, 2, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (490, 31, 20, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (494, 31, 25, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (495, 31, 24, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (498, 31, 42, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (500, 31, 27, 2, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (437, 20, 41, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (480, 31, 9, 2, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (481, 31, 7, 2, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (484, 31, 10, 2, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (487, 31, 17, 2, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (491, 31, 21, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (493, 31, 26, 2, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (497, 31, 41, 2, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (502, 31, 43, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (439, 20, 12, 2, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (441, 20, 40, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (443, 20, 25, 2, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (435, 20, 15, 2, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (442, 20, 24, 2, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (444, 22, 15, 2, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (447, 22, 43, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (449, 22, 42, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (198, 22, 25, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (446, 22, 40, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (445, 22, 24, 2, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (317, 2, 42, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (448, 22, 41, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (450, 22, 44, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (316, 2, 41, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (319, 2, 44, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (451, 30, 11, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (458, 30, 14, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (463, 30, 20, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (465, 30, 22, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (468, 30, 26, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (200, 22, 26, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (452, 30, 12, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (457, 30, 13, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (459, 30, 15, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (461, 30, 16, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (470, 30, 18, 2, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (475, 30, 44, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (453, 30, 10, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (460, 30, 17, 2, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (466, 30, 24, 2, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (469, 30, 27, 2, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (473, 30, 42, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (455, 30, 9, 2, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (314, 2, 40, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (318, 2, 43, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (462, 30, 19, 2, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (471, 30, 40, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (454, 30, 7, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (464, 30, 21, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (467, 30, 25, 2, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (472, 30, 41, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (474, 30, 43, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (456, 30, 8, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (476, 30, 23, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (196, 22, 20, 1, NULL, NULL, NULL, '');
INSERT INTO public.presence VALUES (195, 22, 21, 1, NULL, NULL, NULL, '');


--
-- TOC entry 5037 (class 0 OID 116174)
-- Dependencies: 240
-- Data for Name: seance; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.seance VALUES (9, 1, 1, '2025-09-04', '07:30:00', '09:00:00', 'Sissi By-Pass', '', '', 2);
INSERT INTO public.seance VALUES (11, 1, 1, '2025-09-05', '07:30:00', '09:00:00', 'Sissi By-Pass', '', '', 2);
INSERT INTO public.seance VALUES (20, 1, 1, '2025-09-13', '07:30:00', '09:00:00', 'CFFA', '', '', 2);
INSERT INTO public.seance VALUES (23, 1, 2, '2025-09-14', '14:00:00', '14:30:00', 'Betongolo', '', '', 2);
INSERT INTO public.seance VALUES (24, 1, 2, '2025-09-06', '11:00:00', '11:30:00', 'Betongolo', '', '', 2);
INSERT INTO public.seance VALUES (25, 1, 2, '2025-09-07', '14:00:00', '14:30:00', 'Betongolo', '', '', 2);
INSERT INTO public.seance VALUES (30, 1, 1, '2025-10-11', '08:00:00', '09:30:00', 'CFFA', '', '', 2);
INSERT INTO public.seance VALUES (31, 1, 1, '2025-10-18', '06:30:00', '08:00:00', 'CFFA', '', '', 2);
INSERT INTO public.seance VALUES (2, 1, 1, '2025-09-03', '07:30:00', '09:00:00', 'Sissi By-Pass', '', '', 2);
INSERT INTO public.seance VALUES (22, 1, 2, '2025-09-14', '09:00:00', '09:30:00', 'Betongolo', '', '', 2);
INSERT INTO public.seance VALUES (42, 1, 1, '2025-10-25', '07:00:00', '08:00:00', 'CFFA', '', '', 2);


--
-- TOC entry 5031 (class 0 OID 116116)
-- Dependencies: 234
-- Data for Name: statutcomposition; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.statutcomposition VALUES (1, 'Titulaire');
INSERT INTO public.statutcomposition VALUES (2, 'Remplaçant');
INSERT INTO public.statutcomposition VALUES (3, 'Blessé');
INSERT INTO public.statutcomposition VALUES (4, 'Suspendu');
INSERT INTO public.statutcomposition VALUES (5, 'Autre');


--
-- TOC entry 5023 (class 0 OID 116079)
-- Dependencies: 226
-- Data for Name: statutjoueur; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.statutjoueur VALUES (1, 'Actif', true);
INSERT INTO public.statutjoueur VALUES (2, 'Blessé', false);
INSERT INTO public.statutjoueur VALUES (3, 'Suspendu', false);
INSERT INTO public.statutjoueur VALUES (4, 'Inactif', false);
INSERT INTO public.statutjoueur VALUES (5, 'En convalescence', false);


--
-- TOC entry 5021 (class 0 OID 116068)
-- Dependencies: 224
-- Data for Name: statutpresence; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.statutpresence VALUES (1, 'Present', 'P');
INSERT INTO public.statutpresence VALUES (2, 'Absent', 'A');


--
-- TOC entry 5029 (class 0 OID 116107)
-- Dependencies: 232
-- Data for Name: statutseance; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.statutseance VALUES (1, 'Planifié');
INSERT INTO public.statutseance VALUES (2, 'Réalisé');
INSERT INTO public.statutseance VALUES (3, 'Annulé');


--
-- TOC entry 5019 (class 0 OID 116059)
-- Dependencies: 222
-- Data for Name: typematch; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.typematch VALUES (1, 'Amical', 'Match sans enjeu compétitif');
INSERT INTO public.typematch VALUES (2, 'Officiel', 'Match de championnat ou coupe');


--
-- TOC entry 5017 (class 0 OID 116050)
-- Dependencies: 220
-- Data for Name: typeseance; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.typeseance VALUES (1, 'Entrainement', 'Séance d entraînement régulière');
INSERT INTO public.typeseance VALUES (2, 'Match', 'Match');


--
-- TOC entry 5065 (class 0 OID 0)
-- Dependencies: 235
-- Name: club_idclub_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.club_idclub_seq', 13, true);


--
-- TOC entry 5066 (class 0 OID 0)
-- Dependencies: 245
-- Name: composition_idcomposition_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.composition_idcomposition_seq', 77, true);


--
-- TOC entry 5067 (class 0 OID 0)
-- Dependencies: 237
-- Name: joueur_idjoueur_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.joueur_idjoueur_seq', 52, true);


--
-- TOC entry 5068 (class 0 OID 0)
-- Dependencies: 243
-- Name: matchfoot_idmatch_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.matchfoot_idmatch_seq', 28, true);


--
-- TOC entry 5069 (class 0 OID 0)
-- Dependencies: 227
-- Name: niveaumatch_idniveaumatch_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.niveaumatch_idniveaumatch_seq', 22, true);


--
-- TOC entry 5070 (class 0 OID 0)
-- Dependencies: 229
-- Name: piedfort_idpiedfort_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.piedfort_idpiedfort_seq', 21, true);


--
-- TOC entry 5071 (class 0 OID 0)
-- Dependencies: 217
-- Name: poste_idposte_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.poste_idposte_seq', 22, true);


--
-- TOC entry 5072 (class 0 OID 0)
-- Dependencies: 241
-- Name: presence_idpresence_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.presence_idpresence_seq', 532, true);


--
-- TOC entry 5073 (class 0 OID 0)
-- Dependencies: 239
-- Name: seance_idseance_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seance_idseance_seq', 80, true);


--
-- TOC entry 5074 (class 0 OID 0)
-- Dependencies: 233
-- Name: statutcomposition_idstatutcomposition_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.statutcomposition_idstatutcomposition_seq', 23, true);


--
-- TOC entry 5075 (class 0 OID 0)
-- Dependencies: 225
-- Name: statutjoueur_idstatutjoueur_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.statutjoueur_idstatutjoueur_seq', 23, true);


--
-- TOC entry 5076 (class 0 OID 0)
-- Dependencies: 223
-- Name: statutpresence_idstatutpresence_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.statutpresence_idstatutpresence_seq', 20, true);


--
-- TOC entry 5077 (class 0 OID 0)
-- Dependencies: 231
-- Name: statutseance_idstatutseance_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.statutseance_idstatutseance_seq', 21, true);


--
-- TOC entry 5078 (class 0 OID 0)
-- Dependencies: 221
-- Name: typematch_idtypematch_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.typematch_idtypematch_seq', 20, true);


--
-- TOC entry 5079 (class 0 OID 0)
-- Dependencies: 219
-- Name: typeseance_idtypeseance_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.typeseance_idtypeseance_seq', 20, true);


--
-- TOC entry 4817 (class 2606 OID 118408)
-- Name: club club_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.club
    ADD CONSTRAINT club_email_key UNIQUE (email);


--
-- TOC entry 4819 (class 2606 OID 118410)
-- Name: club club_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.club
    ADD CONSTRAINT club_pkey PRIMARY KEY (idclub);


--
-- TOC entry 4842 (class 2606 OID 118520)
-- Name: composition composition_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.composition
    ADD CONSTRAINT composition_pkey PRIMARY KEY (idcomposition);


--
-- TOC entry 4823 (class 2606 OID 118686)
-- Name: joueur joueur_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.joueur
    ADD CONSTRAINT joueur_pkey PRIMARY KEY (idjoueur);


--
-- TOC entry 4840 (class 2606 OID 118773)
-- Name: matchfoot matchfoot_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matchfoot
    ADD CONSTRAINT matchfoot_pkey PRIMARY KEY (idmatch);


--
-- TOC entry 4800 (class 2606 OID 118799)
-- Name: niveaumatch niveaumatch_libelle_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.niveaumatch
    ADD CONSTRAINT niveaumatch_libelle_key UNIQUE (libelle);


--
-- TOC entry 4802 (class 2606 OID 118801)
-- Name: niveaumatch niveaumatch_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.niveaumatch
    ADD CONSTRAINT niveaumatch_pkey PRIMARY KEY (idniveaumatch);


--
-- TOC entry 4804 (class 2606 OID 118839)
-- Name: piedfort piedfort_libelle_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.piedfort
    ADD CONSTRAINT piedfort_libelle_key UNIQUE (libelle);


--
-- TOC entry 4806 (class 2606 OID 118841)
-- Name: piedfort piedfort_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.piedfort
    ADD CONSTRAINT piedfort_pkey PRIMARY KEY (idpiedfort);


--
-- TOC entry 4776 (class 2606 OID 118884)
-- Name: poste poste_libelle_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.poste
    ADD CONSTRAINT poste_libelle_key UNIQUE (libelle);


--
-- TOC entry 4778 (class 2606 OID 118886)
-- Name: poste poste_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.poste
    ADD CONSTRAINT poste_pkey PRIMARY KEY (idposte);


--
-- TOC entry 4835 (class 2606 OID 118956)
-- Name: presence presence_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.presence
    ADD CONSTRAINT presence_pkey PRIMARY KEY (idpresence);


--
-- TOC entry 4813 (class 2606 OID 119075)
-- Name: statutcomposition statutcomposition_libelle_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.statutcomposition
    ADD CONSTRAINT statutcomposition_libelle_key UNIQUE (libelle);


--
-- TOC entry 4815 (class 2606 OID 119077)
-- Name: statutcomposition statutcomposition_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.statutcomposition
    ADD CONSTRAINT statutcomposition_pkey PRIMARY KEY (idstatutcomposition);


--
-- TOC entry 4796 (class 2606 OID 119120)
-- Name: statutjoueur statutjoueur_libelle_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.statutjoueur
    ADD CONSTRAINT statutjoueur_libelle_key UNIQUE (libelle);


--
-- TOC entry 4798 (class 2606 OID 119122)
-- Name: statutjoueur statutjoueur_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.statutjoueur
    ADD CONSTRAINT statutjoueur_pkey PRIMARY KEY (idstatutjoueur);


--
-- TOC entry 4790 (class 2606 OID 119173)
-- Name: statutpresence statutpresence_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.statutpresence
    ADD CONSTRAINT statutpresence_code_key UNIQUE (code);


--
-- TOC entry 4792 (class 2606 OID 119175)
-- Name: statutpresence statutpresence_libelle_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.statutpresence
    ADD CONSTRAINT statutpresence_libelle_key UNIQUE (libelle);


--
-- TOC entry 4794 (class 2606 OID 119177)
-- Name: statutpresence statutpresence_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.statutpresence
    ADD CONSTRAINT statutpresence_pkey PRIMARY KEY (idstatutpresence);


--
-- TOC entry 4809 (class 2606 OID 119220)
-- Name: statutseance statutseance_libelle_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.statutseance
    ADD CONSTRAINT statutseance_libelle_key UNIQUE (libelle);


--
-- TOC entry 4811 (class 2606 OID 119222)
-- Name: statutseance statutseance_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.statutseance
    ADD CONSTRAINT statutseance_pkey PRIMARY KEY (idstatutseance);


--
-- TOC entry 4785 (class 2606 OID 119265)
-- Name: typematch typematch_libelle_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.typematch
    ADD CONSTRAINT typematch_libelle_key UNIQUE (libelle);


--
-- TOC entry 4787 (class 2606 OID 119267)
-- Name: typematch typematch_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.typematch
    ADD CONSTRAINT typematch_pkey PRIMARY KEY (idtypematch);


--
-- TOC entry 4781 (class 2606 OID 119310)
-- Name: typeseance typeseance_libelle_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.typeseance
    ADD CONSTRAINT typeseance_libelle_key UNIQUE (libelle);


--
-- TOC entry 4783 (class 2606 OID 119312)
-- Name: typeseance typeseance_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.typeseance
    ADD CONSTRAINT typeseance_pkey PRIMARY KEY (idtypeseance);


--
-- TOC entry 4847 (class 2606 OID 118518)
-- Name: composition unq_composition; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.composition
    ADD CONSTRAINT unq_composition UNIQUE (idmatch, idjoueur);


--
-- TOC entry 4837 (class 2606 OID 118954)
-- Name: presence unq_presence; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.presence
    ADD CONSTRAINT unq_presence UNIQUE (idseance, idjoueur);


--
-- TOC entry 4843 (class 1259 OID 116287)
-- Name: idx_composition_joueur; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_composition_joueur ON public.composition USING btree (idjoueur);


--
-- TOC entry 4844 (class 1259 OID 116286)
-- Name: idx_composition_match; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_composition_match ON public.composition USING btree (idmatch);


--
-- TOC entry 4845 (class 1259 OID 116288)
-- Name: idx_composition_statut; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_composition_statut ON public.composition USING btree (idstatutcomposition);


--
-- TOC entry 4820 (class 1259 OID 118342)
-- Name: idx_joueur_actif; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_joueur_actif ON public.joueur USING btree (idclub) WHERE (datequitter IS NULL);


--
-- TOC entry 4821 (class 1259 OID 118343)
-- Name: idx_joueur_inactif; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_joueur_inactif ON public.joueur USING btree (idclub) WHERE (datequitter IS NOT NULL);


--
-- TOC entry 4838 (class 1259 OID 116285)
-- Name: idx_match_seance; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_match_seance ON public.matchfoot USING btree (idseance);


--
-- TOC entry 4829 (class 1259 OID 116284)
-- Name: idx_presence_joueur; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_presence_joueur ON public.presence USING btree (idjoueur);


--
-- TOC entry 4830 (class 1259 OID 118340)
-- Name: idx_presence_joueur_seance_statut; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_presence_joueur_seance_statut ON public.presence USING btree (idjoueur, idseance, idstatutpresence);


--
-- TOC entry 4831 (class 1259 OID 116282)
-- Name: idx_presence_seance; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_presence_seance ON public.presence USING btree (idseance);


--
-- TOC entry 4832 (class 1259 OID 118341)
-- Name: idx_presence_seance_present; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_presence_seance_present ON public.presence USING btree (idseance) WHERE (idstatutpresence = 1);


--
-- TOC entry 4833 (class 1259 OID 116283)
-- Name: idx_presence_statut; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_presence_statut ON public.presence USING btree (idstatutpresence);


--
-- TOC entry 4824 (class 1259 OID 116280)
-- Name: idx_seance_club; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_seance_club ON public.seance USING btree (idclub);


--
-- TOC entry 4825 (class 1259 OID 116279)
-- Name: idx_seance_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_seance_date ON public.seance USING btree (dateseance);


--
-- TOC entry 4826 (class 1259 OID 118339)
-- Name: idx_seance_date_type_statut; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_seance_date_type_statut ON public.seance USING btree (dateseance, idtypeseance, idstatutseance);


--
-- TOC entry 4827 (class 1259 OID 116281)
-- Name: idx_seance_statut; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_seance_statut ON public.seance USING btree (idstatutseance);


--
-- TOC entry 4828 (class 1259 OID 116278)
-- Name: idx_seance_type_seance; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_seance_type_seance ON public.seance USING btree (idtypeseance);


--
-- TOC entry 4788 (class 1259 OID 116291)
-- Name: idx_statut_presence_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_statut_presence_code ON public.statutpresence USING btree (code);


--
-- TOC entry 4807 (class 1259 OID 116290)
-- Name: idx_statut_seance_libelle; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_statut_seance_libelle ON public.statutseance USING btree (libelle);


--
-- TOC entry 4779 (class 1259 OID 116289)
-- Name: idx_type_seance_libelle; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_type_seance_libelle ON public.typeseance USING btree (libelle);


--
-- TOC entry 4858 (class 2606 OID 118702)
-- Name: composition composition_idjoueur_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.composition
    ADD CONSTRAINT composition_idjoueur_fkey FOREIGN KEY (idjoueur) REFERENCES public.joueur(idjoueur);


--
-- TOC entry 4859 (class 2606 OID 118777)
-- Name: composition composition_idmatch_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.composition
    ADD CONSTRAINT composition_idmatch_fkey FOREIGN KEY (idmatch) REFERENCES public.matchfoot(idmatch);


--
-- TOC entry 4860 (class 2606 OID 119078)
-- Name: composition composition_idstatutcomposition_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.composition
    ADD CONSTRAINT composition_idstatutcomposition_fkey FOREIGN KEY (idstatutcomposition) REFERENCES public.statutcomposition(idstatutcomposition);


--
-- TOC entry 4848 (class 2606 OID 118692)
-- Name: joueur joueur_idclub_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.joueur
    ADD CONSTRAINT joueur_idclub_fkey FOREIGN KEY (idclub) REFERENCES public.club(idclub);


--
-- TOC entry 4849 (class 2606 OID 118842)
-- Name: joueur joueur_idpiedfort_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.joueur
    ADD CONSTRAINT joueur_idpiedfort_fkey FOREIGN KEY (idpiedfort) REFERENCES public.piedfort(idpiedfort);


--
-- TOC entry 4850 (class 2606 OID 118887)
-- Name: joueur joueur_idposte_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.joueur
    ADD CONSTRAINT joueur_idposte_fkey FOREIGN KEY (idposte) REFERENCES public.poste(idposte);


--
-- TOC entry 4851 (class 2606 OID 119123)
-- Name: joueur joueur_idstatutjoueur_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.joueur
    ADD CONSTRAINT joueur_idstatutjoueur_fkey FOREIGN KEY (idstatutjoueur) REFERENCES public.statutjoueur(idstatutjoueur);


--
-- TOC entry 4857 (class 2606 OID 119268)
-- Name: matchfoot matchfoot_idtypematch_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matchfoot
    ADD CONSTRAINT matchfoot_idtypematch_fkey FOREIGN KEY (idtypematch) REFERENCES public.typematch(idtypematch);


--
-- TOC entry 4855 (class 2606 OID 118957)
-- Name: presence presence_idjoueur_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.presence
    ADD CONSTRAINT presence_idjoueur_fkey FOREIGN KEY (idjoueur) REFERENCES public.joueur(idjoueur);


--
-- TOC entry 4856 (class 2606 OID 119178)
-- Name: presence presence_idstatutpresence_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.presence
    ADD CONSTRAINT presence_idstatutpresence_fkey FOREIGN KEY (idstatutpresence) REFERENCES public.statutpresence(idstatutpresence);


--
-- TOC entry 4852 (class 2606 OID 119033)
-- Name: seance seance_idclub_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seance
    ADD CONSTRAINT seance_idclub_fkey FOREIGN KEY (idclub) REFERENCES public.club(idclub);


--
-- TOC entry 4853 (class 2606 OID 119223)
-- Name: seance seance_idstatutseance_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seance
    ADD CONSTRAINT seance_idstatutseance_fkey FOREIGN KEY (idstatutseance) REFERENCES public.statutseance(idstatutseance);


--
-- TOC entry 4854 (class 2606 OID 119313)
-- Name: seance seance_idtypeseance_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seance
    ADD CONSTRAINT seance_idtypeseance_fkey FOREIGN KEY (idtypeseance) REFERENCES public.typeseance(idtypeseance);


--
-- TOC entry 5049 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT ALL ON SCHEMA public TO fanamby;


-- Completed on 2025-11-08 16:55:32

--
-- PostgreSQL database dump complete
--

