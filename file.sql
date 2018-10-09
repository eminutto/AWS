
CREATE DATABASE "IP_DB" WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8';


ALTER DATABASE "IP_DB" OWNER TO dbusername_1;

\connect "IP_DB"

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 3796 (class 0 OID 0)
-- Dependencies: 3795
-- Name: DATABASE "IP_DB"; Type: COMMENT; Schema: -; Owner: dbusername_1
--

COMMENT ON DATABASE "IP_DB" IS 'Blocked IP Database';


--
-- TOC entry 1 (class 3079 OID 13920)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 3799 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 196 (class 1259 OID 16409)
-- Name: blocked_ips; Type: TABLE; Schema: public; Owner: dbusername_1
--

CREATE TABLE public.blocked_ips (
    id serial NOT NULL,
    ip_address inet NOT NULL,
    date_block timestamp with time zone NOT NULL
);


ALTER TABLE public.blocked_ips OWNER TO dbusername_1;

--
-- TOC entry 3789 (class 0 OID 16409)
-- Dependencies: 196
-- Data for Name: blocked_ips; Type: TABLE DATA; Schema: public; Owner: dbusername_1
--



--
-- TOC entry 3665 (class 2606 OID 16416)
-- Name: blocked_ips blocked_ips_pkey; Type: CONSTRAINT; Schema: public; Owner: dbusername_1
--

ALTER TABLE ONLY public.blocked_ips
    ADD CONSTRAINT blocked_ips_pkey PRIMARY KEY (id);


--
-- TOC entry 3667 (class 2606 OID 16418)
-- Name: blocked_ips unique_ip; Type: CONSTRAINT; Schema: public; Owner: dbusername_1
--

ALTER TABLE ONLY public.blocked_ips
    ADD CONSTRAINT unique_ip UNIQUE (ip_address);


--
-- TOC entry 3798 (class 0 OID 0)
-- Dependencies: 3
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: dbusername_1
--

REVOKE ALL ON SCHEMA public FROM rdsadmin;
REVOKE ALL ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO dbusername_1;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2018-10-02 13:29:15

--
-- PostgreSQL database dump complete
--

