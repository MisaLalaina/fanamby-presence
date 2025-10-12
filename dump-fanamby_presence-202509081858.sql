--
-- PostgreSQL database dump
--

-- Dumped from database version 17.2
-- Dumped by pg_dump version 17.2

-- Started on 2025-09-08 18:58:53

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
-- TOC entry 240 (class 1259 OID 115171)
-- Name: arbitrage; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.arbitrage (
    idarbitrage integer NOT NULL,
    idarbitreprincipal integer NOT NULL,
    idarbitreassistant1 integer,
    idarbitreassistant2 integer,
    iddelegue integer,
    datecertification date,
    idniveaumatch integer NOT NULL
);


ALTER TABLE public.arbitrage OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 115170)
-- Name: arbitrage_idarbitrage_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.arbitrage_idarbitrage_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.arbitrage_idarbitrage_seq OWNER TO postgres;

--
-- TOC entry 5078 (class 0 OID 0)
-- Dependencies: 239
-- Name: arbitrage_idarbitrage_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.arbitrage_idarbitrage_seq OWNED BY public.arbitrage.idarbitrage;


--
-- TOC entry 238 (class 1259 OID 115154)
-- Name: arbitre; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.arbitre (
    idarbitre integer NOT NULL,
    nom character varying(50) NOT NULL,
    prenom character varying(50) NOT NULL,
    datenaissance date,
    licence character varying(50),
    idniveauarbitre integer NOT NULL,
    telephone character varying(20),
    email character varying(100),
    datedebutarbitrage date,
    matchesdiriges integer DEFAULT 0
);


ALTER TABLE public.arbitre OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 115153)
-- Name: arbitre_idarbitre_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.arbitre_idarbitre_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.arbitre_idarbitre_seq OWNER TO postgres;

--
-- TOC entry 5079 (class 0 OID 0)
-- Dependencies: 237
-- Name: arbitre_idarbitre_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.arbitre_idarbitre_seq OWNED BY public.arbitre.idarbitre;


--
-- TOC entry 236 (class 1259 OID 115142)
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
-- TOC entry 235 (class 1259 OID 115141)
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
-- TOC entry 5080 (class 0 OID 0)
-- Dependencies: 235
-- Name: club_idclub_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.club_idclub_seq OWNED BY public.club.idclub;


--
-- TOC entry 250 (class 1259 OID 115312)
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
-- TOC entry 249 (class 1259 OID 115311)
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
-- TOC entry 5081 (class 0 OID 0)
-- Dependencies: 249
-- Name: composition_idcomposition_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.composition_idcomposition_seq OWNED BY public.composition.idcomposition;


--
-- TOC entry 242 (class 1259 OID 115198)
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
    CONSTRAINT chk_date_certificat CHECK (((datevaliditecertificat IS NULL) OR (datevaliditecertificat >= CURRENT_DATE))),
    CONSTRAINT chk_email_joueur CHECK (((email IS NULL) OR ((email)::text ~* '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$'::text))),
    CONSTRAINT joueur_numeromaillot_check CHECK (((numeromaillot >= 1) AND (numeromaillot <= 99))),
    CONSTRAINT joueur_poids_check CHECK (((poids >= 30) AND (poids <= 150))),
    CONSTRAINT joueur_taille_check CHECK (((taille >= 100) AND (taille <= 250)))
);


ALTER TABLE public.joueur OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 115115)
-- Name: piedfort; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.piedfort (
    idpiedfort integer NOT NULL,
    libelle character varying(20) NOT NULL
);


ALTER TABLE public.piedfort OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 115058)
-- Name: poste; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.poste (
    idposte integer NOT NULL,
    libelle character varying(50) NOT NULL,
    description character varying(255)
);


ALTER TABLE public.poste OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 115087)
-- Name: statutjoueur; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.statutjoueur (
    idstatutjoueur integer NOT NULL,
    libelle character varying(50) NOT NULL,
    peutjouer boolean DEFAULT true NOT NULL
);


ALTER TABLE public.statutjoueur OWNER TO postgres;

--
-- TOC entry 252 (class 1259 OID 115362)
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
-- TOC entry 241 (class 1259 OID 115197)
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
-- TOC entry 5082 (class 0 OID 0)
-- Dependencies: 241
-- Name: joueur_idjoueur_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.joueur_idjoueur_seq OWNED BY public.joueur.idjoueur;


--
-- TOC entry 248 (class 1259 OID 115287)
-- Name: matchfoot; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.matchfoot (
    idmatch integer NOT NULL,
    idseance integer NOT NULL,
    idarbitrage integer,
    competition character varying(100),
    adversaire character varying(100) NOT NULL,
    domicile boolean DEFAULT true,
    scoreequipe integer,
    scoreadversaire integer,
    tempsadditionnel1 integer DEFAULT 0,
    tempsadditionnel2 integer DEFAULT 0,
    public integer,
    incidents text,
    observations text,
    CONSTRAINT chk_temps_additionnel CHECK (((tempsadditionnel1 >= 0) AND (tempsadditionnel2 >= 0))),
    CONSTRAINT matchfoot_scoreadversaire_check CHECK ((scoreadversaire >= 0)),
    CONSTRAINT matchfoot_scoreequipe_check CHECK ((scoreequipe >= 0))
);


ALTER TABLE public.matchfoot OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 115286)
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
-- TOC entry 5083 (class 0 OID 0)
-- Dependencies: 247
-- Name: matchfoot_idmatch_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.matchfoot_idmatch_seq OWNED BY public.matchfoot.idmatch;


--
-- TOC entry 226 (class 1259 OID 115097)
-- Name: niveauarbitre; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.niveauarbitre (
    idniveauarbitre integer NOT NULL,
    libelle character varying(50) NOT NULL
);


ALTER TABLE public.niveauarbitre OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 115096)
-- Name: niveauarbitre_idniveauarbitre_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.niveauarbitre_idniveauarbitre_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.niveauarbitre_idniveauarbitre_seq OWNER TO postgres;

--
-- TOC entry 5084 (class 0 OID 0)
-- Dependencies: 225
-- Name: niveauarbitre_idniveauarbitre_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.niveauarbitre_idniveauarbitre_seq OWNED BY public.niveauarbitre.idniveauarbitre;


