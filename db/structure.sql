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
-- Name: audit_timestamp; Type: DOMAIN; Schema: public; Owner: -
--

CREATE DOMAIN audit_timestamp AS timestamp with time zone NOT NULL DEFAULT now();


--
-- Name: credit_or_debit; Type: DOMAIN; Schema: public; Owner: -
--

CREATE DOMAIN credit_or_debit AS text NOT NULL
	CONSTRAINT credit_or_debit CHECK ((VALUE = ANY (ARRAY['credit'::text, 'debit'::text])));


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


--
-- Name: update_account_balance(bigint); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION update_account_balance(account_id bigint) RETURNS void
    LANGUAGE plpgsql
    AS $$
        BEGIN
          WITH debit AS (
            SELECT coalesce(sum(amount), 0) total FROM transactions WHERE debit_id=account_id
          ), credit AS (
            SELECT coalesce(sum(amount), 0) total FROM transactions WHERE credit_id=account_id
          )
          UPDATE accounts SET balance = (CASE credit_or_debit WHEN 'debit' THEN 1 ELSE -1 END) *
                                          ((SELECT total FROM debit) -
                                           (SELECT total FROM credit))
                          WHERE id=account_id;
        END
        $$;


--
-- Name: update_balances(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION update_balances() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
        BEGIN
          PERFORM update_account_balance(NEW.debit_id);
          PERFORM update_account_balance(NEW.credit_id);
          RETURN NEW;
        END
        $$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: account_types; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE account_types (
    type text NOT NULL,
    credit_or_debit credit_or_debit NOT NULL
);


--
-- Name: accounts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE accounts (
    id bigint NOT NULL,
    name text NOT NULL,
    balance non_negative_currency,
    type text NOT NULL,
    credit_or_debit credit_or_debit,
    created_at audit_timestamp,
    updated_at audit_timestamp
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
-- Name: admins; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE admins (
    email text NOT NULL,
    name text NOT NULL,
    created_at audit_timestamp,
    updated_at audit_timestamp,
    id bigint NOT NULL
);


--
-- Name: admins_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE admins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE admins_id_seq OWNED BY admins.id;


--
-- Name: bank_statements; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE bank_statements (
    id bigint NOT NULL,
    admin_id bigint NOT NULL,
    contents text NOT NULL,
    account_number bigint,
    created_at audit_timestamp,
    updated_at audit_timestamp
);


--
-- Name: bank_statements_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE bank_statements_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bank_statements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE bank_statements_id_seq OWNED BY bank_statements.id;


--
-- Name: bank_transactions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE bank_transactions (
    id bigint NOT NULL,
    bank_statement_id bigint NOT NULL,
    transaction_type text,
    date_posted timestamp without time zone,
    amount currency,
    transaction_id bigint,
    name text,
    memo text,
    created_at audit_timestamp,
    updated_at audit_timestamp
);


--
-- Name: bank_transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE bank_transactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bank_transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE bank_transactions_id_seq OWNED BY bank_transactions.id;


--
-- Name: customers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE customers (
    customer_id bigint NOT NULL,
    account_id bigint NOT NULL,
    type text NOT NULL,
    created_at audit_timestamp,
    updated_at audit_timestamp
);


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
    credit_id bigint NOT NULL,
    debit_id bigint NOT NULL,
    amount positive_currency,
    comment text,
    due_at timestamp with time zone,
    paid_at timestamp with time zone,
    created_at audit_timestamp,
    updated_at audit_timestamp,
    CONSTRAINT dont_pay_yourself CHECK ((debit_id <> credit_id)),
    CONSTRAINT either_due_or_paid CHECK (((due_at IS NOT NULL) OR (paid_at IS NOT NULL)))
);


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

ALTER TABLE ONLY accounts ALTER COLUMN id SET DEFAULT nextval('accounts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY admins ALTER COLUMN id SET DEFAULT nextval('admins_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY bank_statements ALTER COLUMN id SET DEFAULT nextval('bank_statements_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY bank_transactions ALTER COLUMN id SET DEFAULT nextval('bank_transactions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY transactions ALTER COLUMN id SET DEFAULT nextval('transactions_id_seq'::regclass);


--
-- Name: account_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY account_types
    ADD CONSTRAINT account_types_pkey PRIMARY KEY (type, credit_or_debit);


--
-- Name: accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);


--
-- Name: admins_email_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY admins
    ADD CONSTRAINT admins_email_key UNIQUE (email);


--
-- Name: admins_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY admins
    ADD CONSTRAINT admins_pkey PRIMARY KEY (id);


--
-- Name: bank_statements_contents_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY bank_statements
    ADD CONSTRAINT bank_statements_contents_key UNIQUE (contents);


--
-- Name: bank_statements_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY bank_statements
    ADD CONSTRAINT bank_statements_pkey PRIMARY KEY (id);


--
-- Name: bank_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY bank_transactions
    ADD CONSTRAINT bank_transactions_pkey PRIMARY KEY (id);


--
-- Name: transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (id);


--
-- Name: unique_customer_account; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY customers
    ADD CONSTRAINT unique_customer_account PRIMARY KEY (customer_id, type);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: update_balances; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_balances AFTER INSERT OR DELETE OR UPDATE ON transactions FOR EACH ROW EXECUTE PROCEDURE update_balances();


--
-- Name: accounts_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY accounts
    ADD CONSTRAINT accounts_type_fkey FOREIGN KEY (type, credit_or_debit) REFERENCES account_types(type, credit_or_debit);


--
-- Name: bank_statements_admin_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY bank_statements
    ADD CONSTRAINT bank_statements_admin_id_fkey FOREIGN KEY (admin_id) REFERENCES admins(id);


--
-- Name: bank_transactions_bank_statement_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY bank_transactions
    ADD CONSTRAINT bank_transactions_bank_statement_id_fkey FOREIGN KEY (bank_statement_id) REFERENCES bank_statements(id);


--
-- Name: customers_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY customers
    ADD CONSTRAINT customers_account_id_fkey FOREIGN KEY (account_id) REFERENCES accounts(id);


--
-- Name: transactions_credit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transactions
    ADD CONSTRAINT transactions_credit_id_fkey FOREIGN KEY (credit_id) REFERENCES accounts(id);


--
-- Name: transactions_debit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transactions
    ADD CONSTRAINT transactions_debit_id_fkey FOREIGN KEY (debit_id) REFERENCES accounts(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20141223021457');

INSERT INTO schema_migrations (version) VALUES ('20141223031759');

INSERT INTO schema_migrations (version) VALUES ('20141223032753');

INSERT INTO schema_migrations (version) VALUES ('20141223193247');

INSERT INTO schema_migrations (version) VALUES ('20141227163427');

INSERT INTO schema_migrations (version) VALUES ('20150105114248');

INSERT INTO schema_migrations (version) VALUES ('20150105181720');

INSERT INTO schema_migrations (version) VALUES ('20150105183012');

INSERT INTO schema_migrations (version) VALUES ('20150105190348');

