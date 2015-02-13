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
	CONSTRAINT positive CHECK ((VALUE > (0)::numeric));


--
-- Name: delete_transaction_update_balances(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION delete_transaction_update_balances() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
        BEGIN
          PERFORM update_account_balance(OLD.debit_id);
          PERFORM update_account_balance(OLD.credit_id);
          RETURN NULL; -- result is ignored since this is an AFTER trigger
        END
        $$;


--
-- Name: insert_transaction_update_balances(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION insert_transaction_update_balances() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
        BEGIN
          PERFORM update_account_balance(NEW.debit_id);
          PERFORM update_account_balance(NEW.credit_id);
          RETURN NULL; -- result is ignored since this is an AFTER trigger
        END
        $$;


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
-- Name: update_transaction_update_balances(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION update_transaction_update_balances() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
        BEGIN
          PERFORM update_account_balance(id) from 
            (SELECT DISTINCT id FROM
              (VALUES (OLD.credit_id),
                      (OLD.debit_id),
                      (NEW.credit_id),
                      (NEW.debit_id)
              ) account_ids(id)
            ) distinct_account_ids(id);
          RETURN NULL; -- result is ignored since this is an AFTER trigger
        END
        $$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: account_groups; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE account_groups (
    type text NOT NULL,
    created_at audit_timestamp,
    updated_at audit_timestamp,
    id bigint NOT NULL,
    CONSTRAINT account_group_types CHECK ((type = ANY (ARRAY['AccountGroup::Lender'::text, 'AccountGroup::Borrower'::text, 'AccountGroup::School'::text, 'AccountGroup::Cohort'::text])))
);


--
-- Name: accounts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE accounts (
    id bigint NOT NULL,
    balance non_negative_currency,
    type text NOT NULL,
    credit_or_debit credit_or_debit,
    created_at audit_timestamp,
    updated_at audit_timestamp,
    account_group_id bigint
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
-- Name: bank_reconciliations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE bank_reconciliations (
    id bigint NOT NULL,
    transaction_id bigint NOT NULL,
    bank_transaction_id bigint NOT NULL,
    admin_id bigint NOT NULL,
    created_at audit_timestamp,
    updated_at audit_timestamp
);


--
-- Name: bank_reconciliations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE bank_reconciliations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bank_reconciliations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE bank_reconciliations_id_seq OWNED BY bank_reconciliations.id;


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
-- Name: cohort_profiles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE cohort_profiles (
    id bigint NOT NULL,
    account_group_id bigint NOT NULL,
    account_group_type text NOT NULL,
    lendlayer_id bigint NOT NULL,
    CONSTRAINT cohort_profiles_account_group_type_check CHECK ((account_group_type = 'AccountGroup::Cohort'::text))
);


--
-- Name: cohort_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE cohort_profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cohort_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE cohort_profiles_id_seq OWNED BY cohort_profiles.id;


--
-- Name: customer_profiles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE customer_profiles (
    id bigint NOT NULL,
    account_group_id bigint NOT NULL,
    account_group_type text NOT NULL,
    lendlayer_id bigint NOT NULL,
    name text NOT NULL,
    CONSTRAINT customer_profiles_account_group_type_check CHECK ((account_group_type = ANY (ARRAY['AccountGroup::Lender'::text, 'AccountGroup::Borrower'::text, 'AccountGroup::School'::text])))
);


--
-- Name: customer_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE customer_profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: customer_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE customer_profiles_id_seq OWNED BY customer_profiles.id;


--
-- Name: customers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE customers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: customers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE customers_id_seq OWNED BY account_groups.id;


--
-- Name: first_associates_reports; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE first_associates_reports (
    id bigint NOT NULL,
    admin_id bigint NOT NULL,
    contents bytea NOT NULL,
    created_at audit_timestamp,
    updated_at audit_timestamp
);


--
-- Name: first_associates_reports_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE first_associates_reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: first_associates_reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE first_associates_reports_id_seq OWNED BY first_associates_reports.id;


--
-- Name: first_associates_transactions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE first_associates_transactions (
    id bigint NOT NULL,
    first_associates_report_id bigint NOT NULL,
    transaction_date date,
    effective_date date,
    g_l_date date,
    loan_number integer,
    short_name text,
    payment_method text,
    payment_method_reference text,
    principal non_negative_currency,
    interest non_negative_currency,
    fees non_negative_currency,
    late_charges non_negative_currency,
    udbs non_negative_currency,
    suspense non_negative_currency,
    impound non_negative_currency,
    payment_amount non_negative_currency,
    created_at audit_timestamp,
    updated_at audit_timestamp
);


--
-- Name: first_associates_transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE first_associates_transactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: first_associates_transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE first_associates_transactions_id_seq OWNED BY first_associates_transactions.id;


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

ALTER TABLE ONLY account_groups ALTER COLUMN id SET DEFAULT nextval('customers_id_seq'::regclass);


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

ALTER TABLE ONLY bank_reconciliations ALTER COLUMN id SET DEFAULT nextval('bank_reconciliations_id_seq'::regclass);


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

ALTER TABLE ONLY cohort_profiles ALTER COLUMN id SET DEFAULT nextval('cohort_profiles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY customer_profiles ALTER COLUMN id SET DEFAULT nextval('customer_profiles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY first_associates_reports ALTER COLUMN id SET DEFAULT nextval('first_associates_reports_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY first_associates_transactions ALTER COLUMN id SET DEFAULT nextval('first_associates_transactions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY transactions ALTER COLUMN id SET DEFAULT nextval('transactions_id_seq'::regclass);


--
-- Name: account_groups_unique_id_type; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY account_groups
    ADD CONSTRAINT account_groups_unique_id_type UNIQUE (id, type);


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
-- Name: bank_reconciliations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY bank_reconciliations
    ADD CONSTRAINT bank_reconciliations_pkey PRIMARY KEY (id);


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
-- Name: cohort_profiles_lendlayer_id_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY cohort_profiles
    ADD CONSTRAINT cohort_profiles_lendlayer_id_key UNIQUE (lendlayer_id);


--
-- Name: cohort_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY cohort_profiles
    ADD CONSTRAINT cohort_profiles_pkey PRIMARY KEY (id);


--
-- Name: cohort_profiles_unique_account_group; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY cohort_profiles
    ADD CONSTRAINT cohort_profiles_unique_account_group UNIQUE (account_group_id);


--
-- Name: customer_profiles_lendlayer_id_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY customer_profiles
    ADD CONSTRAINT customer_profiles_lendlayer_id_key UNIQUE (lendlayer_id);


--
-- Name: customer_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY customer_profiles
    ADD CONSTRAINT customer_profiles_pkey PRIMARY KEY (id);


--
-- Name: customer_profiles_unique_account_group; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY customer_profiles
    ADD CONSTRAINT customer_profiles_unique_account_group UNIQUE (account_group_id);


--
-- Name: customers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY account_groups
    ADD CONSTRAINT customers_pkey PRIMARY KEY (id);


--
-- Name: first_associates_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY first_associates_reports
    ADD CONSTRAINT first_associates_reports_pkey PRIMARY KEY (id);


--
-- Name: first_associates_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY first_associates_transactions
    ADD CONSTRAINT first_associates_transactions_pkey PRIMARY KEY (id);


--
-- Name: reconciliations_bank_transaction_id_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY bank_reconciliations
    ADD CONSTRAINT reconciliations_bank_transaction_id_key UNIQUE (bank_transaction_id);


--
-- Name: reconciliations_transaction_id_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY bank_reconciliations
    ADD CONSTRAINT reconciliations_transaction_id_key UNIQUE (transaction_id);


--
-- Name: transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (id);


--
-- Name: unique_customer_accounts; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY accounts
    ADD CONSTRAINT unique_customer_accounts UNIQUE (type, account_group_id);


--
-- Name: unique_lendlayer_accounts; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_lendlayer_accounts ON accounts USING btree (type) WHERE (account_group_id IS NULL);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: delete_transaction_update_balances; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER delete_transaction_update_balances AFTER DELETE ON transactions FOR EACH ROW EXECUTE PROCEDURE delete_transaction_update_balances();


--
-- Name: insert_transaction_update_balances; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER insert_transaction_update_balances AFTER INSERT ON transactions FOR EACH ROW EXECUTE PROCEDURE insert_transaction_update_balances();


--
-- Name: update_transaction_update_balances; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_transaction_update_balances AFTER UPDATE ON transactions FOR EACH ROW EXECUTE PROCEDURE update_transaction_update_balances();


--
-- Name: accounts_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY accounts
    ADD CONSTRAINT accounts_customer_id_fkey FOREIGN KEY (account_group_id) REFERENCES account_groups(id);


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
-- Name: cohort_profiles_account_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cohort_profiles
    ADD CONSTRAINT cohort_profiles_account_group_id_fkey FOREIGN KEY (account_group_id, account_group_type) REFERENCES account_groups(id, type) MATCH FULL;


--
-- Name: customer_profiles_account_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY customer_profiles
    ADD CONSTRAINT customer_profiles_account_group_id_fkey FOREIGN KEY (account_group_id, account_group_type) REFERENCES account_groups(id, type);


--
-- Name: first_associates_reports_admin_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY first_associates_reports
    ADD CONSTRAINT first_associates_reports_admin_id_fkey FOREIGN KEY (admin_id) REFERENCES admins(id);


--
-- Name: first_associates_transactions_first_associates_report_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY first_associates_transactions
    ADD CONSTRAINT first_associates_transactions_first_associates_report_id_fkey FOREIGN KEY (first_associates_report_id) REFERENCES first_associates_reports(id);


--
-- Name: reconciliations_admin_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY bank_reconciliations
    ADD CONSTRAINT reconciliations_admin_id_fkey FOREIGN KEY (admin_id) REFERENCES admins(id);


--
-- Name: reconciliations_bank_transaction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY bank_reconciliations
    ADD CONSTRAINT reconciliations_bank_transaction_id_fkey FOREIGN KEY (bank_transaction_id) REFERENCES bank_transactions(id);


--
-- Name: reconciliations_transaction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY bank_reconciliations
    ADD CONSTRAINT reconciliations_transaction_id_fkey FOREIGN KEY (transaction_id) REFERENCES transactions(id);


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

INSERT INTO schema_migrations (version) VALUES ('20150106101756');

INSERT INTO schema_migrations (version) VALUES ('20150106110247');

INSERT INTO schema_migrations (version) VALUES ('20150106121045');

INSERT INTO schema_migrations (version) VALUES ('20150106134633');

INSERT INTO schema_migrations (version) VALUES ('20150106144212');

INSERT INTO schema_migrations (version) VALUES ('20150106183157');

INSERT INTO schema_migrations (version) VALUES ('20150108031403');

INSERT INTO schema_migrations (version) VALUES ('20150109101459');

INSERT INTO schema_migrations (version) VALUES ('20150109101511');

INSERT INTO schema_migrations (version) VALUES ('20150109154546');

INSERT INTO schema_migrations (version) VALUES ('20150109163704');

INSERT INTO schema_migrations (version) VALUES ('20150110152111');

INSERT INTO schema_migrations (version) VALUES ('20150110152230');

INSERT INTO schema_migrations (version) VALUES ('20150212203420');

INSERT INTO schema_migrations (version) VALUES ('20150212225137');

INSERT INTO schema_migrations (version) VALUES ('20150213060343');