--
-- TOC entry 228 (class 1259 OID 115106)
-- Name: niveaumatch; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.niveaumatch (
    idniveaumatch integer NOT NULL,
    libelle character varying(50) NOT NULL
);


ALTER TABLE public.niveaumatch OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 115105)
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
-- TOC entry 5085 (class 0 OID 0)
-- Dependencies: 227
-- Name: niveaumatch_idniveaumatch_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.niveaumatch_idniveaumatch_seq OWNED BY public.niveaumatch.idniveaumatch;


--
-- TOC entry 229 (class 1259 OID 115114)
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
-- TOC entry 5086 (class 0 OID 0)
-- Dependencies: 229
-- Name: piedfort_idpiedfort_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.piedfort_idpiedfort_seq OWNED BY public.piedfort.idpiedfort;


--
-- TOC entry 217 (class 1259 OID 115057)
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
-- TOC entry 5087 (class 0 OID 0)
-- Dependencies: 217
-- Name: poste_idposte_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.poste_idposte_seq OWNED BY public.poste.idposte;


--
-- TOC entry 246 (class 1259 OID 115261)
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
-- TOC entry 244 (class 1259 OID 115235)
-- Name: seance; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.seance (
    idseance integer NOT NULL,
    idclub integer NOT NULL,
    idtypeseance integer NOT NULL,
    dateseance date NOT NULL,
    heuredebut time without time zone NOT NULL,
    heurefin time without time zone NOT NULL,
    lieu character varying(100) NOT NULL,
    objectif text,
    bilan text,
    idstatutseance integer DEFAULT 1,
    CONSTRAINT chk_heure_seance CHECK ((heurefin > heuredebut))
);


ALTER TABLE public.seance OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 115124)
-- Name: statutseance; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.statutseance (
    idstatutseance integer NOT NULL,
    libelle character varying(20) NOT NULL
);


ALTER TABLE public.statutseance OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 115067)
-- Name: typeseance; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.typeseance (
    idtypeseance integer NOT NULL,
    libelle character varying(50) NOT NULL,
    description character varying(255)
);


ALTER TABLE public.typeseance OWNER TO postgres;

--
-- TOC entry 253 (class 1259 OID 115382)
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
-- TOC entry 222 (class 1259 OID 115076)
-- Name: statutpresence; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.statutpresence (
    idstatutpresence integer NOT NULL,
    libelle character varying(50) NOT NULL,
    code character varying(10) NOT NULL
);


ALTER TABLE public.statutpresence OWNER TO postgres;

--
-- TOC entry 254 (class 1259 OID 115392)
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
-- TOC entry 245 (class 1259 OID 115260)
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
-- TOC entry 5088 (class 0 OID 0)
-- Dependencies: 245
-- Name: presence_idpresence_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.presence_idpresence_seq OWNED BY public.presence.idpresence;


--
-- TOC entry 243 (class 1259 OID 115234)
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
-- TOC entry 5089 (class 0 OID 0)
-- Dependencies: 243
-- Name: seance_idseance_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.seance_idseance_seq OWNED BY public.seance.idseance;


--
-- TOC entry 234 (class 1259 OID 115133)
-- Name: statutcomposition; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.statutcomposition (
    idstatutcomposition integer NOT NULL,
    libelle character varying(20) NOT NULL
);


ALTER TABLE public.statutcomposition OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 115132)
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
-- TOC entry 5090 (class 0 OID 0)
-- Dependencies: 233
-- Name: statutcomposition_idstatutcomposition_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.statutcomposition_idstatutcomposition_seq OWNED BY public.statutcomposition.idstatutcomposition;


--
-- TOC entry 223 (class 1259 OID 115086)
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
-- TOC entry 5091 (class 0 OID 0)
-- Dependencies: 223
-- Name: statutjoueur_idstatutjoueur_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.statutjoueur_idstatutjoueur_seq OWNED BY public.statutjoueur.idstatutjoueur;


--
-- TOC entry 221 (class 1259 OID 115075)
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
-- TOC entry 5092 (class 0 OID 0)
-- Dependencies: 221
-- Name: statutpresence_idstatutpresence_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.statutpresence_idstatutpresence_seq OWNED BY public.statutpresence.idstatutpresence;


--
-- TOC entry 231 (class 1259 OID 115123)
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
-- TOC entry 5093 (class 0 OID 0)
-- Dependencies: 231
-- Name: statutseance_idstatutseance_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.statutseance_idstatutseance_seq OWNED BY public.statutseance.idstatutseance;


--
-- TOC entry 219 (class 1259 OID 115066)
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
-- TOC entry 5094 (class 0 OID 0)
-- Dependencies: 219
-- Name: typeseance_idtypeseance_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.typeseance_idtypeseance_seq OWNED BY public.typeseance.idtypeseance;


