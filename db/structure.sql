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
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: transactions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE transactions (
    id bigint NOT NULL,
    customer_debit_id bigint NOT NULL,
    customer_credit_id bigint NOT NULL,
    control_debit_id bigint NOT NULL,
    control_credit_id bigint NOT NULL,
    amount positive_currency,
    comment text,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT single_credit_id CHECK (((NOT ((customer_credit_id IS NULL) AND (control_credit_id IS NULL))) AND (NOT ((customer_credit_id IS NOT NULL) AND (control_credit_id IS NOT NULL))))),
    CONSTRAINT single_debit_id CHECK (((NOT ((customer_debit_id IS NULL) AND (control_debit_id IS NULL))) AND (NOT ((customer_debit_id IS NOT NULL) AND (control_debit_id IS NOT NULL)))))
);


--
-- Name: transactions_control_credit_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE transactions_control_credit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transactions_control_credit_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE transactions_control_credit_id_seq OWNED BY transactions.control_credit_id;


--
-- Name: transactions_control_debit_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE transactions_control_debit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transactions_control_debit_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE transactions_control_debit_id_seq OWNED BY transactions.control_debit_id;


--
-- Name: transactions_customer_credit_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE transactions_customer_credit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transactions_customer_credit_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE transactions_customer_credit_id_seq OWNED BY transactions.customer_credit_id;


--
-- Name: transactions_customer_debit_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE transactions_customer_debit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transactions_customer_debit_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE transactions_customer_debit_id_seq OWNED BY transactions.customer_debit_id;


--
-- Name: transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE transactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE transactions_id_seq OWNED BY transactions.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY control_accounts ALTER COLUMN id SET DEFAULT nextval('control_accounts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY customer_accounts ALTER COLUMN id SET DEFAULT nextval('customer_accounts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY transactions ALTER COLUMN id SET DEFAULT nextval('transactions_id_seq'::regclass);


--
-- Name: customer_debit_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY transactions ALTER COLUMN customer_debit_id SET DEFAULT nextval('transactions_customer_debit_id_seq'::regclass);


--
-- Name: customer_credit_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY transactions ALTER COLUMN customer_credit_id SET DEFAULT nextval('transactions_customer_credit_id_seq'::regclass);


--
-- Name: control_debit_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY transactions ALTER COLUMN control_debit_id SET DEFAULT nextval('transactions_control_debit_id_seq'::regclass);


--
-- Name: control_credit_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY transactions ALTER COLUMN control_credit_id SET DEFAULT nextval('transactions_control_credit_id_seq'::regclass);


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
-- Name: transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: transactions_control_credit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transactions
    ADD CONSTRAINT transactions_control_credit_id_fkey FOREIGN KEY (control_credit_id) REFERENCES control_accounts(id);


--
-- Name: transactions_control_debit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transactions
    ADD CONSTRAINT transactions_control_debit_id_fkey FOREIGN KEY (control_debit_id) REFERENCES control_accounts(id);


--
-- Name: transactions_customer_credit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transactions
    ADD CONSTRAINT transactions_customer_credit_id_fkey FOREIGN KEY (customer_credit_id) REFERENCES customer_accounts(id);


--
-- Name: transactions_customer_debit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transactions
    ADD CONSTRAINT transactions_customer_debit_id_fkey FOREIGN KEY (customer_debit_id) REFERENCES customer_accounts(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20141223021457');

INSERT INTO schema_migrations (version) VALUES ('20141223031759');

INSERT INTO schema_migrations (version) VALUES ('20141223032753');

