--
-- PostgreSQL database dump
--

-- Dumped from database version 14.0
-- Dumped by pg_dump version 14.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: decrease_players_amount(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE database proj;
\c proj

CREATE FUNCTION public.decrease_players_amount() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
UPDATE worlds
SET amount_of_players = amount_of_players - 1
WHERE OLD.world_name = worlds.world_name;
return OLD;
END;
$$;


ALTER FUNCTION public.decrease_players_amount() OWNER TO postgres;

--
-- Name: decrease_race_amount(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.decrease_race_amount() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
UPDATE races
SET amount_of_players = amount_of_players -1
WHERE OLD.race = races.race;
return OLD;
END;
$$;


ALTER FUNCTION public.decrease_race_amount() OWNER TO postgres;

--
-- Name: update_players_amount(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_players_amount() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
UPDATE worlds
SET amount_of_players = amount_of_players +1
WHERE NEW.world_name = worlds.world_name;
return NEW;
END;
$$;


ALTER FUNCTION public.update_players_amount() OWNER TO postgres;

--
-- Name: update_race_amount(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_race_amount() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
UPDATE races
SET amount_of_players = amount_of_players +1
WHERE NEW.race = races.race;
return NEW;
END;
$$;


ALTER FUNCTION public.update_race_amount() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: characters; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.characters (
    id bigint NOT NULL,
    character_name character varying(50) NOT NULL,
    race character varying(20) NOT NULL,
    class character varying(30) NOT NULL,
    level integer NOT NULL,
    world_name character varying(50) NOT NULL,
    mount_name character varying(50),
    CONSTRAINT characters_class_check CHECK (((class)::text = ANY ((ARRAY['warrior'::character varying, 'archer'::character varying, 'mage'::character varying, 'priest'::character varying, 'necromancer'::character varying, 'paladin'::character varying, 'thief'::character varying, 'monk'::character varying, 'berserk'::character varying, 'knight'::character varying, 'summoner'::character varying])::text[]))),
    CONSTRAINT characters_race_check CHECK (((race)::text = ANY ((ARRAY['ork'::character varying, 'elf'::character varying, 'night_elf'::character varying, 'dwarf'::character varying, 'human'::character varying, 'undead'::character varying, 'goblin'::character varying])::text[]))),
    CONSTRAINT characters_world_name_check CHECK (((world_name)::text = ANY ((ARRAY['Undeads_uprising'::character varying, 'New_Kingdom'::character varying, 'Call_of_Horde'::character varying, 'Beautiful_forest'::character varying, 'Mountains'::character varying, 'Balanced_1'::character varying, 'Balanced_2'::character varying])::text[]))),
    CONSTRAINT level_range_check CHECK (((level >= 0) AND (level <= 250)))
);


ALTER TABLE public.characters OWNER TO postgres;

--
-- Name: characters_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.characters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.characters_id_seq OWNER TO postgres;

--
-- Name: characters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.characters_id_seq OWNED BY public.characters.id;


--
-- Name: classes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.classes (
    class character varying(20) NOT NULL,
    specification character varying(50) NOT NULL,
    main_ability character varying(50) NOT NULL,
    passive_ability character varying(50) NOT NULL,
    ultimate_ability character varying(50) NOT NULL,
    cooldown_of_main_ability integer NOT NULL,
    cooldown_of_ultimate_ability integer NOT NULL,
    CONSTRAINT classes_class_check CHECK (((class)::text = ANY ((ARRAY['warrior'::character varying, 'archer'::character varying, 'mage'::character varying, 'priest'::character varying, 'necromancer'::character varying, 'paladin'::character varying, 'thief'::character varying, 'monk'::character varying, 'berserk'::character varying, 'knight'::character varying, 'summoner'::character varying])::text[])))
);


ALTER TABLE public.classes OWNER TO postgres;

--
-- Name: races; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.races (
    race character varying(20) NOT NULL,
    health_limit character varying(75) NOT NULL,
    speed_limit character varying(75) NOT NULL,
    amount_of_players integer,
    CONSTRAINT races_race_check CHECK (((race)::text = ANY ((ARRAY['ork'::character varying, 'elf'::character varying, 'night_elf'::character varying, 'dwarf'::character varying, 'human'::character varying, 'undead'::character varying, 'goblin'::character varying])::text[])))
);


ALTER TABLE public.races OWNER TO postgres;

--
-- Name: worlds; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.worlds (
    world_name character varying(50) NOT NULL,
    script character varying(100) NOT NULL,
    amount_of_players integer,
    CONSTRAINT worlds_world_name_check CHECK (((world_name)::text = ANY ((ARRAY['Undeads_uprising'::character varying, 'New_Kingdom'::character varying, 'Call_of_Horde'::character varying, 'Beautiful_forest'::character varying, 'Mountains'::character varying, 'Balanced_1'::character varying, 'Balanced_2'::character varying])::text[])))
);


ALTER TABLE public.worlds OWNER TO postgres;

--
-- Name: characters id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.characters ALTER COLUMN id SET DEFAULT nextval('public.characters_id_seq'::regclass);


--
-- Data for Name: characters; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.characters (id, character_name, race, class, level, world_name, mount_name) FROM stdin;
1	legion_commander	human	warrior	9	Balanced_1	bodyblock
2	true_gamer	human	warrior	52	Balanced_1	Plotva
3	Kolya	goblin	thief	23	Balanced_2	PuckTail
4	Ar4il	elf	priest	14	Balanced_2	Pasha
5	YokoKoKo	undead	summoner	36	Balanced_2	Hrumka
6	Herobrine	dwarf	monk	22	Balanced_2	TabUr3tka
7	Lil_4i4a	human	mage	61	Balanced_2	PepePig
9	Charl13	ork	knight	49	Balanced_2	GoToAmsterdam
10	ChebUp3l1	ork	berserk	35	Balanced_2	WereFast
11	Cesarb	undead	necromancer	37	Balanced_1	GasGasGas
12	Chopper	elf	priest	38	Balanced_1	CottonCandy
13	Last_Hero	human	thief	9	Balanced_1	Winner
14	Tonakai	dwarf	monk	11	Balanced_1	MotaMota
15	Lulich	goblin	monk	47	Call_of_Horde	myHorse
16	zaOrdu	ork	berserk	32	Call_of_Horde	BuiVOl
17	zaAliance	human	knight	27	Call_of_Horde	S0Fast
18	<blank>	night_elf	necromancer	10	Call_of_Horde	<TypeName>
19	IgroMan	night_elf	mage	6	Call_of_Horde	SeriousSam
20	Phashska	goblin	archer	23	New_Kingdom	Jashi
21	Qusatr	ork	knight	55	New_Kingdom	Rmbr
23	Nayne	ork	necromancer	5	New_Kingdom	Sallermon
24	Back	undead	mage	21	New_Kingdom	Kondazi
25	Visap	undead	archer	23	Undeads_uprising	Jenterri
26	Flosellano	undead	necromancer	44	Undeads_uprising	Hallang
27	Quissan	night_elf	knight	8	Undeads_uprising	Oshuonol
28	Siett	dwarf	archer	9	Undeads_uprising	Ceyandam
29	Zizzyt	human	warrior	26	Undeads_uprising	Xthisie
30	Quriamos	elf	archer	35	Beautiful_forest	Zosarvamm
31	Franav	night_elf	knight	41	Beautiful_forest	Gum
32	Zeridra	ork	knight	17	Beautiful_forest	Jeabeto
33	Havis	goblin	necromancer	15	Beautiful_forest	Benn
34	Banan	elf	berserk	21	Beautiful_forest	Fearaqu
35	Ierkedr	goblin	archer	33	Mountains	Ipattored
36	Isiz	dwarf	mage	45	Mountains	Zavasama
37	Qulennand	dwarf	summoner	27	Mountains	Kycenan
38	Tidada	ork	priest	30	Mountains	Bas
39	Eand	undead	thief	21	Mountains	Owndylei
40	CartMan	goblin	berserk	1	Balanced_1	KFhorse
41	Zelda	elf	summoner	1	Balanced_1	Zalnet
22	Luffy	human	knight	7	New_Kingdom	Alini
8	DimaasBer	night_elf	archer	12	Balanced_2	myLovelyHorse
\.


--
-- Data for Name: classes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.classes (class, specification, main_ability, passive_ability, ultimate_ability, cooldown_of_main_ability, cooldown_of_ultimate_ability) FROM stdin;
warrior	fighter	hits with a shield and stunning nearest enemy	increases melee damage 1.2*level	create an arena(1.5*all atributes)	5	60
archer	killer	shoots a frozen arrow.Stun for 3sec	increases ranged dmg 1.1*level	arrows receive elemental damage	8	70
mage	caster	casts a spell from the magic book	increase damage from chosen element	creates an elemental field with certain effect	5	10
priest	support/caster	applies a shield and heals 20%	5% chance to avoid damage	create an arena(heal 2%/sec)	9	60
necromancer	caster/specialist	uses a soul to spawn an undead	every enemies drop soul after death	revives allies for 10 seconds	5	80
paladin	fighter/support	all hits heal allies for 1% (1m range)	every hit can randomly stun every 10 sec	give all nearest allies bonus defence	5	60
thief	killer/support	all enemies in range 5m gain effect of bleeding	every hit can randomly steal some gold every 15s	imposes a disguise effect on closest allies	4	45
monk	support	give random buff	gives 2% of bonus health in 2m range	Disarms opponents for 5 seconds	3	65
berserk	fighter/killer	throws his axes 2 m ahead	every 2% of lost hp gain 3% of damage and defence	imposes a vampirism effect on closest allies	5	60
knight	fighter/protector	increase defence of closest allies for 5%	all damage coming from the front is reduced by 5%	gives his passive ability on closest allies for10s	8	65
summoner	caster/specialist	summone special creature	increases damage of all summoned units for 3%	improves creatures atributes(1.7*all atributes)	5	60
\.


--
-- Data for Name: races; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.races (race, health_limit, speed_limit, amount_of_players) FROM stdin;
human	1.25*level^2*30	1.3*level + 10	7
night_elf	1.25*level^2*20	1.3*level + 11	5
dwarf	1.3*level^2*40	1.2*level + 6	5
undead	1.20*level^2*30	1.2*level + 9	6
goblin	1.15*level^2*15	1.5*level + 15	6
elf	1.2*level^2*20	1.35*level + 12	5
ork	1.35*level^2*50	1.1*level + 8	7
\.


--
-- Data for Name: worlds; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.worlds (world_name, script, amount_of_players) FROM stdin;
Balanced_2	No privileges. All races are in the same conditions	8
Call_of_Horde	Orks and Goblins have a special spawn.Speed and damage bonus on native earth.Others need to survive 	5
New_Kingdom	New king ascended the throne. Humans can support him or try to overthrow.Alliances is available	5
Undeads_uprising	Undead have a special spawn.Damage bonus on native earth.Cooldown of main ability of undead is1 less	5
Beautiful_forest	Elfs have a special spawn. Damage, speed and health bonus on native earth	5
Mountains	Entire world is an earth of dwarfs. Claim all the treasure of dwarfs or help them with protection	5
Balanced_1	No privileges. All races are in the same conditions	8
\.


--
-- Name: characters_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.characters_id_seq', 1, false);


--
-- Name: characters characters_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.characters
    ADD CONSTRAINT characters_pkey PRIMARY KEY (id);


--
-- Name: classes classes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT classes_pkey PRIMARY KEY (class);


--
-- Name: characters umountname; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.characters
    ADD CONSTRAINT umountname UNIQUE (mount_name);


--
-- Name: characters unickname; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.characters
    ADD CONSTRAINT unickname UNIQUE (character_name);


--
-- Name: worlds worlds_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.worlds
    ADD CONSTRAINT worlds_pkey PRIMARY KEY (world_name);


--
-- Name: nickname; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX nickname ON public.characters USING btree (character_name);


--
-- Name: characters race_decrease_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER race_decrease_trigger BEFORE DELETE ON public.characters FOR EACH ROW EXECUTE FUNCTION public.decrease_race_amount();


--
-- Name: characters race_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER race_trigger AFTER INSERT ON public.characters FOR EACH ROW EXECUTE FUNCTION public.update_race_amount();


--
-- Name: characters world_decrease_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER world_decrease_trigger BEFORE DELETE ON public.characters FOR EACH ROW EXECUTE FUNCTION public.decrease_players_amount();


--
-- Name: characters world_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER world_trigger AFTER INSERT ON public.characters FOR EACH ROW EXECUTE FUNCTION public.update_players_amount();


--
-- PostgreSQL database dump complete
--