--
-- TOC entry 255 (class 1259 OID 115397)
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
-- TOC entry 256 (class 1259 OID 115402)
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
-- TOC entry 257 (class 1259 OID 115408)
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
UNION
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
-- TOC entry 251 (class 1259 OID 115357)
-- Name: vue_statistiques_presence_generales; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vue_statistiques_presence_generales AS
 SELECT c.idclub,
    c.nomclub,
    count(DISTINCT j.idjoueur) AS total_joueurs,
    count(DISTINCT s.idseance) AS total_seances,
    count(pres.idpresence) AS total_presences_enregistrees,
    sum(
        CASE
            WHEN ((sp.code)::text = 'P'::text) THEN 1
            ELSE 0
        END) AS total_presents,
    sum(
        CASE
            WHEN ((sp.code)::text = 'A'::text) THEN 1
            ELSE 0
        END) AS total_absents,
    sum(
        CASE
            WHEN ((sp.code)::text = 'R'::text) THEN 1
            ELSE 0
        END) AS total_retards,
    sum(
        CASE
            WHEN ((sp.code)::text = 'E'::text) THEN 1
            ELSE 0
        END) AS total_exemples,
    round((((sum(
        CASE
            WHEN ((sp.code)::text = 'P'::text) THEN 1
            ELSE 0
        END))::numeric * 100.0) / (NULLIF(count(pres.idpresence), 0))::numeric), 2) AS taux_presence_moyen,
    count(DISTINCT
        CASE
            WHEN ((ts.libelle)::text = 'Entrainement'::text) THEN s.idseance
            ELSE NULL::integer
        END) AS total_entrainements,
    count(DISTINCT
        CASE
            WHEN ((ts.libelle)::text = 'Match'::text) THEN s.idseance
            ELSE NULL::integer
        END) AS total_matches,
    sum(
        CASE
            WHEN (((ts.libelle)::text = 'Entrainement'::text) AND ((sp.code)::text = 'P'::text)) THEN 1
            ELSE 0
        END) AS entrainements_presents,
    sum(
        CASE
            WHEN (((ts.libelle)::text = 'Match'::text) AND ((sp.code)::text = 'P'::text)) THEN 1
            ELSE 0
        END) AS matches_presents,
    min(s.dateseance) AS date_debut_periode,
    max(s.dateseance) AS date_fin_periode,
    ( SELECT (((j_1.nom)::text || ' '::text) || (j_1.prenom)::text)
           FROM ((public.joueur j_1
             JOIN public.presence p ON ((j_1.idjoueur = p.idjoueur)))
             JOIN public.statutpresence sp2 ON ((p.idstatutpresence = sp2.idstatutpresence)))
          WHERE ((j_1.idclub = c.idclub) AND ((sp2.code)::text = 'P'::text))
          GROUP BY j_1.idjoueur, j_1.nom, j_1.prenom
          ORDER BY (count(*)) DESC
         LIMIT 1) AS joueur_plus_assidu,
    max(s.dateseance) AS derniere_activite
   FROM (((((public.club c
     LEFT JOIN public.joueur j ON ((c.idclub = j.idclub)))
     LEFT JOIN public.presence pres ON ((j.idjoueur = pres.idjoueur)))
     LEFT JOIN public.seance s ON ((pres.idseance = s.idseance)))
     LEFT JOIN public.typeseance ts ON ((s.idtypeseance = ts.idtypeseance)))
     LEFT JOIN public.statutpresence sp ON ((pres.idstatutpresence = sp.idstatutpresence)))
  WHERE (j.idstatutjoueur IN ( SELECT statutjoueur.idstatutjoueur
           FROM public.statutjoueur
          WHERE (statutjoueur.peutjouer = true)))
  GROUP BY c.idclub, c.nomclub
  ORDER BY c.nomclub;


ALTER VIEW public.vue_statistiques_presence_generales OWNER TO postgres;

--
-- TOC entry 4762 (class 2604 OID 115174)
-- Name: arbitrage idarbitrage; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.arbitrage ALTER COLUMN idarbitrage SET DEFAULT nextval('public.arbitrage_idarbitrage_seq'::regclass);


--
-- TOC entry 4760 (class 2604 OID 115157)
-- Name: arbitre idarbitre; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.arbitre ALTER COLUMN idarbitre SET DEFAULT nextval('public.arbitre_idarbitre_seq'::regclass);


--
-- TOC entry 4759 (class 2604 OID 115145)
-- Name: club idclub; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.club ALTER COLUMN idclub SET DEFAULT nextval('public.club_idclub_seq'::regclass);


--
-- TOC entry 4772 (class 2604 OID 115315)
-- Name: composition idcomposition; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.composition ALTER COLUMN idcomposition SET DEFAULT nextval('public.composition_idcomposition_seq'::regclass);


--
-- TOC entry 4763 (class 2604 OID 115201)
-- Name: joueur idjoueur; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.joueur ALTER COLUMN idjoueur SET DEFAULT nextval('public.joueur_idjoueur_seq'::regclass);


--
-- TOC entry 4768 (class 2604 OID 115290)
-- Name: matchfoot idmatch; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matchfoot ALTER COLUMN idmatch SET DEFAULT nextval('public.matchfoot_idmatch_seq'::regclass);


--
-- TOC entry 4754 (class 2604 OID 115100)
-- Name: niveauarbitre idniveauarbitre; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.niveauarbitre ALTER COLUMN idniveauarbitre SET DEFAULT nextval('public.niveauarbitre_idniveauarbitre_seq'::regclass);


--
-- TOC entry 4755 (class 2604 OID 115109)
-- Name: niveaumatch idniveaumatch; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.niveaumatch ALTER COLUMN idniveaumatch SET DEFAULT nextval('public.niveaumatch_idniveaumatch_seq'::regclass);


--
-- TOC entry 4756 (class 2604 OID 115118)
-- Name: piedfort idpiedfort; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.piedfort ALTER COLUMN idpiedfort SET DEFAULT nextval('public.piedfort_idpiedfort_seq'::regclass);


--
-- TOC entry 4749 (class 2604 OID 115061)
-- Name: poste idposte; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.poste ALTER COLUMN idposte SET DEFAULT nextval('public.poste_idposte_seq'::regclass);


--
-- TOC entry 4767 (class 2604 OID 115264)
-- Name: presence idpresence; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.presence ALTER COLUMN idpresence SET DEFAULT nextval('public.presence_idpresence_seq'::regclass);


--
-- TOC entry 4765 (class 2604 OID 115238)
-- Name: seance idseance; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seance ALTER COLUMN idseance SET DEFAULT nextval('public.seance_idseance_seq'::regclass);


--
-- TOC entry 4758 (class 2604 OID 115136)
-- Name: statutcomposition idstatutcomposition; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.statutcomposition ALTER COLUMN idstatutcomposition SET DEFAULT nextval('public.statutcomposition_idstatutcomposition_seq'::regclass);


--
-- TOC entry 4752 (class 2604 OID 115090)
-- Name: statutjoueur idstatutjoueur; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.statutjoueur ALTER COLUMN idstatutjoueur SET DEFAULT nextval('public.statutjoueur_idstatutjoueur_seq'::regclass);


--
-- TOC entry 4751 (class 2604 OID 115079)
-- Name: statutpresence idstatutpresence; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.statutpresence ALTER COLUMN idstatutpresence SET DEFAULT nextval('public.statutpresence_idstatutpresence_seq'::regclass);


