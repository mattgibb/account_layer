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
-- Name: created_at; Type: DOMAIN; Schema: public; Owner: -
--

CREATE DOMAIN created_at AS timestamp with time zone NOT NULL;


--
-- Name: currency; Type: DOMAIN; Schema: public; Owner: -
--

CREATE DOMAIN currency AS numeric NOT NULL DEFAULT 0;


--
-- Name: debit_or_credit; Type: DOMAIN; Schema: public; Owner: -
--

CREATE DOMAIN debit_or_credit AS text NOT NULL
	CONSTRAINT debit_or_credit CHECK ((VALUE = ANY (ARRAY['debit'::text, 'credit'::text])));


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


--
-- Name: updated_at; Type: DOMAIN; Schema: public; Owner: -
--

CREATE DOMAIN updated_at AS created_at DEFAULT now();


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: account_types; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE account_types (
    type text NOT NULL,
    debit_or_credit debit_or_credit NOT NULL
);


--
-- Name: accounts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE accounts (
    id bigint NOT NULL,
    name text NOT NULL,
    balance non_negative_currency,
    type text,
    debit_or_credit debit_or_credit,
    created_at created_at,
    updated_at updated_at
);


--
-- Name: accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE accounts_id_seq OWNED BY accounts.id;


--
-- Name: customers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE customers (
    customer_id bigint NOT NULL,
    account_id bigint,
    created_at created_at,
    updated_at updated_at
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY accounts ALTER COLUMN id SET DEFAULT nextval('accounts_id_seq'::regclass);


--
-- Name: account_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY account_types
    ADD CONSTRAINT account_types_pkey PRIMARY KEY (type, debit_or_credit);


--
-- Name: accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);


--
-- Name: customers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (customer_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: accounts_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY accounts
    ADD CONSTRAINT accounts_type_fkey FOREIGN KEY (type, debit_or_credit) REFERENCES account_types(type, debit_or_credit);


--
-- Name: customers_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY customers
    ADD CONSTRAINT customers_account_id_fkey FOREIGN KEY (account_id) REFERENCES accounts(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20141223021457');

INSERT INTO schema_migrations (version) VALUES ('20141223031759');

