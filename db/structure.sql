--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.9
-- Dumped by pg_dump version 9.6.9

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


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.accounts (
    id bigint NOT NULL,
    balance numeric(10,2) NOT NULL,
    date_opened timestamp without time zone NOT NULL,
    customer_id uuid NOT NULL,
    acct_type_id smallint NOT NULL,
    status character varying DEFAULT 'active'::character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: acct_transactions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acct_transactions (
    id bigint NOT NULL,
    secure_tac bigint NOT NULL,
    date timestamp without time zone NOT NULL,
    description text,
    amount numeric(10,2) NOT NULL,
    account_id bigint NOT NULL,
    recipient_id bigint NOT NULL,
    transaction_type_id integer NOT NULL,
    adjusted_bal numeric(10,2) NOT NULL,
    status character varying DEFAULT 'pending'::character varying,
    payee_id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: acct_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acct_types (
    id integer NOT NULL,
    name character varying(14),
    interest_rate numeric(3,3) DEFAULT 0.0 NOT NULL,
    status character varying DEFAULT 'active'::character varying
);


--
-- Name: acct_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.acct_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: acct_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.acct_types_id_seq OWNED BY public.acct_types.id;


--
-- Name: addresses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.addresses (
    customer_id uuid NOT NULL,
    address1 character varying(100) NOT NULL,
    address2 character varying(100),
    zip_code_zip_code character varying(10) NOT NULL,
    city character varying(45) NOT NULL,
    state character varying(30) NOT NULL,
    country character varying(50) NOT NULL
);


--
-- Name: administrators; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.administrators (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    firstname character varying(40) NOT NULL,
    lastname character varying(40) NOT NULL,
    user_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: coin_accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.coin_accounts (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    bitcoin_acct character varying NOT NULL,
    customer_id uuid NOT NULL,
    balance numeric(10,2) NOT NULL,
    date_opened timestamp without time zone NOT NULL,
    acct_type_id smallint NOT NULL,
    status character varying DEFAULT 'active'::character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: customers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.customers (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    phone1 character varying(20),
    phone2 character varying(20),
    title character varying(11),
    firstname character varying(40),
    lastname character varying(40),
    user_id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: equities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.equities (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    customer_id uuid NOT NULL,
    risk_id uuid NOT NULL,
    certificate_number character varying NOT NULL,
    issue_date character varying,
    equity_type_id character varying,
    equity_period daterange,
    bill_currency character varying NOT NULL,
    agency_code character varying,
    passport_number character varying NOT NULL,
    profession character varying,
    location_of_risk character varying NOT NULL,
    situation_of_risk character varying NOT NULL,
    ref_bank character varying NOT NULL,
    ref_account integer NOT NULL,
    ref_bank_branch character varying NOT NULL,
    interest_rate_type character varying NOT NULL
);


--
-- Name: equity_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.equity_types (
    id integer NOT NULL,
    name character varying,
    description character varying,
    status character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: equity_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.equity_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: equity_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.equity_types_id_seq OWNED BY public.equity_types.id;


--
-- Name: payees; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payees (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    ref_name character varying,
    bank_name character varying NOT NULL,
    routing_number character varying,
    swift_code character varying,
    address character varying NOT NULL,
    acct_number bigint NOT NULL,
    status character varying DEFAULT 'active'::character varying,
    city character varying NOT NULL,
    state character varying,
    country character varying NOT NULL,
    post_code character varying NOT NULL,
    phone character varying,
    payee_type character varying DEFAULT 'credit'::character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: risks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.risks (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    description character varying NOT NULL,
    name character varying NOT NULL,
    situation_type character varying NOT NULL,
    eligibility_group character varying NOT NULL,
    amount_covered numeric(10,2) NOT NULL,
    monthly_contribution numeric(10,2) NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: states; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.states (
    id integer NOT NULL,
    name character varying(30) NOT NULL,
    abbreviation character varying(5) NOT NULL,
    assoc_press character varying(14) NOT NULL,
    country character varying(50) NOT NULL
);


--
-- Name: states_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.states_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: states_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.states_id_seq OWNED BY public.states.id;


--
-- Name: transaction_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.transaction_types (
    id integer NOT NULL,
    name character varying(30)
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
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

CREATE TABLE public.wire_transfers (
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

CREATE SEQUENCE public.wire_transfers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: wire_transfers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.wire_transfers_id_seq OWNED BY public.wire_transfers.id;


--
-- Name: zip_codes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.zip_codes (
    zip_code character varying(10) NOT NULL,
    city character varying(45) NOT NULL,
    state_abbreviation character varying(3) NOT NULL
);


--
-- Name: acct_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acct_types ALTER COLUMN id SET DEFAULT nextval('public.acct_types_id_seq'::regclass);


--
-- Name: equity_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.equity_types ALTER COLUMN id SET DEFAULT nextval('public.equity_types_id_seq'::regclass);


--
-- Name: states id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.states ALTER COLUMN id SET DEFAULT nextval('public.states_id_seq'::regclass);


--
-- Name: wire_transfers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wire_transfers ALTER COLUMN id SET DEFAULT nextval('public.wire_transfers_id_seq'::regclass);


--
-- Name: accounts accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);


--
-- Name: acct_transactions acct_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acct_transactions
    ADD CONSTRAINT acct_transactions_pkey PRIMARY KEY (id);


--
-- Name: acct_types acct_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acct_types
    ADD CONSTRAINT acct_types_pkey PRIMARY KEY (id);


--
-- Name: addresses addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (customer_id);


--
-- Name: administrators administrators_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.administrators
    ADD CONSTRAINT administrators_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: coin_accounts coin_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.coin_accounts
    ADD CONSTRAINT coin_accounts_pkey PRIMARY KEY (id);


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (id);


--
-- Name: equities equities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.equities
    ADD CONSTRAINT equities_pkey PRIMARY KEY (id);


--
-- Name: equity_types equity_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.equity_types
    ADD CONSTRAINT equity_types_pkey PRIMARY KEY (id);


--
-- Name: payees payees_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payees
    ADD CONSTRAINT payees_pkey PRIMARY KEY (id);


--
-- Name: risks risks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.risks
    ADD CONSTRAINT risks_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: states states_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.states
    ADD CONSTRAINT states_pkey PRIMARY KEY (id);


--
-- Name: transaction_types transaction_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transaction_types
    ADD CONSTRAINT transaction_types_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: wire_transfers wire_transfers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wire_transfers
    ADD CONSTRAINT wire_transfers_pkey PRIMARY KEY (id);


--
-- Name: zip_codes zip_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.zip_codes
    ADD CONSTRAINT zip_codes_pkey PRIMARY KEY (zip_code);


--
-- Name: BY_COUNTRY; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "BY_COUNTRY" ON public.states USING btree (country);


--
-- Name: BY_DATE; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "BY_DATE" ON public.acct_transactions USING btree (date, id);


--
-- Name: BY_LASTNAME; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "BY_LASTNAME" ON public.administrators USING btree (lastname, firstname, id);


--
-- Name: BY_NAME; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "BY_NAME" ON public.states USING btree (name, id);


--
-- Name: BY_USERNAME; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "BY_USERNAME" ON public.users USING btree (username, id);


--
-- Name: NAME_LAST_FIRST; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "NAME_LAST_FIRST" ON public.customers USING btree (lastname, firstname);


--
-- Name: fk_accounts_acct_types1_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fk_accounts_acct_types1_idx ON public.accounts USING btree (acct_type_id);


--
-- Name: fk_accounts_customers1_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fk_accounts_customers1_idx ON public.accounts USING btree (customer_id);


--
-- Name: fk_acct_transactions_accounts1_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fk_acct_transactions_accounts1_idx ON public.acct_transactions USING btree (account_id);


--
-- Name: fk_acct_transactions_payees1_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fk_acct_transactions_payees1_idx ON public.acct_transactions USING btree (payee_id);


--
-- Name: fk_acct_transactions_transaction_types1_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fk_acct_transactions_transaction_types1_idx ON public.acct_transactions USING btree (transaction_type_id);


--
-- Name: fk_addresses_zip_codes1_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fk_addresses_zip_codes1_idx ON public.addresses USING btree (zip_code_zip_code, city, country);


--
-- Name: fk_administrators_users_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fk_administrators_users_idx ON public.administrators USING btree (user_id);


--
-- Name: fk_coin_accounts_acct_types1_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fk_coin_accounts_acct_types1_idx ON public.coin_accounts USING btree (acct_type_id);


--
-- Name: fk_coin_accounts_bitcoin_acct1_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fk_coin_accounts_bitcoin_acct1_idx ON public.coin_accounts USING btree (bitcoin_acct);


--
-- Name: fk_coin_accounts_customers1_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fk_coin_accounts_customers1_idx ON public.coin_accounts USING btree (customer_id);


--
-- Name: fk_customers_users1_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fk_customers_users1_idx ON public.customers USING btree (user_id);


--
-- Name: fk_equities_owners1_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fk_equities_owners1_idx ON public.equities USING btree (customer_id, risk_id, passport_number);


--
-- Name: fk_payees_acct_number1_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fk_payees_acct_number1_idx ON public.payees USING btree (acct_number);


--
-- Name: fk_payees_bank_name1_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fk_payees_bank_name1_idx ON public.payees USING btree (bank_name);


--
-- Name: fk_payees_payee_type1_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fk_payees_payee_type1_idx ON public.payees USING btree (payee_type);


--
-- Name: fk_wire_transactions_types1_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fk_wire_transactions_types1_idx ON public.wire_transfers USING btree (acct_transaction_id);


--
-- Name: fk_zip_codes_states1_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fk_zip_codes_states1_idx ON public.zip_codes USING btree (state_abbreviation);


--
-- Name: index_equities_on_customer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_equities_on_customer_id ON public.equities USING btree (customer_id);


--
-- Name: index_equities_on_risk_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_equities_on_risk_id ON public.equities USING btree (risk_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


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
('20170415033117'),
('20171014060049'),
('20171016141244'),
('20171016141759'),
('20171016141924'),
('20171021044723');