--
-- TOC entry 4757 (class 2604 OID 115127)
-- Name: statutseance idstatutseance; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.statutseance ALTER COLUMN idstatutseance SET DEFAULT nextval('public.statutseance_idstatutseance_seq'::regclass);


--
-- TOC entry 4750 (class 2604 OID 115070)
-- Name: typeseance idtypeseance; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.typeseance ALTER COLUMN idtypeseance SET DEFAULT nextval('public.typeseance_idtypeseance_seq'::regclass);


--
-- TOC entry 5061 (class 0 OID 115171)
-- Dependencies: 240
-- Data for Name: arbitrage; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.arbitrage (idarbitrage, idarbitreprincipal, idarbitreassistant1, idarbitreassistant2, iddelegue, datecertification, idniveaumatch) FROM stdin;
\.


--
-- TOC entry 5059 (class 0 OID 115154)
-- Dependencies: 238
-- Data for Name: arbitre; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.arbitre (idarbitre, nom, prenom, datenaissance, licence, idniveauarbitre, telephone, email, datedebutarbitrage, matchesdiriges) FROM stdin;
\.


--
-- TOC entry 5057 (class 0 OID 115142)
-- Dependencies: 236
-- Data for Name: club; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.club (idclub, nomclub, ville, datecreation, couleurs, logo, email, motdepasse, telephone, adresse, president, datefondation, stadeprincipal, siteweb) FROM stdin;
1	Akademia Fanamby	Antananarivo	2020-05-15	Rouge et Blanc	https://example.com/logo-akademia.png	contact@akademiafanamby.mg	123456	+261 34 12 345 67	Stade Municipal, Avenue de l Ind‚pendance	Jean Rakotomalala	2020	Stade Municipal de Mahamasina	https://akademiafanamby.mg
\.


--
-- TOC entry 5071 (class 0 OID 115312)
-- Dependencies: 250
-- Data for Name: composition; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.composition (idcomposition, idmatch, idjoueur, idstatutcomposition, numeromaillot, "position", commentaire, iscapitaine) FROM stdin;
\.


--
-- TOC entry 5063 (class 0 OID 115198)
-- Dependencies: 242
-- Data for Name: joueur; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.joueur (idjoueur, idclub, idposte, idstatutjoueur, nom, prenom, datenaissance, lieunaissance, nationalite, idpiedfort, taille, poids, photo, numeromaillot, telephone, email, nompere, nommere, telparent, certificatmedical, datevaliditecertificat, numerolicence, dateinscription) FROM stdin;
7	1	3	1	Randriamihaja	Mahaliana Elie	2012-04-18	\N	Malagasy  	2	150	40	\N	\N	\N	fanambyakademia@gmail.com	\N	\N	\N	\N	\N	\N	2025-09-02
8	1	3	1	RANDRIANARISON 	Rico	2015-10-29	\N	Malagasy  	1	150	40	\N	\N	\N	fanambyakademia@gmail.com	\N	\N	\N	\N	\N	\N	2025-09-02
9	1	2	1	FAZAVANA	Abdoul(Rwalhayck)	2012-01-23	\N	M	1	150	36	\N	\N	\N	fanambyakademia@gmail.com	\N	\N	\N	\N	\N	\N	2025-09-02
10	1	2	1	TOAVINIRIANA 	Ywanne Prosper	2012-07-16	\N	Malagasy  	1	150	35	\N	\N	\N	fanambyakademia@gmail.com	\N	\N	\N	\N	\N	\N	2025-09-02
13	1	4	1	FAZAVANA	Abdou Kiffayattullah	2016-10-15	\N	Malagasy  	1	150	40	\N	\N	\N	fanambyakademia@gmail.com	\N	\N	\N	\N	\N	\N	2025-09-02
14	1	4	1	Rakotoarisoa Nomyh	Lanja Ny Aina Kevin	2011-09-16	\N	Malagasy  	1	150	37	\N	\N	\N	fanambyakademia@gmail.com	\N	\N	\N	\N	\N	\N	2025-09-02
15	1	4	1	RABENAH	Rio Zeidee	2015-01-22	\N	Malagasy  	1	150	39	\N	\N	\N	fanambyakademia@gmail.com	\N	\N	\N	\N	\N	\N	2025-09-02
16	1	4	1	ANDRIANANTENAINA	Ricardo	2013-02-23	\N	Malagasy  	1	148	35	\N	\N	\N	fanambyakademia@gmail.com	\N	\N	\N	\N	\N	\N	2025-09-02
17	1	3	1	RAVELOJAONA	Ritchy	2014-09-26	\N	Malagasy  	1	140	30	\N	\N	\N	fanambyakademia@gmail.com	\N	\N	\N	\N	\N	\N	2025-09-03
18	1	3	1	HERITIANA 	Andy Royanne	2014-02-21	\N	Malagasy  	1	150	40	\N	\N	\N	fanambyakademia@gmail.com	\N	\N	\N	\N	\N	\N	2025-09-03
19	1	3	1	RAVELOJAONA	Rica	2011-06-23	\N	Malagasy  	2	160	52	\N	\N	\N	fanambyakademia@gmail.com	\N	\N	\N	\N	\N	\N	2025-09-03
20	1	2	1	RAKOTOARISON	FANOMEZANTSOA Maicon	2012-11-09	\N	Malagasy  	1	153	45	\N	\N	\N	fanambyakademia@gmail.com	\N	\N	\N	\N	\N	\N	2025-09-03
21	1	4	1	RAZAKARISON	Andriniaina Tonny	2012-02-15	\N	Malagasy  	1	155	43	\N	\N	\N	fanambyakademia@gmail.com	\N	\N	\N	\N	\N	\N	2025-09-03
22	1	4	1	RAZAFIARIVONY	Jucot Henri	2012-10-29	\N	Malagasy  	1	150	45	\N	\N	\N	fanambyakademia@gmail.com	\N	\N	\N	\N	\N	\N	2025-09-03
23	1	4	1	RAKOTOMALALA	Gregoire	2011-03-13	\N	Malagasy  	1	150	40	\N	\N	\N	fanambyakademia@gmail.com	\N	\N	\N	\N	\N	\N	2025-09-03
25	1	4	1	ANRIAMAROMAMPIANINA	Isco Rodriguez	2015-02-16	\N	Malagasy  	1	150	40	\N	\N	\N	fanambyakademia@gmail.com	\N	\N	\N	\N	\N	\N	2025-09-03
26	1	4	1	VAHATRINIAINA	Nekena	2011-12-11	\N	Malagasy  	1	154	54	\N	\N	\N	fanambyakademia@gmail.com	\N	\N	\N	\N	\N	\N	2025-09-03
27	1	3	1	HARINASANDRATRA 	Sandaniaina Mirado	2014-06-29	\N	Malagasy  	1	150	42	\N	\N	\N	fanambyakademia@gmail.com	\N	\N	\N	\N	\N	\N	2025-09-03
12	1	4	1	RALAIARITIANA	Ravakiniaina Jean  Chris	2012-06-09	\N	Malagasy  	1	140	32	\N	\N	\N	fanambyakademia@gmail.com	\N	\N	\N	\N	\N	\N	2025-09-02
24	1	1	1	ANDRIANASOLO	Bruto Romual	2010-05-23	\N	Malagasy  	1	160	58	\N	\N	\N	fanambyakademia@gmail.com	\N	\N	\N	\N	\N	\N	2025-09-03
11	1	4	1	KANTONIAINA	Fiderana	2012-12-08	\N	Malagasy  	1	150	39	\N	\N	\N	fanambyakademia@gmail.com	\N	\N	\N	\N	\N	\N	2025-09-02
\.


