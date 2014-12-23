--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: currency; Type: DOMAIN; Schema: public; Owner: -
--

CREATE DOMAIN currency AS numeric NOT NULL DEFAULT 0;


--
-- Name: non_negative_currency; Type: DOMAIN; Schema: public; Owner: -
--

CREATE DOMAIN non_negative_currency AS numeric NOT NULL DEFAULT 0
	CONSTRAINT non_negative CHECK ((VALUE >= (0)::numeric));


--
-- Name: non_positive_currency; Type: DOMAIN; Schema: public; Owner: -
--

CREATE DOMAIN non_positive_currency AS numeric NOT NULL DEFAULT 0
	CONSTRAINT non_positive CHECK ((VALUE <= (0)::numeric));


--
-- Name: positive_currency; Type: DOMAIN; Schema: public; Owner: -
--

CREATE DOMAIN positive_currency AS numeric NOT NULL DEFAULT 0
	CONSTRAINT non_negative CHECK ((VALUE > (0)::numeric));


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: control_accounts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE control_accounts (
    id bigint NOT NULL,
    name text NOT NULL,
    balance currency,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: control_accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE control_accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: control_accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE control_accounts_id_seq OWNED BY control_accounts.id;


--
-- Name: customer_accounts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE customer_accounts (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    type text NOT NULL,
    balance non_negative_currency,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: customer_accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE customer_accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: customer_accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE customer_accounts_id_seq OWNED BY customer_accounts.id;


--
-- Name: customer_accounts_user_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE customer_accounts_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: customer_accounts_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE customer_accounts_user_id_seq OWNED BY customer_accounts.user_id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY control_accounts ALTER COLUMN id SET DEFAULT nextval('control_accounts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY customer_accounts ALTER COLUMN id SET DEFAULT nextval('customer_accounts_id_seq'::regclass);


--
-- Name: user_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY customer_accounts ALTER COLUMN user_id SET DEFAULT nextval('customer_accounts_user_id_seq'::regclass);


--
-- Name: control_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY control_accounts
    ADD CONSTRAINT control_accounts_pkey PRIMARY KEY (id);


--
-- Name: customer_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY customer_accounts
    ADD CONSTRAINT customer_accounts_pkey PRIMARY KEY (id);


--
-- Name: customer_accounts_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY customer_accounts
    ADD CONSTRAINT customer_accounts_user_id_key UNIQUE (user_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20141223021457');

INSERT INTO schema_migrations (version) VALUES ('20141223031759');

