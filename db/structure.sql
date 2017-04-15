--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.6
-- Dumped by pg_dump version 9.5.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE accounts (
    id bigint NOT NULL,
    balance numeric(10,2) NOT NULL,
    date_opened timestamp without time zone NOT NULL,
    customer_id bigint NOT NULL,
    acct_type_id smallint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: acct_transactions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE acct_transactions (
    id bigint NOT NULL,
    date timestamp without time zone NOT NULL,
    description text,
    amount numeric(10,2) NOT NULL,
    account_id bigint NOT NULL,
    transaction_type_id integer NOT NULL,
    adjusted_bal numeric(10,2) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: acct_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE acct_types (
    id integer NOT NULL,
    name character varying(14),
    interest_rate numeric(3,3) DEFAULT 0.0 NOT NULL
);


--
-- Name: acct_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE acct_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: acct_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE acct_types_id_seq OWNED BY acct_types.id;


--
-- Name: addresses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE addresses (
    customer_id bigint NOT NULL,
    address1 character varying(100) NOT NULL,
    address2 character varying(100),
    zip_code_zip_code character varying(5) NOT NULL
);


--
-- Name: administrators; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE administrators (
    id bigint NOT NULL,
    firstname character varying(40) NOT NULL,
    lastname character varying(40) NOT NULL,
    user_id uuid DEFAULT uuid_generate_v4() NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: customers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE customers (
    id bigint NOT NULL,
    phone1 character varying(20),
    phone2 character varying(20),
    title character varying(11),
    firstname character varying(40),
    lastname character varying(40),
    user_id uuid DEFAULT uuid_generate_v4() NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: states; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE states (
    id integer NOT NULL,
    name character varying(30) NOT NULL,
    abbreviation character varying(5) NOT NULL,
    assoc_press character varying(14) NOT NULL
);


--
-- Name: states_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE states_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: states_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE states_id_seq OWNED BY states.id;


--
-- Name: transaction_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE transaction_types (
    id integer NOT NULL,
    name character varying(30)
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE users (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    username character varying(30) DEFAULT ''::character varying NOT NULL,
    role character varying(30),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet
);


--
-- Name: wire_transfers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE wire_transfers (
    id integer NOT NULL,
    acct_transaction_id bigint,
    recipient_name character varying(50) NOT NULL,
    address text NOT NULL,
    city character varying(50),
    state character varying(50) NOT NULL,
    country character varying(50) NOT NULL,
    phone character varying(13) NOT NULL,
    bank_account bigint NOT NULL,
    bank_name character varying(50) NOT NULL,
    bank_country character varying(50) NOT NULL,
    routing character varying(20) NOT NULL,
    status character varying DEFAULT 'pending'::character varying,
    description text NOT NULL,
    date timestamp without time zone NOT NULL,
    credited numeric(10,2) NOT NULL
);


--
-- Name: wire_transfers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE wire_transfers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: wire_transfers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE wire_transfers_id_seq OWNED BY wire_transfers.id;


--
-- Name: zip_codes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE zip_codes (
    zip_code character varying(5) NOT NULL,
    city character varying(45) NOT NULL,
    state_abbreviation character varying(3) NOT NULL
);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY acct_types ALTER COLUMN id SET DEFAULT nextval('acct_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY states ALTER COLUMN id SET DEFAULT nextval('states_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY wire_transfers ALTER COLUMN id SET DEFAULT nextval('wire_transfers_id_seq'::regclass);


--
-- Name: accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);


--
-- Name: acct_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY acct_transactions
    ADD CONSTRAINT acct_transactions_pkey PRIMARY KEY (id);


--
-- Name: acct_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY acct_types
    ADD CONSTRAINT acct_types_pkey PRIMARY KEY (id);


--
-- Name: addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (customer_id);


--
-- Name: administrators_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY administrators
    ADD CONSTRAINT administrators_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: customers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: states_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY states
    ADD CONSTRAINT states_pkey PRIMARY KEY (id);


--
-- Name: transaction_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transaction_types
    ADD CONSTRAINT transaction_types_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: wire_transfers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY wire_transfers
    ADD CONSTRAINT wire_transfers_pkey PRIMARY KEY (id);


--
-- Name: zip_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY zip_codes
    ADD CONSTRAINT zip_codes_pkey PRIMARY KEY (zip_code);


--
-- Name: BY_LASTNAME; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "BY_LASTNAME" ON administrators USING btree (lastname, firstname, id);


--
-- Name: BY_NAME; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "BY_NAME" ON states USING btree (name, id);


--
-- Name: BY_USERNAME; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "BY_USERNAME" ON users USING btree (username, id);


--
-- Name: NAME_LAST_FIRST; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "NAME_LAST_FIRST" ON customers USING btree (lastname, firstname);


--
-- Name: fk_accounts_acct_types1_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fk_accounts_acct_types1_idx ON accounts USING btree (acct_type_id);


--
-- Name: fk_accounts_customers1_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fk_accounts_customers1_idx ON accounts USING btree (customer_id);


--
-- Name: fk_acct_transactions_accounts1_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fk_acct_transactions_accounts1_idx ON acct_transactions USING btree (account_id);


--
-- Name: fk_acct_transactions_transaction_types1_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fk_acct_transactions_transaction_types1_idx ON acct_transactions USING btree (transaction_type_id);


--
-- Name: fk_addresses_zip_codes1_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fk_addresses_zip_codes1_idx ON addresses USING btree (zip_code_zip_code);


--
-- Name: fk_administrators_users_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fk_administrators_users_idx ON administrators USING btree (user_id);


--
-- Name: fk_customers_users1_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fk_customers_users1_idx ON customers USING btree (user_id);


--
-- Name: fk_wire_transactions_types1_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fk_wire_transactions_types1_idx ON wire_transfers USING btree (acct_transaction_id);


--
-- Name: fk_zip_codes_states1_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fk_zip_codes_states1_idx ON zip_codes USING btree (state_abbreviation);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20170415014748'),
('20170415022028'),
('20170415022908'),
('20170415024759'),
('20170415025050'),
('20170415025325'),
('20170415030725'),
('20170415031333'),
('20170415031846'),
('20170415032504'),
('20170415032731'),
('20170415033117');