--
-- TOC entry 5069 (class 0 OID 115287)
-- Dependencies: 248
-- Data for Name: matchfoot; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.matchfoot (idmatch, idseance, idarbitrage, competition, adversaire, domicile, scoreequipe, scoreadversaire, tempsadditionnel1, tempsadditionnel2, public, incidents, observations) FROM stdin;
\.


--
-- TOC entry 5047 (class 0 OID 115097)
-- Dependencies: 226
-- Data for Name: niveauarbitre; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.niveauarbitre (idniveauarbitre, libelle) FROM stdin;
1	Federal
2	Regional
3	Departemental
4	Jeune
\.


--
-- TOC entry 5049 (class 0 OID 115106)
-- Dependencies: 228
-- Data for Name: niveaumatch; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.niveaumatch (idniveaumatch, libelle) FROM stdin;
1	Regional
2	Departemental
3	Ligue
4	National
\.


--
-- TOC entry 5051 (class 0 OID 115115)
-- Dependencies: 230
-- Data for Name: piedfort; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.piedfort (idpiedfort, libelle) FROM stdin;
1	Droit
2	Gauche
3	Ambidextre
\.


--
-- TOC entry 5039 (class 0 OID 115058)
-- Dependencies: 218
-- Data for Name: poste; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.poste (idposte, libelle, description) FROM stdin;
1	Gardien	Joueur prot‚geant les buts
2	Defenseur	Joueur en d‚fense
3	Milieu	Joueur au milieu de terrain
4	Attaquant	Joueur en attaque
\.


--
-- TOC entry 5067 (class 0 OID 115261)
-- Dependencies: 246
-- Data for Name: presence; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.presence (idpresence, idseance, idjoueur, idstatutpresence, motifabsence, signature, heurearrivee, commentaires) FROM stdin;
18	2	12	1	\N	\N	\N	
19	2	7	1	\N	\N	\N	
20	2	13	1	\N	\N	\N	
21	2	11	1	\N	\N	\N	
22	2	9	1	\N	\N	\N	
23	2	8	1	\N	\N	\N	
24	2	10	1	\N	\N	\N	
25	2	16	1	\N	\N	\N	
26	2	15	1	\N	\N	\N	
27	2	14	1	\N	\N	\N	
\.


--
-- TOC entry 5065 (class 0 OID 115235)
-- Dependencies: 244
-- Data for Name: seance; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.seance (idseance, idclub, idtypeseance, dateseance, heuredebut, heurefin, lieu, objectif, bilan, idstatutseance) FROM stdin;
2	1	1	2025-08-03	07:30:00	09:00:00	sissi by pass	Entraimet de joueur		1
\.


--
-- TOC entry 5055 (class 0 OID 115133)
-- Dependencies: 234
-- Data for Name: statutcomposition; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.statutcomposition (idstatutcomposition, libelle) FROM stdin;
1	Titulaire
2	Rempla‡ant
3	Bless‚
4	Suspendu
5	Autre
\.


--
-- TOC entry 5045 (class 0 OID 115087)
-- Dependencies: 224
-- Data for Name: statutjoueur; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.statutjoueur (idstatutjoueur, libelle, peutjouer) FROM stdin;
1	Actif	t
2	Bless‚	f
3	Suspendu	f
4	Inactif	f
5	En convalescence	f
\.


--
-- TOC entry 5043 (class 0 OID 115076)
-- Dependencies: 222
-- Data for Name: statutpresence; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.statutpresence (idstatutpresence, libelle, code) FROM stdin;
1	Present	P
2	Absent	A
3	Retard	R
4	Excus‚	E
\.


--
-- TOC entry 5053 (class 0 OID 115124)
-- Dependencies: 232
-- Data for Name: statutseance; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.statutseance (idstatutseance, libelle) FROM stdin;
1	Planifi‚
2	R‚alis‚
3	Annul‚
\.


--
-- TOC entry 5041 (class 0 OID 115067)
-- Dependencies: 220
-- Data for Name: typeseance; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.typeseance (idtypeseance, libelle, description) FROM stdin;
1	Entrainement	S‚ance d entraŒnement r‚guliŠre
2	Match amical	Match sans enjeu comp‚titif
3	Match officiel	Match de championnat ou coupe
4	Seance physique	S‚ance ax‚e sur la condition physique
5	Seance tactique	S‚ance ax‚e sur la tactique d ‚quipe
\.


--
-- TOC entry 5095 (class 0 OID 0)
-- Dependencies: 239
-- Name: arbitrage_idarbitrage_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.arbitrage_idarbitrage_seq', 1, false);


--
-- TOC entry 5096 (class 0 OID 0)
-- Dependencies: 237
-- Name: arbitre_idarbitre_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.arbitre_idarbitre_seq', 1, false);


--
-- TOC entry 5097 (class 0 OID 0)
-- Dependencies: 235
-- Name: club_idclub_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.club_idclub_seq', 1, true);


--
-- TOC entry 5098 (class 0 OID 0)
-- Dependencies: 249
-- Name: composition_idcomposition_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.composition_idcomposition_seq', 1, true);


--
-- TOC entry 5099 (class 0 OID 0)
-- Dependencies: 241
-- Name: joueur_idjoueur_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.joueur_idjoueur_seq', 27, true);


--
-- TOC entry 5100 (class 0 OID 0)
-- Dependencies: 247
-- Name: matchfoot_idmatch_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.matchfoot_idmatch_seq', 1, true);


--
-- TOC entry 5101 (class 0 OID 0)
-- Dependencies: 225
-- Name: niveauarbitre_idniveauarbitre_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.niveauarbitre_idniveauarbitre_seq', 4, true);


--
-- TOC entry 5102 (class 0 OID 0)
-- Dependencies: 227
-- Name: niveaumatch_idniveaumatch_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.niveaumatch_idniveaumatch_seq', 4, true);


--
-- TOC entry 5103 (class 0 OID 0)
-- Dependencies: 229
-- Name: piedfort_idpiedfort_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.piedfort_idpiedfort_seq', 3, true);


--
-- TOC entry 5104 (class 0 OID 0)
-- Dependencies: 217
-- Name: poste_idposte_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.poste_idposte_seq', 4, true);


--
-- TOC entry 5105 (class 0 OID 0)
-- Dependencies: 245
-- Name: presence_idpresence_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.presence_idpresence_seq', 27, true);


--
-- TOC entry 5106 (class 0 OID 0)
-- Dependencies: 243
-- Name: seance_idseance_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seance_idseance_seq', 3, true);


--
-- TOC entry 5107 (class 0 OID 0)
-- Dependencies: 233
-- Name: statutcomposition_idstatutcomposition_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.statutcomposition_idstatutcomposition_seq', 5, true);


--
-- TOC entry 5108 (class 0 OID 0)
-- Dependencies: 223
-- Name: statutjoueur_idstatutjoueur_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.statutjoueur_idstatutjoueur_seq', 5, true);


--
-- TOC entry 5109 (class 0 OID 0)
-- Dependencies: 221
-- Name: statutpresence_idstatutpresence_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.statutpresence_idstatutpresence_seq', 4, true);


--
-- TOC entry 5110 (class 0 OID 0)
-- Dependencies: 231
-- Name: statutseance_idstatutseance_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.statutseance_idstatutseance_seq', 3, true);


--
-- TOC entry 5111 (class 0 OID 0)
-- Dependencies: 219
-- Name: typeseance_idtypeseance_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.typeseance_idtypeseance_seq', 5, true);


--
-- TOC entry 4837 (class 2606 OID 115176)
-- Name: arbitrage arbitrage_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.arbitrage
    ADD CONSTRAINT arbitrage_pkey PRIMARY KEY (idarbitrage);


--
-- TOC entry 4831 (class 2606 OID 115162)
-- Name: arbitre arbitre_licence_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.arbitre
    ADD CONSTRAINT arbitre_licence_key UNIQUE (licence);


--
-- TOC entry 4833 (class 2606 OID 115160)
-- Name: arbitre arbitre_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.arbitre
    ADD CONSTRAINT arbitre_pkey PRIMARY KEY (idarbitre);


--
-- TOC entry 4827 (class 2606 OID 115152)
-- Name: club club_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.club
    ADD CONSTRAINT club_email_key UNIQUE (email);


--
-- TOC entry 4829 (class 2606 OID 115150)
-- Name: club club_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.club
    ADD CONSTRAINT club_pkey PRIMARY KEY (idclub);


--
-- TOC entry 4860 (class 2606 OID 115321)
-- Name: composition composition_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.composition
    ADD CONSTRAINT composition_pkey PRIMARY KEY (idcomposition);


--
-- TOC entry 4839 (class 2606 OID 115213)
-- Name: joueur joueur_numerolicence_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.joueur
    ADD CONSTRAINT joueur_numerolicence_key UNIQUE (numerolicence);


--
-- TOC entry 4841 (class 2606 OID 115211)
-- Name: joueur joueur_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.joueur
    ADD CONSTRAINT joueur_pkey PRIMARY KEY (idjoueur);


--
-- TOC entry 4858 (class 2606 OID 115300)
-- Name: matchfoot matchfoot_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matchfoot
    ADD CONSTRAINT matchfoot_pkey PRIMARY KEY (idmatch);


--
-- TOC entry 4806 (class 2606 OID 115104)
-- Name: niveauarbitre niveauarbitre_libelle_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.niveauarbitre
    ADD CONSTRAINT niveauarbitre_libelle_key UNIQUE (libelle);


--
-- TOC entry 4808 (class 2606 OID 115102)
-- Name: niveauarbitre niveauarbitre_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.niveauarbitre
    ADD CONSTRAINT niveauarbitre_pkey PRIMARY KEY (idniveauarbitre);


--
-- TOC entry 4810 (class 2606 OID 115113)
-- Name: niveaumatch niveaumatch_libelle_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.niveaumatch
    ADD CONSTRAINT niveaumatch_libelle_key UNIQUE (libelle);


--
-- TOC entry 4812 (class 2606 OID 115111)
-- Name: niveaumatch niveaumatch_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.niveaumatch
    ADD CONSTRAINT niveaumatch_pkey PRIMARY KEY (idniveaumatch);


--
-- TOC entry 4814 (class 2606 OID 115122)
-- Name: piedfort piedfort_libelle_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.piedfort
    ADD CONSTRAINT piedfort_libelle_key UNIQUE (libelle);


--
-- TOC entry 4816 (class 2606 OID 115120)
-- Name: piedfort piedfort_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.piedfort
    ADD CONSTRAINT piedfort_pkey PRIMARY KEY (idpiedfort);


--
-- TOC entry 4786 (class 2606 OID 115065)
-- Name: poste poste_libelle_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.poste
    ADD CONSTRAINT poste_libelle_key UNIQUE (libelle);


--
-- TOC entry 4788 (class 2606 OID 115063)
-- Name: poste poste_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.poste
    ADD CONSTRAINT poste_pkey PRIMARY KEY (idposte);


--
-- TOC entry 4852 (class 2606 OID 115268)
-- Name: presence presence_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.presence
    ADD CONSTRAINT presence_pkey PRIMARY KEY (idpresence);


--
-- TOC entry 4847 (class 2606 OID 115244)
-- Name: seance seance_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seance
    ADD CONSTRAINT seance_pkey PRIMARY KEY (idseance);


--
-- TOC entry 4823 (class 2606 OID 115140)
-- Name: statutcomposition statutcomposition_libelle_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.statutcomposition
    ADD CONSTRAINT statutcomposition_libelle_key UNIQUE (libelle);


--
-- TOC entry 4825 (class 2606 OID 115138)
-- Name: statutcomposition statutcomposition_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.statutcomposition
    ADD CONSTRAINT statutcomposition_pkey PRIMARY KEY (idstatutcomposition);


--
-- TOC entry 4802 (class 2606 OID 115095)
-- Name: statutjoueur statutjoueur_libelle_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.statutjoueur
    ADD CONSTRAINT statutjoueur_libelle_key UNIQUE (libelle);


--
-- TOC entry 4804 (class 2606 OID 115093)
-- Name: statutjoueur statutjoueur_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.statutjoueur
    ADD CONSTRAINT statutjoueur_pkey PRIMARY KEY (idstatutjoueur);


--
-- TOC entry 4796 (class 2606 OID 115085)
-- Name: statutpresence statutpresence_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.statutpresence
    ADD CONSTRAINT statutpresence_code_key UNIQUE (code);


--
-- TOC entry 4798 (class 2606 OID 115083)
-- Name: statutpresence statutpresence_libelle_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.statutpresence
    ADD CONSTRAINT statutpresence_libelle_key UNIQUE (libelle);


--
-- TOC entry 4800 (class 2606 OID 115081)
-- Name: statutpresence statutpresence_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.statutpresence
    ADD CONSTRAINT statutpresence_pkey PRIMARY KEY (idstatutpresence);


--
-- TOC entry 4819 (class 2606 OID 115131)
-- Name: statutseance statutseance_libelle_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.statutseance
    ADD CONSTRAINT statutseance_libelle_key UNIQUE (libelle);


--
-- TOC entry 4821 (class 2606 OID 115129)
-- Name: statutseance statutseance_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.statutseance
    ADD CONSTRAINT statutseance_pkey PRIMARY KEY (idstatutseance);


--
-- TOC entry 4791 (class 2606 OID 115074)
-- Name: typeseance typeseance_libelle_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.typeseance
    ADD CONSTRAINT typeseance_libelle_key UNIQUE (libelle);


--
-- TOC entry 4793 (class 2606 OID 115072)
-- Name: typeseance typeseance_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.typeseance
    ADD CONSTRAINT typeseance_pkey PRIMARY KEY (idtypeseance);


--
-- TOC entry 4835 (class 2606 OID 115164)
-- Name: arbitre unq_arbitre; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.arbitre
    ADD CONSTRAINT unq_arbitre UNIQUE (nom, prenom, datenaissance);


--
-- TOC entry 4865 (class 2606 OID 115323)
-- Name: composition unq_composition; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.composition
    ADD CONSTRAINT unq_composition UNIQUE (idmatch, idjoueur);


--
-- TOC entry 4854 (class 2606 OID 115270)
-- Name: presence unq_presence; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.presence
    ADD CONSTRAINT unq_presence UNIQUE (idseance, idjoueur);


--
-- TOC entry 4861 (class 1259 OID 115378)
-- Name: idx_composition_joueur; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_composition_joueur ON public.composition USING btree (idjoueur);


--
-- TOC entry 4862 (class 1259 OID 115377)
-- Name: idx_composition_match; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_composition_match ON public.composition USING btree (idmatch);


--
-- TOC entry 4863 (class 1259 OID 115379)
-- Name: idx_composition_statut; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_composition_statut ON public.composition USING btree (idstatutcomposition);


--
-- TOC entry 4855 (class 1259 OID 115376)
-- Name: idx_match_arbitrage; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_match_arbitrage ON public.matchfoot USING btree (idarbitrage);


--
-- TOC entry 4856 (class 1259 OID 115375)
-- Name: idx_match_seance; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_match_seance ON public.matchfoot USING btree (idseance);


--
-- TOC entry 4848 (class 1259 OID 115374)
-- Name: idx_presence_joueur; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_presence_joueur ON public.presence USING btree (idjoueur);


--
-- TOC entry 4849 (class 1259 OID 115372)
-- Name: idx_presence_seance; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_presence_seance ON public.presence USING btree (idseance);


--
-- TOC entry 4850 (class 1259 OID 115373)
-- Name: idx_presence_statut; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_presence_statut ON public.presence USING btree (idstatutpresence);


--
-- TOC entry 4842 (class 1259 OID 115370)
-- Name: idx_seance_club; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_seance_club ON public.seance USING btree (idclub);


--
-- TOC entry 4843 (class 1259 OID 115369)
-- Name: idx_seance_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_seance_date ON public.seance USING btree (dateseance);


--
-- TOC entry 4844 (class 1259 OID 115371)
-- Name: idx_seance_statut; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_seance_statut ON public.seance USING btree (idstatutseance);


--
-- TOC entry 4845 (class 1259 OID 115368)
-- Name: idx_seance_type_seance; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_seance_type_seance ON public.seance USING btree (idtypeseance);


--
-- TOC entry 4794 (class 1259 OID 115367)
-- Name: idx_statut_presence_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_statut_presence_code ON public.statutpresence USING btree (code);


--
-- TOC entry 4817 (class 1259 OID 115381)
-- Name: idx_statut_seance_libelle; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_statut_seance_libelle ON public.statutseance USING btree (libelle);


--
-- TOC entry 4789 (class 1259 OID 115380)
-- Name: idx_type_seance_libelle; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_type_seance_libelle ON public.typeseance USING btree (libelle);


--
-- TOC entry 4867 (class 2606 OID 115187)
-- Name: arbitrage arbitrage_idarbitreassistant1_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.arbitrage
    ADD CONSTRAINT arbitrage_idarbitreassistant1_fkey FOREIGN KEY (idarbitreassistant1) REFERENCES public.arbitre(idarbitre);


--
-- TOC entry 4868 (class 2606 OID 115192)
-- Name: arbitrage arbitrage_idarbitreassistant2_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.arbitrage
    ADD CONSTRAINT arbitrage_idarbitreassistant2_fkey FOREIGN KEY (idarbitreassistant2) REFERENCES public.arbitre(idarbitre);


--
-- TOC entry 4869 (class 2606 OID 115182)
-- Name: arbitrage arbitrage_idarbitreprincipal_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.arbitrage
    ADD CONSTRAINT arbitrage_idarbitreprincipal_fkey FOREIGN KEY (idarbitreprincipal) REFERENCES public.arbitre(idarbitre);


--
-- TOC entry 4870 (class 2606 OID 115177)
-- Name: arbitrage arbitrage_idniveaumatch_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.arbitrage
    ADD CONSTRAINT arbitrage_idniveaumatch_fkey FOREIGN KEY (idniveaumatch) REFERENCES public.niveaumatch(idniveaumatch);


--
-- TOC entry 4866 (class 2606 OID 115165)
-- Name: arbitre arbitre_idniveauarbitre_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.arbitre
    ADD CONSTRAINT arbitre_idniveauarbitre_fkey FOREIGN KEY (idniveauarbitre) REFERENCES public.niveauarbitre(idniveauarbitre);


--
-- TOC entry 4883 (class 2606 OID 115329)
-- Name: composition composition_idjoueur_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.composition
    ADD CONSTRAINT composition_idjoueur_fkey FOREIGN KEY (idjoueur) REFERENCES public.joueur(idjoueur);


--
-- TOC entry 4884 (class 2606 OID 115324)
-- Name: composition composition_idmatch_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.composition
    ADD CONSTRAINT composition_idmatch_fkey FOREIGN KEY (idmatch) REFERENCES public.matchfoot(idmatch);


--
-- TOC entry 4885 (class 2606 OID 115334)
-- Name: composition composition_idstatutcomposition_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.composition
    ADD CONSTRAINT composition_idstatutcomposition_fkey FOREIGN KEY (idstatutcomposition) REFERENCES public.statutcomposition(idstatutcomposition);


--
-- TOC entry 4871 (class 2606 OID 115214)
-- Name: joueur joueur_idclub_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.joueur
    ADD CONSTRAINT joueur_idclub_fkey FOREIGN KEY (idclub) REFERENCES public.club(idclub);


--
-- TOC entry 4872 (class 2606 OID 115229)
-- Name: joueur joueur_idpiedfort_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.joueur
    ADD CONSTRAINT joueur_idpiedfort_fkey FOREIGN KEY (idpiedfort) REFERENCES public.piedfort(idpiedfort);


--
-- TOC entry 4873 (class 2606 OID 115219)
-- Name: joueur joueur_idposte_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.joueur
    ADD CONSTRAINT joueur_idposte_fkey FOREIGN KEY (idposte) REFERENCES public.poste(idposte);


--
-- TOC entry 4874 (class 2606 OID 115224)
-- Name: joueur joueur_idstatutjoueur_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.joueur
    ADD CONSTRAINT joueur_idstatutjoueur_fkey FOREIGN KEY (idstatutjoueur) REFERENCES public.statutjoueur(idstatutjoueur);


--
-- TOC entry 4881 (class 2606 OID 115306)
-- Name: matchfoot matchfoot_idarbitrage_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matchfoot
    ADD CONSTRAINT matchfoot_idarbitrage_fkey FOREIGN KEY (idarbitrage) REFERENCES public.arbitrage(idarbitrage);


--
-- TOC entry 4882 (class 2606 OID 115301)
-- Name: matchfoot matchfoot_idseance_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matchfoot
    ADD CONSTRAINT matchfoot_idseance_fkey FOREIGN KEY (idseance) REFERENCES public.seance(idseance);


--
-- TOC entry 4878 (class 2606 OID 115276)
-- Name: presence presence_idjoueur_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.presence
    ADD CONSTRAINT presence_idjoueur_fkey FOREIGN KEY (idjoueur) REFERENCES public.joueur(idjoueur);


--
-- TOC entry 4879 (class 2606 OID 115271)
-- Name: presence presence_idseance_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.presence
    ADD CONSTRAINT presence_idseance_fkey FOREIGN KEY (idseance) REFERENCES public.seance(idseance);


--
-- TOC entry 4880 (class 2606 OID 115281)
-- Name: presence presence_idstatutpresence_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.presence
    ADD CONSTRAINT presence_idstatutpresence_fkey FOREIGN KEY (idstatutpresence) REFERENCES public.statutpresence(idstatutpresence);


--
-- TOC entry 4875 (class 2606 OID 115245)
-- Name: seance seance_idclub_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seance
    ADD CONSTRAINT seance_idclub_fkey FOREIGN KEY (idclub) REFERENCES public.club(idclub);


--
-- TOC entry 4876 (class 2606 OID 115255)
-- Name: seance seance_idstatutseance_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seance
    ADD CONSTRAINT seance_idstatutseance_fkey FOREIGN KEY (idstatutseance) REFERENCES public.statutseance(idstatutseance);


--
-- TOC entry 4877 (class 2606 OID 115250)
-- Name: seance seance_idtypeseance_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seance
    ADD CONSTRAINT seance_idtypeseance_fkey FOREIGN KEY (idtypeseance) REFERENCES public.typeseance(idtypeseance);


--
-- TOC entry 5077 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT ALL ON SCHEMA public TO fanamby;


-- Completed on 2025-09-08 18:58:56

--
-- PostgreSQL database dump complete
--

