--
-- PostgreSQL database cluster dump
--

-- Started on 2023-03-08 15:48:17

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE anon;
ALTER ROLE anon WITH NOSUPERUSER NOINHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE authenticated;
ALTER ROLE authenticated WITH NOSUPERUSER NOINHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE authenticator;
ALTER ROLE authenticator WITH NOSUPERUSER NOINHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:tUFD3s4hAuQW56GGJndBew==$JJHXeCgUXh3YKg++6c4NRZU+KepgLYPw44KxJDOpSS4=:NjpUT3Xwn7mYjVgScPctW9kN77JD+gfAb32ZvDYzLto=';
CREATE ROLE dashboard_user;
ALTER ROLE dashboard_user WITH NOSUPERUSER INHERIT CREATEROLE CREATEDB NOLOGIN REPLICATION NOBYPASSRLS;
CREATE ROLE pgbouncer;
ALTER ROLE pgbouncer WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:RvMU45O2yExOiSc61HJggQ==$xbtkIoEhibBkKnqxo48fLsLHRA6y06ydZJ8P8Q1tU2U=:oEEpTxrkqstNeQjsQOzE9EjqYAQ1YYCGsyTixxl1OoY=';
CREATE ROLE pgsodium_keyholder;
ALTER ROLE pgsodium_keyholder WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE pgsodium_keyiduser;
ALTER ROLE pgsodium_keyiduser WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE pgsodium_keymaker;
ALTER ROLE pgsodium_keymaker WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE postgres;
ALTER ROLE postgres WITH NOSUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:cf6zgYhtBzNJ+W19F5ukQA==$s1/gA7pXYbNxro8i1KE4auHO2knKH3fDWYKkPILLaRs=:FBAOUkrm/D+t9LI3DiQcVW50qCkwP5ThwLBN+BZ+IGM=';
CREATE ROLE service_role;
ALTER ROLE service_role WITH NOSUPERUSER NOINHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION BYPASSRLS;
CREATE ROLE supabase_admin;
ALTER ROLE supabase_admin WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:tJ2FuKl9glc9D0PRSFuIZw==$UOs5+IFeSSBoRZps38E6owi1XInEnFA2ZfShP9ISFNc=:4YMi3XslyMdRziMa2Opmuz9J2Em1e4KDjnOiSCY9yyM=';
CREATE ROLE supabase_auth_admin;
ALTER ROLE supabase_auth_admin WITH NOSUPERUSER NOINHERIT CREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:md+kDuVp2UFY41B9N/uFwQ==$YYzR/grlrqZy9fmCPK0sqk/NJe55K99OrZVO1OH59bg=:XRLYByzLa0rrjquOqbuaFyfrff1vL++h/2FGMDBXX1I=';
CREATE ROLE supabase_replication_admin;
ALTER ROLE supabase_replication_admin WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN REPLICATION NOBYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:wbjZsNbIjyT3WsMbqTtX2g==$UjcCdiJ7h4aP7X2Ch5gIpV0sJlbGN+L+PRfXDqMgxbY=:VMkHl3VRpTXt0et36Mb5gX6VbOMHTF3OZOVI2U5FqOc=';
CREATE ROLE supabase_storage_admin;
ALTER ROLE supabase_storage_admin WITH NOSUPERUSER NOINHERIT CREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:RGtBXK+czgY52Q6N2JSDgg==$cumj+7TNK49hivZrX4SIwcKSGhFndyaJ3EnhFRdR+k8=:GEB3Hc5fTxc5xFa07G2SC1XKZ26mh03xUG9AEv8y2cw=';

--
-- User Configurations
--

--
-- User Config "anon"
--

ALTER ROLE anon SET statement_timeout TO '3s';

--
-- User Config "authenticated"
--

ALTER ROLE authenticated SET statement_timeout TO '8s';

--
-- User Config "authenticator"
--

ALTER ROLE authenticator SET session_preload_libraries TO 'supautils', 'safeupdate';
ALTER ROLE authenticator SET statement_timeout TO '8s';

--
-- User Config "postgres"
--

ALTER ROLE postgres SET search_path TO E'\\$user', 'public', 'extensions';

--
-- User Config "supabase_admin"
--

ALTER ROLE supabase_admin SET search_path TO '$user', 'public', 'auth', 'extensions';

--
-- User Config "supabase_auth_admin"
--

ALTER ROLE supabase_auth_admin SET search_path TO 'auth';
ALTER ROLE supabase_auth_admin SET idle_in_transaction_session_timeout TO '60000';

--
-- User Config "supabase_storage_admin"
--

ALTER ROLE supabase_storage_admin SET search_path TO 'storage';


--
-- Role memberships
--

GRANT anon TO authenticator GRANTED BY postgres;
GRANT anon TO postgres GRANTED BY supabase_admin;
GRANT authenticated TO authenticator GRANTED BY postgres;
GRANT authenticated TO postgres GRANTED BY supabase_admin;
GRANT pgsodium_keyholder TO pgsodium_keymaker GRANTED BY supabase_admin;
GRANT pgsodium_keyholder TO postgres WITH ADMIN OPTION GRANTED BY supabase_admin;
GRANT pgsodium_keyiduser TO pgsodium_keyholder GRANTED BY supabase_admin;
GRANT pgsodium_keyiduser TO pgsodium_keymaker GRANTED BY supabase_admin;
GRANT pgsodium_keyiduser TO postgres WITH ADMIN OPTION GRANTED BY supabase_admin;
GRANT pgsodium_keymaker TO postgres WITH ADMIN OPTION GRANTED BY supabase_admin;
GRANT service_role TO authenticator GRANTED BY postgres;
GRANT service_role TO postgres GRANTED BY supabase_admin;
GRANT supabase_auth_admin TO postgres GRANTED BY supabase_admin;
GRANT supabase_storage_admin TO postgres GRANTED BY supabase_admin;






--
-- Databases
--

--
-- Database "template1" dump
--

\connect template1

--
-- PostgreSQL database dump
--

-- Dumped from database version 15.1
-- Dumped by pg_dump version 15.2

-- Started on 2023-03-08 15:48:25

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

-- Completed on 2023-03-08 15:48:42

--
-- PostgreSQL database dump complete
--

--
-- Database "postgres" dump
--

\connect postgres

--
-- PostgreSQL database dump
--

-- Dumped from database version 15.1
-- Dumped by pg_dump version 15.2

-- Started on 2023-03-08 15:48:42

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
-- TOC entry 24 (class 2615 OID 16487)
-- Name: auth; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA auth;


ALTER SCHEMA auth OWNER TO supabase_admin;

--
-- TOC entry 18 (class 2615 OID 16387)
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA extensions;


ALTER SCHEMA extensions OWNER TO postgres;

--
-- TOC entry 16 (class 2615 OID 16617)
-- Name: graphql; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql;


ALTER SCHEMA graphql OWNER TO supabase_admin;

--
-- TOC entry 15 (class 2615 OID 16606)
-- Name: graphql_public; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql_public;


ALTER SCHEMA graphql_public OWNER TO supabase_admin;

--
-- TOC entry 11 (class 2615 OID 16385)
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: pgbouncer
--

CREATE SCHEMA pgbouncer;


ALTER SCHEMA pgbouncer OWNER TO pgbouncer;

--
-- TOC entry 19 (class 2615 OID 16642)
-- Name: pgsodium; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA pgsodium;


ALTER SCHEMA pgsodium OWNER TO postgres;

--
-- TOC entry 7 (class 3079 OID 16643)
-- Name: pgsodium; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgsodium WITH SCHEMA pgsodium;


--
-- TOC entry 3894 (class 0 OID 0)
-- Dependencies: 7
-- Name: EXTENSION pgsodium; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgsodium IS 'Pgsodium is a modern cryptography library for Postgres.';


--
-- TOC entry 14 (class 2615 OID 16598)
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA realtime;


ALTER SCHEMA realtime OWNER TO supabase_admin;

--
-- TOC entry 13 (class 2615 OID 16535)
-- Name: storage; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA storage;


ALTER SCHEMA storage OWNER TO supabase_admin;

--
-- TOC entry 2 (class 3079 OID 16632)
-- Name: pg_graphql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_graphql WITH SCHEMA graphql;


--
-- TOC entry 3899 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION pg_graphql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_graphql IS 'pg_graphql: GraphQL support';


--
-- TOC entry 3 (class 3079 OID 16388)
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA extensions;


--
-- TOC entry 3900 (class 0 OID 0)
-- Dependencies: 3
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- TOC entry 5 (class 3079 OID 16433)
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;


--
-- TOC entry 3901 (class 0 OID 0)
-- Dependencies: 5
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- TOC entry 6 (class 3079 OID 16470)
-- Name: pgjwt; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgjwt WITH SCHEMA extensions;


--
-- TOC entry 3902 (class 0 OID 0)
-- Dependencies: 6
-- Name: EXTENSION pgjwt; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgjwt IS 'JSON Web Token API for Postgresql';


--
-- TOC entry 4 (class 3079 OID 16422)
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;


--
-- TOC entry 3903 (class 0 OID 0)
-- Dependencies: 4
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- TOC entry 1155 (class 1247 OID 26930)
-- Name: aal_level; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.aal_level AS ENUM (
    'aal1',
    'aal2',
    'aal3'
);


ALTER TYPE auth.aal_level OWNER TO supabase_auth_admin;

--
-- TOC entry 1152 (class 1247 OID 26924)
-- Name: factor_status; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_status AS ENUM (
    'unverified',
    'verified'
);


ALTER TYPE auth.factor_status OWNER TO supabase_auth_admin;

--
-- TOC entry 1149 (class 1247 OID 26918)
-- Name: factor_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_type AS ENUM (
    'totp',
    'webauthn'
);


ALTER TYPE auth.factor_type OWNER TO supabase_auth_admin;

--
-- TOC entry 1209 (class 1247 OID 27112)
-- Name: result_type_check_if_user_exist; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.result_type_check_if_user_exist AS (
	result_login boolean,
	result_email boolean
);


ALTER TYPE public.result_type_check_if_user_exist OWNER TO postgres;

--
-- TOC entry 340 (class 1255 OID 16533)
-- Name: email(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.email() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.email', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email')
  )::text
$$;


ALTER FUNCTION auth.email() OWNER TO supabase_auth_admin;

--
-- TOC entry 3904 (class 0 OID 0)
-- Dependencies: 340
-- Name: FUNCTION email(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.email() IS 'Deprecated. Use auth.jwt() -> ''email'' instead.';


--
-- TOC entry 491 (class 1255 OID 26900)
-- Name: jwt(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.jwt() RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
  select 
    coalesce(
        nullif(current_setting('request.jwt.claim', true), ''),
        nullif(current_setting('request.jwt.claims', true), '')
    )::jsonb
$$;


ALTER FUNCTION auth.jwt() OWNER TO supabase_auth_admin;

--
-- TOC entry 339 (class 1255 OID 16532)
-- Name: role(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.role() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.role', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role')
  )::text
$$;


ALTER FUNCTION auth.role() OWNER TO supabase_auth_admin;

--
-- TOC entry 3907 (class 0 OID 0)
-- Dependencies: 339
-- Name: FUNCTION role(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.role() IS 'Deprecated. Use auth.jwt() -> ''role'' instead.';


--
-- TOC entry 338 (class 1255 OID 16531)
-- Name: uid(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.uid() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.sub', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
  )::uuid
$$;


ALTER FUNCTION auth.uid() OWNER TO supabase_auth_admin;

--
-- TOC entry 3909 (class 0 OID 0)
-- Dependencies: 338
-- Name: FUNCTION uid(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.uid() IS 'Deprecated. Use auth.jwt() -> ''sub'' instead.';


--
-- TOC entry 344 (class 1255 OID 16590)
-- Name: grant_pg_cron_access(); Type: FUNCTION; Schema: extensions; Owner: postgres
--

CREATE FUNCTION extensions.grant_pg_cron_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  schema_is_cron bool;
BEGIN
  schema_is_cron = (
    SELECT n.nspname = 'cron'
    FROM pg_event_trigger_ddl_commands() AS ev
    LEFT JOIN pg_catalog.pg_namespace AS n
      ON ev.objid = n.oid
  );

  IF schema_is_cron
  THEN
    grant usage on schema cron to postgres with grant option;

    alter default privileges in schema cron grant all on tables to postgres with grant option;
    alter default privileges in schema cron grant all on functions to postgres with grant option;
    alter default privileges in schema cron grant all on sequences to postgres with grant option;

    alter default privileges for user supabase_admin in schema cron grant all
        on sequences to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on tables to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on functions to postgres with grant option;

    grant all privileges on all tables in schema cron to postgres with grant option;

  END IF;

END;
$$;


ALTER FUNCTION extensions.grant_pg_cron_access() OWNER TO postgres;

--
-- TOC entry 3926 (class 0 OID 0)
-- Dependencies: 344
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: postgres
--

COMMENT ON FUNCTION extensions.grant_pg_cron_access() IS 'Grants access to pg_cron';


--
-- TOC entry 348 (class 1255 OID 16611)
-- Name: grant_pg_graphql_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_graphql_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
    func_is_graphql_resolve bool;
BEGIN
    func_is_graphql_resolve = (
        SELECT n.proname = 'resolve'
        FROM pg_event_trigger_ddl_commands() AS ev
        LEFT JOIN pg_catalog.pg_proc AS n
        ON ev.objid = n.oid
    );

    IF func_is_graphql_resolve
    THEN
        -- Update public wrapper to pass all arguments through to the pg_graphql resolve func
        DROP FUNCTION IF EXISTS graphql_public.graphql;
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language sql
        as $$
            select graphql.resolve(
                query := query,
                variables := coalesce(variables, '{}'),
                "operationName" := "operationName",
                extensions := extensions
            );
        $$;

        -- This hook executes when `graphql.resolve` is created. That is not necessarily the last
        -- function in the extension so we need to grant permissions on existing entities AND
        -- update default permissions to any others that are created after `graphql.resolve`
        grant usage on schema graphql to postgres, anon, authenticated, service_role;
        grant select on all tables in schema graphql to postgres, anon, authenticated, service_role;
        grant execute on all functions in schema graphql to postgres, anon, authenticated, service_role;
        grant all on all sequences in schema graphql to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on tables to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on functions to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on sequences to postgres, anon, authenticated, service_role;
    END IF;

END;
$_$;


ALTER FUNCTION extensions.grant_pg_graphql_access() OWNER TO supabase_admin;

--
-- TOC entry 3928 (class 0 OID 0)
-- Dependencies: 348
-- Name: FUNCTION grant_pg_graphql_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_graphql_access() IS 'Grants access to pg_graphql';


--
-- TOC entry 345 (class 1255 OID 16592)
-- Name: grant_pg_net_access(); Type: FUNCTION; Schema: extensions; Owner: postgres
--

CREATE FUNCTION extensions.grant_pg_net_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_net'
  )
  THEN
    IF NOT EXISTS (
      SELECT 1
      FROM pg_roles
      WHERE rolname = 'supabase_functions_admin'
    )
    THEN
      CREATE USER supabase_functions_admin NOINHERIT CREATEROLE LOGIN NOREPLICATION;
    END IF;

    GRANT USAGE ON SCHEMA net TO supabase_functions_admin, postgres, anon, authenticated, service_role;

    ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
    ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;

    ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
    ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;

    REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
    REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;

    GRANT EXECUTE ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
    GRANT EXECUTE ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_net_access() OWNER TO postgres;

--
-- TOC entry 3929 (class 0 OID 0)
-- Dependencies: 345
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: postgres
--

COMMENT ON FUNCTION extensions.grant_pg_net_access() IS 'Grants access to pg_net';


--
-- TOC entry 346 (class 1255 OID 16602)
-- Name: pgrst_ddl_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_ddl_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN SELECT * FROM pg_event_trigger_ddl_commands()
  LOOP
    IF cmd.command_tag IN (
      'CREATE SCHEMA', 'ALTER SCHEMA'
    , 'CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO', 'ALTER TABLE'
    , 'CREATE FOREIGN TABLE', 'ALTER FOREIGN TABLE'
    , 'CREATE VIEW', 'ALTER VIEW'
    , 'CREATE MATERIALIZED VIEW', 'ALTER MATERIALIZED VIEW'
    , 'CREATE FUNCTION', 'ALTER FUNCTION'
    , 'CREATE TRIGGER'
    , 'CREATE TYPE', 'ALTER TYPE'
    , 'CREATE RULE'
    , 'COMMENT'
    )
    -- don't notify in case of CREATE TEMP table or other objects created on pg_temp
    AND cmd.schema_name is distinct from 'pg_temp'
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_ddl_watch() OWNER TO supabase_admin;

--
-- TOC entry 347 (class 1255 OID 16603)
-- Name: pgrst_drop_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_drop_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  obj record;
BEGIN
  FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects()
  LOOP
    IF obj.object_type IN (
      'schema'
    , 'table'
    , 'foreign table'
    , 'view'
    , 'materialized view'
    , 'function'
    , 'trigger'
    , 'type'
    , 'rule'
    )
    AND obj.is_temporary IS false -- no pg_temp objects
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_drop_watch() OWNER TO supabase_admin;

--
-- TOC entry 349 (class 1255 OID 16613)
-- Name: set_graphql_placeholder(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.set_graphql_placeholder() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
    DECLARE
    graphql_is_dropped bool;
    BEGIN
    graphql_is_dropped = (
        SELECT ev.schema_name = 'graphql_public'
        FROM pg_event_trigger_dropped_objects() AS ev
        WHERE ev.schema_name = 'graphql_public'
    );

    IF graphql_is_dropped
    THEN
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language plpgsql
        as $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;
    END IF;

    END;
$_$;


ALTER FUNCTION extensions.set_graphql_placeholder() OWNER TO supabase_admin;

--
-- TOC entry 3956 (class 0 OID 0)
-- Dependencies: 349
-- Name: FUNCTION set_graphql_placeholder(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.set_graphql_placeholder() IS 'Reintroduces placeholder function for graphql_public.graphql';


--
-- TOC entry 282 (class 1255 OID 16386)
-- Name: get_auth(text); Type: FUNCTION; Schema: pgbouncer; Owner: postgres
--

CREATE FUNCTION pgbouncer.get_auth(p_usename text) RETURNS TABLE(username text, password text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RAISE WARNING 'PgBouncer auth request: %', p_usename;

    RETURN QUERY
    SELECT usename::TEXT, passwd::TEXT FROM pg_catalog.pg_shadow
    WHERE usename = p_usename;
END;
$$;


ALTER FUNCTION pgbouncer.get_auth(p_usename text) OWNER TO postgres;

--
-- TOC entry 495 (class 1255 OID 27113)
-- Name: check_if_user_exist(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.check_if_user_exist(in_login text, in_email text) RETURNS public.result_type_check_if_user_exist
    LANGUAGE plpgsql
    AS $$
DECLARE 
result_record result_type_check_if_user_exist;
BEGIN 
SELECT
  EXISTS(
    SELECT
      u.login
    FROM
      users as u
    WHERE
      u.login = LOWER(in_login)
  ) into result_record.result_login;
SELECT
  EXISTS(
    SELECT
      u.email
    FROM
      users as u
    WHERE
      u.email = LOWER(in_email)
  ) into result_record.result_email;
RETURN result_record;
END;
$$;


ALTER FUNCTION public.check_if_user_exist(in_login text, in_email text) OWNER TO postgres;

--
-- TOC entry 343 (class 1255 OID 16579)
-- Name: extension(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.extension(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
_filename text;
BEGIN
    select string_to_array(name, '/') into _parts;
    select _parts[array_length(_parts,1)] into _filename;
    -- @todo return the last part instead of 2
    return split_part(_filename, '.', 2);
END
$$;


ALTER FUNCTION storage.extension(name text) OWNER TO supabase_storage_admin;

--
-- TOC entry 342 (class 1255 OID 16578)
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.filename(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
    select string_to_array(name, '/') into _parts;
    return _parts[array_length(_parts,1)];
END
$$;


ALTER FUNCTION storage.filename(name text) OWNER TO supabase_storage_admin;

--
-- TOC entry 341 (class 1255 OID 16577)
-- Name: foldername(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.foldername(name text) RETURNS text[]
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
    select string_to_array(name, '/') into _parts;
    return _parts[1:array_length(_parts,1)-1];
END
$$;


ALTER FUNCTION storage.foldername(name text) OWNER TO supabase_storage_admin;

--
-- TOC entry 492 (class 1255 OID 27076)
-- Name: get_size_by_bucket(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_size_by_bucket() RETURNS TABLE(size bigint, bucket_id text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query
        select sum((metadata->>'size')::int) as size, obj.bucket_id
        from "storage".objects as obj
        group by obj.bucket_id;
END
$$;


ALTER FUNCTION storage.get_size_by_bucket() OWNER TO supabase_storage_admin;

--
-- TOC entry 493 (class 1255 OID 27078)
-- Name: search(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
declare
  v_order_by text;
  v_sort_order text;
begin
  case
    when sortcolumn = 'name' then
      v_order_by = 'name';
    when sortcolumn = 'updated_at' then
      v_order_by = 'updated_at';
    when sortcolumn = 'created_at' then
      v_order_by = 'created_at';
    when sortcolumn = 'last_accessed_at' then
      v_order_by = 'last_accessed_at';
    else
      v_order_by = 'name';
  end case;

  case
    when sortorder = 'asc' then
      v_sort_order = 'asc';
    when sortorder = 'desc' then
      v_sort_order = 'desc';
    else
      v_sort_order = 'asc';
  end case;

  v_order_by = v_order_by || ' ' || v_sort_order;

  return query execute
    'with folders as (
       select path_tokens[$1] as folder
       from storage.objects
         where objects.name ilike $2 || $3 || ''%''
           and bucket_id = $4
           and array_length(regexp_split_to_array(objects.name, ''/''), 1) <> $1
       group by folder
       order by folder ' || v_sort_order || '
     )
     (select folder as "name",
            null as id,
            null as updated_at,
            null as created_at,
            null as last_accessed_at,
            null as metadata from folders)
     union all
     (select path_tokens[$1] as "name",
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
     from storage.objects
     where objects.name ilike $2 || $3 || ''%''
       and bucket_id = $4
       and array_length(regexp_split_to_array(objects.name, ''/''), 1) = $1
     order by ' || v_order_by || ')
     limit $5
     offset $6' using levels, prefix, search, bucketname, limits, offsets;
end;
$_$;


ALTER FUNCTION storage.search(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text) OWNER TO supabase_storage_admin;

--
-- TOC entry 494 (class 1255 OID 27079)
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW; 
END;
$$;


ALTER FUNCTION storage.update_updated_at_column() OWNER TO supabase_storage_admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 239 (class 1259 OID 16518)
-- Name: audit_log_entries; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.audit_log_entries (
    instance_id uuid,
    id uuid NOT NULL,
    payload json,
    created_at timestamp with time zone,
    ip_address character varying(64) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE auth.audit_log_entries OWNER TO supabase_auth_admin;

--
-- TOC entry 4052 (class 0 OID 0)
-- Dependencies: 239
-- Name: TABLE audit_log_entries; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.audit_log_entries IS 'Auth: Audit trail for user actions.';


--
-- TOC entry 258 (class 1259 OID 26872)
-- Name: identities; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.identities (
    id text NOT NULL,
    user_id uuid NOT NULL,
    identity_data jsonb NOT NULL,
    provider text NOT NULL,
    last_sign_in_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    email text GENERATED ALWAYS AS (lower((identity_data ->> 'email'::text))) STORED
);


ALTER TABLE auth.identities OWNER TO supabase_auth_admin;

--
-- TOC entry 4054 (class 0 OID 0)
-- Dependencies: 258
-- Name: TABLE identities; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.identities IS 'Auth: Stores identities associated to a user.';


--
-- TOC entry 4055 (class 0 OID 0)
-- Dependencies: 258
-- Name: COLUMN identities.email; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.identities.email IS 'Auth: Email is a generated column that references the optional email property in the identity_data';


--
-- TOC entry 238 (class 1259 OID 16511)
-- Name: instances; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.instances (
    id uuid NOT NULL,
    uuid uuid,
    raw_base_config text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


ALTER TABLE auth.instances OWNER TO supabase_auth_admin;

--
-- TOC entry 4057 (class 0 OID 0)
-- Dependencies: 238
-- Name: TABLE instances; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.instances IS 'Auth: Manages users across multiple sites.';


--
-- TOC entry 262 (class 1259 OID 26962)
-- Name: mfa_amr_claims; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_amr_claims (
    session_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    authentication_method text NOT NULL,
    id uuid NOT NULL
);


ALTER TABLE auth.mfa_amr_claims OWNER TO supabase_auth_admin;

--
-- TOC entry 4059 (class 0 OID 0)
-- Dependencies: 262
-- Name: TABLE mfa_amr_claims; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_amr_claims IS 'auth: stores authenticator method reference claims for multi factor authentication';


--
-- TOC entry 261 (class 1259 OID 26950)
-- Name: mfa_challenges; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_challenges (
    id uuid NOT NULL,
    factor_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    verified_at timestamp with time zone,
    ip_address inet NOT NULL
);


ALTER TABLE auth.mfa_challenges OWNER TO supabase_auth_admin;

--
-- TOC entry 4061 (class 0 OID 0)
-- Dependencies: 261
-- Name: TABLE mfa_challenges; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_challenges IS 'auth: stores metadata about challenge requests made';


--
-- TOC entry 260 (class 1259 OID 26937)
-- Name: mfa_factors; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_factors (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    friendly_name text,
    factor_type auth.factor_type NOT NULL,
    status auth.factor_status NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    secret text
);


ALTER TABLE auth.mfa_factors OWNER TO supabase_auth_admin;

--
-- TOC entry 4063 (class 0 OID 0)
-- Dependencies: 260
-- Name: TABLE mfa_factors; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_factors IS 'auth: stores metadata about factors';


--
-- TOC entry 237 (class 1259 OID 16500)
-- Name: refresh_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.refresh_tokens (
    instance_id uuid,
    id bigint NOT NULL,
    token character varying(255),
    user_id character varying(255),
    revoked boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    parent character varying(255),
    session_id uuid
);


ALTER TABLE auth.refresh_tokens OWNER TO supabase_auth_admin;

--
-- TOC entry 4065 (class 0 OID 0)
-- Dependencies: 237
-- Name: TABLE refresh_tokens; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.refresh_tokens IS 'Auth: Store of tokens used to refresh JWT tokens once they expire.';


--
-- TOC entry 236 (class 1259 OID 16499)
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: auth; Owner: supabase_auth_admin
--

CREATE SEQUENCE auth.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth.refresh_tokens_id_seq OWNER TO supabase_auth_admin;

--
-- TOC entry 4067 (class 0 OID 0)
-- Dependencies: 236
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: supabase_auth_admin
--

ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;


--
-- TOC entry 265 (class 1259 OID 27004)
-- Name: saml_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_providers (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    entity_id text NOT NULL,
    metadata_xml text NOT NULL,
    metadata_url text,
    attribute_mapping jsonb,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "entity_id not empty" CHECK ((char_length(entity_id) > 0)),
    CONSTRAINT "metadata_url not empty" CHECK (((metadata_url = NULL::text) OR (char_length(metadata_url) > 0))),
    CONSTRAINT "metadata_xml not empty" CHECK ((char_length(metadata_xml) > 0))
);


ALTER TABLE auth.saml_providers OWNER TO supabase_auth_admin;

--
-- TOC entry 4069 (class 0 OID 0)
-- Dependencies: 265
-- Name: TABLE saml_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_providers IS 'Auth: Manages SAML Identity Provider connections.';


--
-- TOC entry 266 (class 1259 OID 27022)
-- Name: saml_relay_states; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_relay_states (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    request_id text NOT NULL,
    for_email text,
    redirect_to text,
    from_ip_address inet,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "request_id not empty" CHECK ((char_length(request_id) > 0))
);


ALTER TABLE auth.saml_relay_states OWNER TO supabase_auth_admin;

--
-- TOC entry 4071 (class 0 OID 0)
-- Dependencies: 266
-- Name: TABLE saml_relay_states; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_relay_states IS 'Auth: Contains SAML Relay State information for each Service Provider initiated login.';


--
-- TOC entry 240 (class 1259 OID 16526)
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE auth.schema_migrations OWNER TO supabase_auth_admin;

--
-- TOC entry 4073 (class 0 OID 0)
-- Dependencies: 240
-- Name: TABLE schema_migrations; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.schema_migrations IS 'Auth: Manages updates to the auth system.';


--
-- TOC entry 259 (class 1259 OID 26902)
-- Name: sessions; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sessions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    factor_id uuid,
    aal auth.aal_level,
    not_after timestamp with time zone
);


ALTER TABLE auth.sessions OWNER TO supabase_auth_admin;

--
-- TOC entry 4075 (class 0 OID 0)
-- Dependencies: 259
-- Name: TABLE sessions; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sessions IS 'Auth: Stores session data associated to a user.';


--
-- TOC entry 4076 (class 0 OID 0)
-- Dependencies: 259
-- Name: COLUMN sessions.not_after; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.not_after IS 'Auth: Not after is a nullable column that contains a timestamp after which the session should be regarded as expired.';


--
-- TOC entry 264 (class 1259 OID 26989)
-- Name: sso_domains; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_domains (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    domain text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "domain not empty" CHECK ((char_length(domain) > 0))
);


ALTER TABLE auth.sso_domains OWNER TO supabase_auth_admin;

--
-- TOC entry 4078 (class 0 OID 0)
-- Dependencies: 264
-- Name: TABLE sso_domains; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_domains IS 'Auth: Manages SSO email address domain mapping to an SSO Identity Provider.';


--
-- TOC entry 263 (class 1259 OID 26980)
-- Name: sso_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_providers (
    id uuid NOT NULL,
    resource_id text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "resource_id not empty" CHECK (((resource_id = NULL::text) OR (char_length(resource_id) > 0)))
);


ALTER TABLE auth.sso_providers OWNER TO supabase_auth_admin;

--
-- TOC entry 4080 (class 0 OID 0)
-- Dependencies: 263
-- Name: TABLE sso_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_providers IS 'Auth: Manages SSO identity provider information; see saml_providers for SAML.';


--
-- TOC entry 4081 (class 0 OID 0)
-- Dependencies: 263
-- Name: COLUMN sso_providers.resource_id; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sso_providers.resource_id IS 'Auth: Uniquely identifies a SSO provider according to a user-chosen resource ID (case insensitive), useful in infrastructure as code.';


--
-- TOC entry 235 (class 1259 OID 16488)
-- Name: users; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.users (
    instance_id uuid,
    id uuid NOT NULL,
    aud character varying(255),
    role character varying(255),
    email character varying(255),
    encrypted_password character varying(255),
    email_confirmed_at timestamp with time zone,
    invited_at timestamp with time zone,
    confirmation_token character varying(255),
    confirmation_sent_at timestamp with time zone,
    recovery_token character varying(255),
    recovery_sent_at timestamp with time zone,
    email_change_token_new character varying(255),
    email_change character varying(255),
    email_change_sent_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    raw_app_meta_data jsonb,
    raw_user_meta_data jsonb,
    is_super_admin boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    phone text DEFAULT NULL::character varying,
    phone_confirmed_at timestamp with time zone,
    phone_change text DEFAULT ''::character varying,
    phone_change_token character varying(255) DEFAULT ''::character varying,
    phone_change_sent_at timestamp with time zone,
    confirmed_at timestamp with time zone GENERATED ALWAYS AS (LEAST(email_confirmed_at, phone_confirmed_at)) STORED,
    email_change_token_current character varying(255) DEFAULT ''::character varying,
    email_change_confirm_status smallint DEFAULT 0,
    banned_until timestamp with time zone,
    reauthentication_token character varying(255) DEFAULT ''::character varying,
    reauthentication_sent_at timestamp with time zone,
    is_sso_user boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT users_email_change_confirm_status_check CHECK (((email_change_confirm_status >= 0) AND (email_change_confirm_status <= 2)))
);


ALTER TABLE auth.users OWNER TO supabase_auth_admin;

--
-- TOC entry 4083 (class 0 OID 0)
-- Dependencies: 235
-- Name: TABLE users; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.users IS 'Auth: Stores user login data within a secure schema.';


--
-- TOC entry 4084 (class 0 OID 0)
-- Dependencies: 235
-- Name: COLUMN users.is_sso_user; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.users.is_sso_user IS 'Auth: Set this column to true when the account comes from SSO. These accounts can have duplicate emails.';


--
-- TOC entry 269 (class 1259 OID 27177)
-- Name: cards; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cards (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    "createdAt" timestamp with time zone DEFAULT now(),
    "createdBy" text,
    "imageUrl" text,
    "isPrivate" boolean DEFAULT false
);


ALTER TABLE public.cards OWNER TO postgres;

--
-- TOC entry 270 (class 1259 OID 27206)
-- Name: situations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.situations (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    "createdAt" timestamp with time zone DEFAULT now(),
    "createdBy" text,
    description text
);


ALTER TABLE public.situations OWNER TO postgres;

--
-- TOC entry 267 (class 1259 OID 27086)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    login text,
    email text,
    "createdAt" timestamp with time zone DEFAULT now(),
    "imageUrl" text,
    color text,
    "backgroundColor" text
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 16539)
-- Name: buckets; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets (
    id text NOT NULL,
    name text NOT NULL,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    public boolean DEFAULT false,
    avif_autodetection boolean DEFAULT false,
    file_size_limit bigint,
    allowed_mime_types text[]
);


ALTER TABLE storage.buckets OWNER TO supabase_storage_admin;

--
-- TOC entry 243 (class 1259 OID 16581)
-- Name: migrations; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE storage.migrations OWNER TO supabase_storage_admin;

--
-- TOC entry 242 (class 1259 OID 16554)
-- Name: objects; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.objects (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    bucket_id text,
    name text,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_accessed_at timestamp with time zone DEFAULT now(),
    metadata jsonb,
    path_tokens text[] GENERATED ALWAYS AS (string_to_array(name, '/'::text)) STORED
);


ALTER TABLE storage.objects OWNER TO supabase_storage_admin;

--
-- TOC entry 3577 (class 2604 OID 16503)
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- TOC entry 3673 (class 2606 OID 26975)
-- Name: mfa_amr_claims amr_id_pk; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT amr_id_pk PRIMARY KEY (id);


--
-- TOC entry 3636 (class 2606 OID 16524)
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);


--
-- TOC entry 3660 (class 2606 OID 26878)
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (provider, id);


--
-- TOC entry 3634 (class 2606 OID 16517)
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- TOC entry 3675 (class 2606 OID 26968)
-- Name: mfa_amr_claims mfa_amr_claims_session_id_authentication_method_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey UNIQUE (session_id, authentication_method);


--
-- TOC entry 3671 (class 2606 OID 26956)
-- Name: mfa_challenges mfa_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_pkey PRIMARY KEY (id);


--
-- TOC entry 3668 (class 2606 OID 26943)
-- Name: mfa_factors mfa_factors_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_pkey PRIMARY KEY (id);


--
-- TOC entry 3628 (class 2606 OID 16507)
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- TOC entry 3632 (class 2606 OID 26885)
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);


--
-- TOC entry 3684 (class 2606 OID 27015)
-- Name: saml_providers saml_providers_entity_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_entity_id_key UNIQUE (entity_id);


--
-- TOC entry 3686 (class 2606 OID 27013)
-- Name: saml_providers saml_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_pkey PRIMARY KEY (id);


--
-- TOC entry 3690 (class 2606 OID 27029)
-- Name: saml_relay_states saml_relay_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_pkey PRIMARY KEY (id);


--
-- TOC entry 3639 (class 2606 OID 16530)
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- TOC entry 3663 (class 2606 OID 26906)
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- TOC entry 3681 (class 2606 OID 26996)
-- Name: sso_domains sso_domains_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_pkey PRIMARY KEY (id);


--
-- TOC entry 3677 (class 2606 OID 26987)
-- Name: sso_providers sso_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_providers
    ADD CONSTRAINT sso_providers_pkey PRIMARY KEY (id);


--
-- TOC entry 3621 (class 2606 OID 27144)
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- TOC entry 3623 (class 2606 OID 16494)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 3695 (class 2606 OID 27197)
-- Name: cards cards_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cards
    ADD CONSTRAINT cards_pkey PRIMARY KEY (id);


--
-- TOC entry 3697 (class 2606 OID 27222)
-- Name: situations situations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.situations
    ADD CONSTRAINT situations_pkey PRIMARY KEY (id);


--
-- TOC entry 3693 (class 2606 OID 27105)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 3642 (class 2606 OID 16547)
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- TOC entry 3648 (class 2606 OID 16588)
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- TOC entry 3650 (class 2606 OID 16586)
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 3646 (class 2606 OID 16564)
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- TOC entry 3637 (class 1259 OID 16525)
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- TOC entry 3612 (class 1259 OID 26895)
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 3613 (class 1259 OID 26897)
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 3614 (class 1259 OID 26898)
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 3666 (class 1259 OID 26977)
-- Name: factor_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX factor_id_created_at_idx ON auth.mfa_factors USING btree (user_id, created_at);


--
-- TOC entry 3658 (class 1259 OID 27065)
-- Name: identities_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_email_idx ON auth.identities USING btree (email text_pattern_ops);


--
-- TOC entry 4099 (class 0 OID 0)
-- Dependencies: 3658
-- Name: INDEX identities_email_idx; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.identities_email_idx IS 'Auth: Ensures indexed queries on the email column';


--
-- TOC entry 3661 (class 1259 OID 26892)
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);


--
-- TOC entry 3669 (class 1259 OID 26949)
-- Name: mfa_factors_user_friendly_name_unique; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX mfa_factors_user_friendly_name_unique ON auth.mfa_factors USING btree (friendly_name, user_id) WHERE (TRIM(BOTH FROM friendly_name) <> ''::text);


--
-- TOC entry 3615 (class 1259 OID 26899)
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 3616 (class 1259 OID 26896)
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 3624 (class 1259 OID 16508)
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);


--
-- TOC entry 3625 (class 1259 OID 16509)
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);


--
-- TOC entry 3626 (class 1259 OID 26891)
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);


--
-- TOC entry 3629 (class 1259 OID 26979)
-- Name: refresh_tokens_session_id_revoked_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_session_id_revoked_idx ON auth.refresh_tokens USING btree (session_id, revoked);


--
-- TOC entry 3630 (class 1259 OID 16510)
-- Name: refresh_tokens_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_token_idx ON auth.refresh_tokens USING btree (token);


--
-- TOC entry 3687 (class 1259 OID 27021)
-- Name: saml_providers_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_providers_sso_provider_id_idx ON auth.saml_providers USING btree (sso_provider_id);


--
-- TOC entry 3688 (class 1259 OID 27036)
-- Name: saml_relay_states_for_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_for_email_idx ON auth.saml_relay_states USING btree (for_email);


--
-- TOC entry 3691 (class 1259 OID 27035)
-- Name: saml_relay_states_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_sso_provider_id_idx ON auth.saml_relay_states USING btree (sso_provider_id);


--
-- TOC entry 3664 (class 1259 OID 26978)
-- Name: sessions_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_user_id_idx ON auth.sessions USING btree (user_id);


--
-- TOC entry 3679 (class 1259 OID 27003)
-- Name: sso_domains_domain_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_domains_domain_idx ON auth.sso_domains USING btree (lower(domain));


--
-- TOC entry 3682 (class 1259 OID 27002)
-- Name: sso_domains_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_domains_sso_provider_id_idx ON auth.sso_domains USING btree (sso_provider_id);


--
-- TOC entry 3678 (class 1259 OID 26988)
-- Name: sso_providers_resource_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_providers_resource_id_idx ON auth.sso_providers USING btree (lower(resource_id));


--
-- TOC entry 3665 (class 1259 OID 26976)
-- Name: user_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX user_id_created_at_idx ON auth.sessions USING btree (user_id, created_at);


--
-- TOC entry 3617 (class 1259 OID 27056)
-- Name: users_email_partial_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX users_email_partial_key ON auth.users USING btree (email) WHERE (is_sso_user = false);


--
-- TOC entry 4100 (class 0 OID 0)
-- Dependencies: 3617
-- Name: INDEX users_email_partial_key; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.users_email_partial_key IS 'Auth: A partial unique index that applies only when is_sso_user is false';


--
-- TOC entry 3618 (class 1259 OID 26893)
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));


--
-- TOC entry 3619 (class 1259 OID 16498)
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);


--
-- TOC entry 3640 (class 1259 OID 16553)
-- Name: bname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- TOC entry 3643 (class 1259 OID 16575)
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- TOC entry 3644 (class 1259 OID 16576)
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- TOC entry 3710 (class 2620 OID 27080)
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- TOC entry 3702 (class 2606 OID 26879)
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 3706 (class 2606 OID 26969)
-- Name: mfa_amr_claims mfa_amr_claims_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- TOC entry 3705 (class 2606 OID 26957)
-- Name: mfa_challenges mfa_challenges_auth_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_auth_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- TOC entry 3704 (class 2606 OID 26944)
-- Name: mfa_factors mfa_factors_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 3698 (class 2606 OID 26912)
-- Name: refresh_tokens refresh_tokens_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- TOC entry 3708 (class 2606 OID 27016)
-- Name: saml_providers saml_providers_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- TOC entry 3709 (class 2606 OID 27030)
-- Name: saml_relay_states saml_relay_states_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- TOC entry 3703 (class 2606 OID 26907)
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 3707 (class 2606 OID 26997)
-- Name: sso_domains sso_domains_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- TOC entry 3699 (class 2606 OID 16548)
-- Name: buckets buckets_owner_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_owner_fkey FOREIGN KEY (owner) REFERENCES auth.users(id);


--
-- TOC entry 3700 (class 2606 OID 16565)
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- TOC entry 3701 (class 2606 OID 16570)
-- Name: objects objects_owner_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_owner_fkey FOREIGN KEY (owner) REFERENCES auth.users(id);


--
-- TOC entry 3875 (class 3256 OID 27202)
-- Name: cards Enable delete for users based on user_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable delete for users based on user_id" ON public.cards FOR DELETE USING ((auth.uid() = ("createdBy")::uuid));


--
-- TOC entry 3879 (class 3256 OID 27226)
-- Name: situations Enable delete for users based on user_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable delete for users based on user_id" ON public.situations FOR DELETE USING ((auth.uid() = ("createdBy")::uuid));


--
-- TOC entry 3873 (class 3256 OID 27200)
-- Name: cards Enable insert for authenticated users only; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable insert for authenticated users only" ON public.cards FOR INSERT TO authenticated WITH CHECK (true);


--
-- TOC entry 3877 (class 3256 OID 27224)
-- Name: situations Enable insert for authenticated users only; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable insert for authenticated users only" ON public.situations FOR INSERT TO authenticated WITH CHECK (true);


--
-- TOC entry 3866 (class 3256 OID 27115)
-- Name: users Enable insert for authenticated users only; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable insert for authenticated users only" ON public.users FOR INSERT TO authenticated WITH CHECK (true);


--
-- TOC entry 3872 (class 3256 OID 27199)
-- Name: cards Enable read access for all users; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable read access for all users" ON public.cards FOR SELECT USING (true);


--
-- TOC entry 3876 (class 3256 OID 27223)
-- Name: situations Enable read access for all users; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable read access for all users" ON public.situations FOR SELECT USING (true);


--
-- TOC entry 3865 (class 3256 OID 27114)
-- Name: users Enable read access for all users; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable read access for all users" ON public.users FOR SELECT USING (true);


--
-- TOC entry 3874 (class 3256 OID 27201)
-- Name: cards Enable update for users based on email; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable update for users based on email" ON public.cards FOR UPDATE TO authenticated USING ((auth.uid() = ("createdBy")::uuid)) WITH CHECK ((auth.uid() = ("createdBy")::uuid));


--
-- TOC entry 3878 (class 3256 OID 27225)
-- Name: situations Enable update for users based on email; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable update for users based on email" ON public.situations FOR UPDATE USING ((auth.uid() = ("createdBy")::uuid)) WITH CHECK ((auth.uid() = ("createdBy")::uuid));


--
-- TOC entry 3867 (class 3256 OID 27116)
-- Name: users Enable update for users based on email; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable update for users based on email" ON public.users FOR UPDATE USING (((auth.jwt() ->> 'email'::text) = email)) WITH CHECK (((auth.jwt() ->> 'email'::text) = email));


--
-- TOC entry 3863 (class 0 OID 27177)
-- Dependencies: 269
-- Name: cards; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.cards ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 3864 (class 0 OID 27206)
-- Dependencies: 270
-- Name: situations; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.situations ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 3862 (class 0 OID 27086)
-- Dependencies: 267
-- Name: users; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 3870 (class 3256 OID 27140)
-- Name: objects Enable delete for users based on user_id; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Enable delete for users based on user_id" ON storage.objects FOR DELETE USING (true);


--
-- TOC entry 3871 (class 3256 OID 27138)
-- Name: objects Enable insert for authenticated users only; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Enable insert for authenticated users only" ON storage.objects FOR INSERT TO authenticated WITH CHECK ((auth.role() = 'authenticated'::text));


--
-- TOC entry 3868 (class 3256 OID 27131)
-- Name: objects Enable read access for all users; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Enable read access for all users" ON storage.objects FOR SELECT USING (true);


--
-- TOC entry 3869 (class 3256 OID 27139)
-- Name: objects Enable update for users based on email; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Enable update for users based on email" ON storage.objects FOR UPDATE TO authenticated USING (true) WITH CHECK (true);


--
-- TOC entry 3880 (class 3256 OID 27229)
-- Name: objects Give anon users access to JPG images in folder bir0aa_0; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Give anon users access to JPG images in folder bir0aa_0" ON storage.objects FOR SELECT USING (((bucket_id = 'meme-card-game'::text) AND (storage.extension(name) = 'jpg'::text) AND (lower((storage.foldername(name))[1]) = 'public'::text) AND (auth.role() = 'anon'::text)));


--
-- TOC entry 3859 (class 0 OID 16539)
-- Dependencies: 241
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 3861 (class 0 OID 16581)
-- Dependencies: 243
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 3860 (class 0 OID 16554)
-- Dependencies: 242
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 3881 (class 6104 OID 16419)
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: postgres
--

CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');


ALTER PUBLICATION supabase_realtime OWNER TO postgres;

--
-- TOC entry 3883 (class 6106 OID 27210)
-- Name: supabase_realtime cards; Type: PUBLICATION TABLE; Schema: public; Owner: postgres
--

ALTER PUBLICATION supabase_realtime ADD TABLE ONLY public.cards;


--
-- TOC entry 3882 (class 6106 OID 27209)
-- Name: supabase_realtime situations; Type: PUBLICATION TABLE; Schema: public; Owner: postgres
--

ALTER PUBLICATION supabase_realtime ADD TABLE ONLY public.situations;


--
-- TOC entry 3884 (class 6106 OID 27211)
-- Name: supabase_realtime users; Type: PUBLICATION TABLE; Schema: public; Owner: postgres
--

ALTER PUBLICATION supabase_realtime ADD TABLE ONLY public.users;


--
-- TOC entry 3890 (class 0 OID 0)
-- Dependencies: 24
-- Name: SCHEMA auth; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA auth TO anon;
GRANT USAGE ON SCHEMA auth TO authenticated;
GRANT USAGE ON SCHEMA auth TO service_role;
GRANT ALL ON SCHEMA auth TO supabase_auth_admin;
GRANT ALL ON SCHEMA auth TO dashboard_user;
GRANT ALL ON SCHEMA auth TO postgres;


--
-- TOC entry 3891 (class 0 OID 0)
-- Dependencies: 18
-- Name: SCHEMA extensions; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA extensions TO anon;
GRANT USAGE ON SCHEMA extensions TO authenticated;
GRANT USAGE ON SCHEMA extensions TO service_role;
GRANT ALL ON SCHEMA extensions TO dashboard_user;


--
-- TOC entry 3892 (class 0 OID 0)
-- Dependencies: 15
-- Name: SCHEMA graphql_public; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA graphql_public TO postgres;
GRANT USAGE ON SCHEMA graphql_public TO anon;
GRANT USAGE ON SCHEMA graphql_public TO authenticated;
GRANT USAGE ON SCHEMA graphql_public TO service_role;


--
-- TOC entry 3893 (class 0 OID 0)
-- Dependencies: 19
-- Name: SCHEMA pgsodium; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA pgsodium FROM supabase_admin;
REVOKE USAGE ON SCHEMA pgsodium FROM PUBLIC;
GRANT ALL ON SCHEMA pgsodium TO postgres;
GRANT USAGE ON SCHEMA pgsodium TO PUBLIC;


--
-- TOC entry 3895 (class 0 OID 0)
-- Dependencies: 17
-- Name: SCHEMA pgsodium_masks; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA pgsodium_masks FROM supabase_admin;
REVOKE USAGE ON SCHEMA pgsodium_masks FROM pgsodium_keyiduser;
GRANT ALL ON SCHEMA pgsodium_masks TO postgres;
GRANT USAGE ON SCHEMA pgsodium_masks TO pgsodium_keyiduser;


--
-- TOC entry 3896 (class 0 OID 0)
-- Dependencies: 12
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO postgres;
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA public TO service_role;


--
-- TOC entry 3897 (class 0 OID 0)
-- Dependencies: 14
-- Name: SCHEMA realtime; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA realtime TO postgres;


--
-- TOC entry 3898 (class 0 OID 0)
-- Dependencies: 13
-- Name: SCHEMA storage; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT ALL ON SCHEMA storage TO postgres;
GRANT USAGE ON SCHEMA storage TO anon;
GRANT USAGE ON SCHEMA storage TO authenticated;
GRANT USAGE ON SCHEMA storage TO service_role;
GRANT ALL ON SCHEMA storage TO supabase_storage_admin;
GRANT ALL ON SCHEMA storage TO dashboard_user;


--
-- TOC entry 3905 (class 0 OID 0)
-- Dependencies: 340
-- Name: FUNCTION email(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.email() TO dashboard_user;


--
-- TOC entry 3906 (class 0 OID 0)
-- Dependencies: 491
-- Name: FUNCTION jwt(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.jwt() TO postgres;
GRANT ALL ON FUNCTION auth.jwt() TO dashboard_user;


--
-- TOC entry 3908 (class 0 OID 0)
-- Dependencies: 339
-- Name: FUNCTION role(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.role() TO dashboard_user;


--
-- TOC entry 3910 (class 0 OID 0)
-- Dependencies: 338
-- Name: FUNCTION uid(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.uid() TO dashboard_user;


--
-- TOC entry 3911 (class 0 OID 0)
-- Dependencies: 334
-- Name: FUNCTION algorithm_sign(signables text, secret text, algorithm text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.algorithm_sign(signables text, secret text, algorithm text) TO dashboard_user;


--
-- TOC entry 3912 (class 0 OID 0)
-- Dependencies: 328
-- Name: FUNCTION armor(bytea); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.armor(bytea) TO dashboard_user;


--
-- TOC entry 3913 (class 0 OID 0)
-- Dependencies: 329
-- Name: FUNCTION armor(bytea, text[], text[]); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO dashboard_user;


--
-- TOC entry 3914 (class 0 OID 0)
-- Dependencies: 300
-- Name: FUNCTION crypt(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.crypt(text, text) TO dashboard_user;


--
-- TOC entry 3915 (class 0 OID 0)
-- Dependencies: 330
-- Name: FUNCTION dearmor(text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.dearmor(text) TO dashboard_user;


--
-- TOC entry 3916 (class 0 OID 0)
-- Dependencies: 304
-- Name: FUNCTION decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO dashboard_user;


--
-- TOC entry 3917 (class 0 OID 0)
-- Dependencies: 306
-- Name: FUNCTION decrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- TOC entry 3918 (class 0 OID 0)
-- Dependencies: 297
-- Name: FUNCTION digest(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO dashboard_user;


--
-- TOC entry 3919 (class 0 OID 0)
-- Dependencies: 296
-- Name: FUNCTION digest(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.digest(text, text) TO dashboard_user;


--
-- TOC entry 3920 (class 0 OID 0)
-- Dependencies: 303
-- Name: FUNCTION encrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO dashboard_user;


--
-- TOC entry 3921 (class 0 OID 0)
-- Dependencies: 305
-- Name: FUNCTION encrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- TOC entry 3922 (class 0 OID 0)
-- Dependencies: 307
-- Name: FUNCTION gen_random_bytes(integer); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO dashboard_user;


--
-- TOC entry 3923 (class 0 OID 0)
-- Dependencies: 308
-- Name: FUNCTION gen_random_uuid(); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO dashboard_user;


--
-- TOC entry 3924 (class 0 OID 0)
-- Dependencies: 301
-- Name: FUNCTION gen_salt(text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.gen_salt(text) TO dashboard_user;


--
-- TOC entry 3925 (class 0 OID 0)
-- Dependencies: 302
-- Name: FUNCTION gen_salt(text, integer); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO dashboard_user;


--
-- TOC entry 3927 (class 0 OID 0)
-- Dependencies: 344
-- Name: FUNCTION grant_pg_cron_access(); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO dashboard_user;


--
-- TOC entry 3930 (class 0 OID 0)
-- Dependencies: 345
-- Name: FUNCTION grant_pg_net_access(); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO dashboard_user;


--
-- TOC entry 3931 (class 0 OID 0)
-- Dependencies: 299
-- Name: FUNCTION hmac(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO dashboard_user;


--
-- TOC entry 3932 (class 0 OID 0)
-- Dependencies: 298
-- Name: FUNCTION hmac(text, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO dashboard_user;


--
-- TOC entry 3933 (class 0 OID 0)
-- Dependencies: 285
-- Name: FUNCTION pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT blk_read_time double precision, OUT blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT blk_read_time double precision, OUT blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision) TO dashboard_user;


--
-- TOC entry 3934 (class 0 OID 0)
-- Dependencies: 284
-- Name: FUNCTION pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO dashboard_user;


--
-- TOC entry 3935 (class 0 OID 0)
-- Dependencies: 283
-- Name: FUNCTION pg_stat_statements_reset(userid oid, dbid oid, queryid bigint); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint) TO dashboard_user;


--
-- TOC entry 3936 (class 0 OID 0)
-- Dependencies: 331
-- Name: FUNCTION pgp_armor_headers(text, OUT key text, OUT value text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO dashboard_user;


--
-- TOC entry 3937 (class 0 OID 0)
-- Dependencies: 327
-- Name: FUNCTION pgp_key_id(bytea); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO dashboard_user;


--
-- TOC entry 3938 (class 0 OID 0)
-- Dependencies: 321
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO dashboard_user;


--
-- TOC entry 3939 (class 0 OID 0)
-- Dependencies: 323
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO dashboard_user;


--
-- TOC entry 3940 (class 0 OID 0)
-- Dependencies: 325
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO dashboard_user;


--
-- TOC entry 3941 (class 0 OID 0)
-- Dependencies: 322
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- TOC entry 3942 (class 0 OID 0)
-- Dependencies: 324
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- TOC entry 3943 (class 0 OID 0)
-- Dependencies: 326
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO dashboard_user;


--
-- TOC entry 3944 (class 0 OID 0)
-- Dependencies: 317
-- Name: FUNCTION pgp_pub_encrypt(text, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO dashboard_user;


--
-- TOC entry 3945 (class 0 OID 0)
-- Dependencies: 319
-- Name: FUNCTION pgp_pub_encrypt(text, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO dashboard_user;


--
-- TOC entry 3946 (class 0 OID 0)
-- Dependencies: 318
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- TOC entry 3947 (class 0 OID 0)
-- Dependencies: 320
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- TOC entry 3948 (class 0 OID 0)
-- Dependencies: 313
-- Name: FUNCTION pgp_sym_decrypt(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO dashboard_user;


--
-- TOC entry 3949 (class 0 OID 0)
-- Dependencies: 315
-- Name: FUNCTION pgp_sym_decrypt(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO dashboard_user;


--
-- TOC entry 3950 (class 0 OID 0)
-- Dependencies: 314
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO dashboard_user;


--
-- TOC entry 3951 (class 0 OID 0)
-- Dependencies: 316
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- TOC entry 3952 (class 0 OID 0)
-- Dependencies: 309
-- Name: FUNCTION pgp_sym_encrypt(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO dashboard_user;


--
-- TOC entry 3953 (class 0 OID 0)
-- Dependencies: 311
-- Name: FUNCTION pgp_sym_encrypt(text, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO dashboard_user;


--
-- TOC entry 3954 (class 0 OID 0)
-- Dependencies: 310
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO dashboard_user;


--
-- TOC entry 3955 (class 0 OID 0)
-- Dependencies: 312
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- TOC entry 3957 (class 0 OID 0)
-- Dependencies: 335
-- Name: FUNCTION sign(payload json, secret text, algorithm text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.sign(payload json, secret text, algorithm text) TO dashboard_user;


--
-- TOC entry 3958 (class 0 OID 0)
-- Dependencies: 337
-- Name: FUNCTION try_cast_double(inp text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.try_cast_double(inp text) TO dashboard_user;


--
-- TOC entry 3959 (class 0 OID 0)
-- Dependencies: 333
-- Name: FUNCTION url_decode(data text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.url_decode(data text) TO dashboard_user;


--
-- TOC entry 3960 (class 0 OID 0)
-- Dependencies: 332
-- Name: FUNCTION url_encode(data bytea); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.url_encode(data bytea) TO dashboard_user;


--
-- TOC entry 3961 (class 0 OID 0)
-- Dependencies: 291
-- Name: FUNCTION uuid_generate_v1(); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO dashboard_user;


--
-- TOC entry 3962 (class 0 OID 0)
-- Dependencies: 292
-- Name: FUNCTION uuid_generate_v1mc(); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO dashboard_user;


--
-- TOC entry 3963 (class 0 OID 0)
-- Dependencies: 293
-- Name: FUNCTION uuid_generate_v3(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO dashboard_user;


--
-- TOC entry 3964 (class 0 OID 0)
-- Dependencies: 294
-- Name: FUNCTION uuid_generate_v4(); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO dashboard_user;


--
-- TOC entry 3965 (class 0 OID 0)
-- Dependencies: 295
-- Name: FUNCTION uuid_generate_v5(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO dashboard_user;


--
-- TOC entry 3966 (class 0 OID 0)
-- Dependencies: 286
-- Name: FUNCTION uuid_nil(); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.uuid_nil() TO dashboard_user;


--
-- TOC entry 3967 (class 0 OID 0)
-- Dependencies: 287
-- Name: FUNCTION uuid_ns_dns(); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO dashboard_user;


--
-- TOC entry 3968 (class 0 OID 0)
-- Dependencies: 289
-- Name: FUNCTION uuid_ns_oid(); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO dashboard_user;


--
-- TOC entry 3969 (class 0 OID 0)
-- Dependencies: 288
-- Name: FUNCTION uuid_ns_url(); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO dashboard_user;


--
-- TOC entry 3970 (class 0 OID 0)
-- Dependencies: 290
-- Name: FUNCTION uuid_ns_x500(); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO dashboard_user;


--
-- TOC entry 3971 (class 0 OID 0)
-- Dependencies: 336
-- Name: FUNCTION verify(token text, secret text, algorithm text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.verify(token text, secret text, algorithm text) TO dashboard_user;


--
-- TOC entry 3972 (class 0 OID 0)
-- Dependencies: 355
-- Name: FUNCTION comment_directive(comment_ text); Type: ACL; Schema: graphql; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql.comment_directive(comment_ text) TO postgres;
GRANT ALL ON FUNCTION graphql.comment_directive(comment_ text) TO anon;
GRANT ALL ON FUNCTION graphql.comment_directive(comment_ text) TO authenticated;
GRANT ALL ON FUNCTION graphql.comment_directive(comment_ text) TO service_role;


--
-- TOC entry 3973 (class 0 OID 0)
-- Dependencies: 352
-- Name: FUNCTION exception(message text); Type: ACL; Schema: graphql; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql.exception(message text) TO postgres;
GRANT ALL ON FUNCTION graphql.exception(message text) TO anon;
GRANT ALL ON FUNCTION graphql.exception(message text) TO authenticated;
GRANT ALL ON FUNCTION graphql.exception(message text) TO service_role;


--
-- TOC entry 3974 (class 0 OID 0)
-- Dependencies: 354
-- Name: FUNCTION get_schema_version(); Type: ACL; Schema: graphql; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql.get_schema_version() TO postgres;
GRANT ALL ON FUNCTION graphql.get_schema_version() TO anon;
GRANT ALL ON FUNCTION graphql.get_schema_version() TO authenticated;
GRANT ALL ON FUNCTION graphql.get_schema_version() TO service_role;


--
-- TOC entry 3975 (class 0 OID 0)
-- Dependencies: 353
-- Name: FUNCTION increment_schema_version(); Type: ACL; Schema: graphql; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql.increment_schema_version() TO postgres;
GRANT ALL ON FUNCTION graphql.increment_schema_version() TO anon;
GRANT ALL ON FUNCTION graphql.increment_schema_version() TO authenticated;
GRANT ALL ON FUNCTION graphql.increment_schema_version() TO service_role;


--
-- TOC entry 3976 (class 0 OID 0)
-- Dependencies: 351
-- Name: FUNCTION graphql("operationName" text, query text, variables jsonb, extensions jsonb); Type: ACL; Schema: graphql_public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO postgres;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO anon;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO authenticated;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO service_role;


--
-- TOC entry 3977 (class 0 OID 0)
-- Dependencies: 282
-- Name: FUNCTION get_auth(p_usename text); Type: ACL; Schema: pgbouncer; Owner: postgres
--

REVOKE ALL ON FUNCTION pgbouncer.get_auth(p_usename text) FROM PUBLIC;
GRANT ALL ON FUNCTION pgbouncer.get_auth(p_usename text) TO pgbouncer;


--
-- TOC entry 3978 (class 0 OID 0)
-- Dependencies: 252
-- Name: TABLE key; Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON TABLE pgsodium.key FROM supabase_admin;
REVOKE ALL ON TABLE pgsodium.key FROM pgsodium_keymaker;
GRANT ALL ON TABLE pgsodium.key TO postgres;
GRANT ALL ON TABLE pgsodium.key TO pgsodium_keymaker;


--
-- TOC entry 3979 (class 0 OID 0)
-- Dependencies: 254
-- Name: TABLE valid_key; Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON TABLE pgsodium.valid_key FROM supabase_admin;
REVOKE ALL ON TABLE pgsodium.valid_key FROM pgsodium_keyholder;
REVOKE SELECT ON TABLE pgsodium.valid_key FROM pgsodium_keyiduser;
GRANT ALL ON TABLE pgsodium.valid_key TO postgres;
GRANT ALL ON TABLE pgsodium.valid_key TO pgsodium_keyholder;
GRANT SELECT ON TABLE pgsodium.valid_key TO pgsodium_keyiduser;


--
-- TOC entry 3980 (class 0 OID 0)
-- Dependencies: 442
-- Name: FUNCTION crypto_aead_det_decrypt(ciphertext bytea, additional bytea, key bytea, nonce bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_aead_det_decrypt(ciphertext bytea, additional bytea, key bytea, nonce bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_aead_det_decrypt(ciphertext bytea, additional bytea, key bytea, nonce bytea) FROM pgsodium_keyholder;
GRANT ALL ON FUNCTION pgsodium.crypto_aead_det_decrypt(ciphertext bytea, additional bytea, key bytea, nonce bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_aead_det_decrypt(ciphertext bytea, additional bytea, key bytea, nonce bytea) TO pgsodium_keyholder;


--
-- TOC entry 3981 (class 0 OID 0)
-- Dependencies: 458
-- Name: FUNCTION crypto_aead_det_decrypt(message bytea, additional bytea, key_uuid uuid, nonce bytea); Type: ACL; Schema: pgsodium; Owner: pgsodium_keymaker
--

GRANT ALL ON FUNCTION pgsodium.crypto_aead_det_decrypt(message bytea, additional bytea, key_uuid uuid, nonce bytea) TO service_role;


--
-- TOC entry 3982 (class 0 OID 0)
-- Dependencies: 444
-- Name: FUNCTION crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) FROM pgsodium_keyiduser;
GRANT ALL ON FUNCTION pgsodium.crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO pgsodium_keyiduser;


--
-- TOC entry 3983 (class 0 OID 0)
-- Dependencies: 441
-- Name: FUNCTION crypto_aead_det_encrypt(message bytea, additional bytea, key bytea, nonce bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_aead_det_encrypt(message bytea, additional bytea, key bytea, nonce bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_aead_det_encrypt(message bytea, additional bytea, key bytea, nonce bytea) FROM pgsodium_keyholder;
GRANT ALL ON FUNCTION pgsodium.crypto_aead_det_encrypt(message bytea, additional bytea, key bytea, nonce bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_aead_det_encrypt(message bytea, additional bytea, key bytea, nonce bytea) TO pgsodium_keyholder;


--
-- TOC entry 3984 (class 0 OID 0)
-- Dependencies: 457
-- Name: FUNCTION crypto_aead_det_encrypt(message bytea, additional bytea, key_uuid uuid, nonce bytea); Type: ACL; Schema: pgsodium; Owner: pgsodium_keymaker
--

GRANT ALL ON FUNCTION pgsodium.crypto_aead_det_encrypt(message bytea, additional bytea, key_uuid uuid, nonce bytea) TO service_role;


--
-- TOC entry 3985 (class 0 OID 0)
-- Dependencies: 443
-- Name: FUNCTION crypto_aead_det_encrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_aead_det_encrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_aead_det_encrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) FROM pgsodium_keyiduser;
GRANT ALL ON FUNCTION pgsodium.crypto_aead_det_encrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_aead_det_encrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO pgsodium_keyiduser;


--
-- TOC entry 3986 (class 0 OID 0)
-- Dependencies: 440
-- Name: FUNCTION crypto_aead_det_keygen(); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_aead_det_keygen() FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_aead_det_keygen() FROM pgsodium_keymaker;
GRANT ALL ON FUNCTION pgsodium.crypto_aead_det_keygen() TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_aead_det_keygen() TO pgsodium_keymaker;
GRANT ALL ON FUNCTION pgsodium.crypto_aead_det_keygen() TO service_role;


--
-- TOC entry 3987 (class 0 OID 0)
-- Dependencies: 454
-- Name: FUNCTION crypto_aead_det_noncegen(); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_aead_det_noncegen() FROM PUBLIC;
REVOKE ALL ON FUNCTION pgsodium.crypto_aead_det_noncegen() FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_aead_det_noncegen() FROM pgsodium_keyiduser;
GRANT ALL ON FUNCTION pgsodium.crypto_aead_det_noncegen() TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_aead_det_noncegen() TO PUBLIC;
GRANT ALL ON FUNCTION pgsodium.crypto_aead_det_noncegen() TO pgsodium_keyiduser;


--
-- TOC entry 3988 (class 0 OID 0)
-- Dependencies: 421
-- Name: FUNCTION crypto_aead_ietf_decrypt(message bytea, additional bytea, nonce bytea, key bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_aead_ietf_decrypt(message bytea, additional bytea, nonce bytea, key bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_aead_ietf_decrypt(message bytea, additional bytea, nonce bytea, key bytea) FROM pgsodium_keyholder;
GRANT ALL ON FUNCTION pgsodium.crypto_aead_ietf_decrypt(message bytea, additional bytea, nonce bytea, key bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_aead_ietf_decrypt(message bytea, additional bytea, nonce bytea, key bytea) TO pgsodium_keyholder;


--
-- TOC entry 3989 (class 0 OID 0)
-- Dependencies: 423
-- Name: FUNCTION crypto_aead_ietf_decrypt(message bytea, additional bytea, nonce bytea, key_id bigint, context bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_aead_ietf_decrypt(message bytea, additional bytea, nonce bytea, key_id bigint, context bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_aead_ietf_decrypt(message bytea, additional bytea, nonce bytea, key_id bigint, context bytea) FROM pgsodium_keyiduser;
GRANT ALL ON FUNCTION pgsodium.crypto_aead_ietf_decrypt(message bytea, additional bytea, nonce bytea, key_id bigint, context bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_aead_ietf_decrypt(message bytea, additional bytea, nonce bytea, key_id bigint, context bytea) TO pgsodium_keyiduser;


--
-- TOC entry 3990 (class 0 OID 0)
-- Dependencies: 420
-- Name: FUNCTION crypto_aead_ietf_encrypt(message bytea, additional bytea, nonce bytea, key bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_aead_ietf_encrypt(message bytea, additional bytea, nonce bytea, key bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_aead_ietf_encrypt(message bytea, additional bytea, nonce bytea, key bytea) FROM pgsodium_keyholder;
GRANT ALL ON FUNCTION pgsodium.crypto_aead_ietf_encrypt(message bytea, additional bytea, nonce bytea, key bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_aead_ietf_encrypt(message bytea, additional bytea, nonce bytea, key bytea) TO pgsodium_keyholder;


--
-- TOC entry 3991 (class 0 OID 0)
-- Dependencies: 422
-- Name: FUNCTION crypto_aead_ietf_encrypt(message bytea, additional bytea, nonce bytea, key_id bigint, context bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_aead_ietf_encrypt(message bytea, additional bytea, nonce bytea, key_id bigint, context bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_aead_ietf_encrypt(message bytea, additional bytea, nonce bytea, key_id bigint, context bytea) FROM pgsodium_keyiduser;
GRANT ALL ON FUNCTION pgsodium.crypto_aead_ietf_encrypt(message bytea, additional bytea, nonce bytea, key_id bigint, context bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_aead_ietf_encrypt(message bytea, additional bytea, nonce bytea, key_id bigint, context bytea) TO pgsodium_keyiduser;


--
-- TOC entry 3992 (class 0 OID 0)
-- Dependencies: 418
-- Name: FUNCTION crypto_aead_ietf_keygen(); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_aead_ietf_keygen() FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_aead_ietf_keygen() FROM pgsodium_keymaker;
GRANT ALL ON FUNCTION pgsodium.crypto_aead_ietf_keygen() TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_aead_ietf_keygen() TO pgsodium_keymaker;


--
-- TOC entry 3993 (class 0 OID 0)
-- Dependencies: 419
-- Name: FUNCTION crypto_aead_ietf_noncegen(); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_aead_ietf_noncegen() FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_aead_ietf_noncegen() FROM pgsodium_keyiduser;
GRANT ALL ON FUNCTION pgsodium.crypto_aead_ietf_noncegen() TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_aead_ietf_noncegen() TO pgsodium_keyiduser;


--
-- TOC entry 3994 (class 0 OID 0)
-- Dependencies: 363
-- Name: FUNCTION crypto_auth(message bytea, key bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_auth(message bytea, key bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_auth(message bytea, key bytea) FROM pgsodium_keyholder;
GRANT ALL ON FUNCTION pgsodium.crypto_auth(message bytea, key bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_auth(message bytea, key bytea) TO pgsodium_keyholder;


--
-- TOC entry 3995 (class 0 OID 0)
-- Dependencies: 416
-- Name: FUNCTION crypto_auth(message bytea, key_id bigint, context bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_auth(message bytea, key_id bigint, context bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_auth(message bytea, key_id bigint, context bytea) FROM pgsodium_keyiduser;
GRANT ALL ON FUNCTION pgsodium.crypto_auth(message bytea, key_id bigint, context bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_auth(message bytea, key_id bigint, context bytea) TO pgsodium_keyiduser;


--
-- TOC entry 3996 (class 0 OID 0)
-- Dependencies: 406
-- Name: FUNCTION crypto_auth_hmacsha256(message bytea, secret bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_auth_hmacsha256(message bytea, secret bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_auth_hmacsha256(message bytea, secret bytea) FROM pgsodium_keyholder;
GRANT ALL ON FUNCTION pgsodium.crypto_auth_hmacsha256(message bytea, secret bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_auth_hmacsha256(message bytea, secret bytea) TO pgsodium_keyholder;


--
-- TOC entry 3997 (class 0 OID 0)
-- Dependencies: 438
-- Name: FUNCTION crypto_auth_hmacsha256(message bytea, key_id bigint, context bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_auth_hmacsha256(message bytea, key_id bigint, context bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_auth_hmacsha256(message bytea, key_id bigint, context bytea) FROM pgsodium_keyiduser;
GRANT ALL ON FUNCTION pgsodium.crypto_auth_hmacsha256(message bytea, key_id bigint, context bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_auth_hmacsha256(message bytea, key_id bigint, context bytea) TO pgsodium_keyiduser;


--
-- TOC entry 3998 (class 0 OID 0)
-- Dependencies: 405
-- Name: FUNCTION crypto_auth_hmacsha256_keygen(); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_auth_hmacsha256_keygen() FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_auth_hmacsha256_keygen() FROM pgsodium_keymaker;
GRANT ALL ON FUNCTION pgsodium.crypto_auth_hmacsha256_keygen() TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_auth_hmacsha256_keygen() TO pgsodium_keymaker;


--
-- TOC entry 3999 (class 0 OID 0)
-- Dependencies: 407
-- Name: FUNCTION crypto_auth_hmacsha256_verify(hash bytea, message bytea, secret bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_auth_hmacsha256_verify(hash bytea, message bytea, secret bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_auth_hmacsha256_verify(hash bytea, message bytea, secret bytea) FROM pgsodium_keyholder;
GRANT ALL ON FUNCTION pgsodium.crypto_auth_hmacsha256_verify(hash bytea, message bytea, secret bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_auth_hmacsha256_verify(hash bytea, message bytea, secret bytea) TO pgsodium_keyholder;


--
-- TOC entry 4000 (class 0 OID 0)
-- Dependencies: 439
-- Name: FUNCTION crypto_auth_hmacsha256_verify(hash bytea, message bytea, key_id bigint, context bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_auth_hmacsha256_verify(hash bytea, message bytea, key_id bigint, context bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_auth_hmacsha256_verify(hash bytea, message bytea, key_id bigint, context bytea) FROM pgsodium_keyiduser;
GRANT ALL ON FUNCTION pgsodium.crypto_auth_hmacsha256_verify(hash bytea, message bytea, key_id bigint, context bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_auth_hmacsha256_verify(hash bytea, message bytea, key_id bigint, context bytea) TO pgsodium_keyiduser;


--
-- TOC entry 4001 (class 0 OID 0)
-- Dependencies: 388
-- Name: FUNCTION crypto_auth_hmacsha512(message bytea, secret bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_auth_hmacsha512(message bytea, secret bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_auth_hmacsha512(message bytea, secret bytea) FROM pgsodium_keyholder;
GRANT ALL ON FUNCTION pgsodium.crypto_auth_hmacsha512(message bytea, secret bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_auth_hmacsha512(message bytea, secret bytea) TO pgsodium_keyholder;


--
-- TOC entry 4002 (class 0 OID 0)
-- Dependencies: 436
-- Name: FUNCTION crypto_auth_hmacsha512(message bytea, key_id bigint, context bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_auth_hmacsha512(message bytea, key_id bigint, context bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_auth_hmacsha512(message bytea, key_id bigint, context bytea) FROM pgsodium_keyiduser;
GRANT ALL ON FUNCTION pgsodium.crypto_auth_hmacsha512(message bytea, key_id bigint, context bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_auth_hmacsha512(message bytea, key_id bigint, context bytea) TO pgsodium_keyiduser;


--
-- TOC entry 4003 (class 0 OID 0)
-- Dependencies: 389
-- Name: FUNCTION crypto_auth_hmacsha512_verify(hash bytea, message bytea, secret bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_auth_hmacsha512_verify(hash bytea, message bytea, secret bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_auth_hmacsha512_verify(hash bytea, message bytea, secret bytea) FROM pgsodium_keyholder;
GRANT ALL ON FUNCTION pgsodium.crypto_auth_hmacsha512_verify(hash bytea, message bytea, secret bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_auth_hmacsha512_verify(hash bytea, message bytea, secret bytea) TO pgsodium_keyholder;


--
-- TOC entry 4004 (class 0 OID 0)
-- Dependencies: 437
-- Name: FUNCTION crypto_auth_hmacsha512_verify(hash bytea, message bytea, key_id bigint, context bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_auth_hmacsha512_verify(hash bytea, message bytea, key_id bigint, context bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_auth_hmacsha512_verify(hash bytea, message bytea, key_id bigint, context bytea) FROM pgsodium_keyiduser;
GRANT ALL ON FUNCTION pgsodium.crypto_auth_hmacsha512_verify(hash bytea, message bytea, key_id bigint, context bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_auth_hmacsha512_verify(hash bytea, message bytea, key_id bigint, context bytea) TO pgsodium_keyiduser;


--
-- TOC entry 4005 (class 0 OID 0)
-- Dependencies: 365
-- Name: FUNCTION crypto_auth_keygen(); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_auth_keygen() FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_auth_keygen() FROM pgsodium_keymaker;
GRANT ALL ON FUNCTION pgsodium.crypto_auth_keygen() TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_auth_keygen() TO pgsodium_keymaker;


--
-- TOC entry 4006 (class 0 OID 0)
-- Dependencies: 364
-- Name: FUNCTION crypto_auth_verify(mac bytea, message bytea, key bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_auth_verify(mac bytea, message bytea, key bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_auth_verify(mac bytea, message bytea, key bytea) FROM pgsodium_keyholder;
GRANT ALL ON FUNCTION pgsodium.crypto_auth_verify(mac bytea, message bytea, key bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_auth_verify(mac bytea, message bytea, key bytea) TO pgsodium_keyholder;


--
-- TOC entry 4007 (class 0 OID 0)
-- Dependencies: 417
-- Name: FUNCTION crypto_auth_verify(mac bytea, message bytea, key_id bigint, context bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_auth_verify(mac bytea, message bytea, key_id bigint, context bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_auth_verify(mac bytea, message bytea, key_id bigint, context bytea) FROM pgsodium_keyiduser;
GRANT ALL ON FUNCTION pgsodium.crypto_auth_verify(mac bytea, message bytea, key_id bigint, context bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_auth_verify(mac bytea, message bytea, key_id bigint, context bytea) TO pgsodium_keyiduser;


--
-- TOC entry 4008 (class 0 OID 0)
-- Dependencies: 369
-- Name: FUNCTION crypto_box(message bytea, nonce bytea, public bytea, secret bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_box(message bytea, nonce bytea, public bytea, secret bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_box(message bytea, nonce bytea, public bytea, secret bytea) FROM pgsodium_keyholder;
GRANT ALL ON FUNCTION pgsodium.crypto_box(message bytea, nonce bytea, public bytea, secret bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_box(message bytea, nonce bytea, public bytea, secret bytea) TO pgsodium_keyholder;


--
-- TOC entry 4009 (class 0 OID 0)
-- Dependencies: 398
-- Name: FUNCTION crypto_box_new_keypair(); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_box_new_keypair() FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_box_new_keypair() FROM pgsodium_keymaker;
GRANT ALL ON FUNCTION pgsodium.crypto_box_new_keypair() TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_box_new_keypair() TO pgsodium_keymaker;


--
-- TOC entry 4010 (class 0 OID 0)
-- Dependencies: 368
-- Name: FUNCTION crypto_box_noncegen(); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_box_noncegen() FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_box_noncegen() FROM pgsodium_keymaker;
GRANT ALL ON FUNCTION pgsodium.crypto_box_noncegen() TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_box_noncegen() TO pgsodium_keymaker;


--
-- TOC entry 4011 (class 0 OID 0)
-- Dependencies: 370
-- Name: FUNCTION crypto_box_open(ciphertext bytea, nonce bytea, public bytea, secret bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_box_open(ciphertext bytea, nonce bytea, public bytea, secret bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_box_open(ciphertext bytea, nonce bytea, public bytea, secret bytea) FROM pgsodium_keyholder;
GRANT ALL ON FUNCTION pgsodium.crypto_box_open(ciphertext bytea, nonce bytea, public bytea, secret bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_box_open(ciphertext bytea, nonce bytea, public bytea, secret bytea) TO pgsodium_keyholder;


--
-- TOC entry 4012 (class 0 OID 0)
-- Dependencies: 401
-- Name: FUNCTION crypto_box_seed_new_keypair(seed bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_box_seed_new_keypair(seed bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_box_seed_new_keypair(seed bytea) FROM pgsodium_keymaker;
GRANT ALL ON FUNCTION pgsodium.crypto_box_seed_new_keypair(seed bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_box_seed_new_keypair(seed bytea) TO pgsodium_keymaker;


--
-- TOC entry 4013 (class 0 OID 0)
-- Dependencies: 366
-- Name: FUNCTION crypto_generichash(message bytea, key bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_generichash(message bytea, key bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_generichash(message bytea, key bytea) FROM pgsodium_keyiduser;
GRANT ALL ON FUNCTION pgsodium.crypto_generichash(message bytea, key bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_generichash(message bytea, key bytea) TO pgsodium_keyiduser;


--
-- TOC entry 4014 (class 0 OID 0)
-- Dependencies: 413
-- Name: FUNCTION crypto_generichash_keygen(); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_generichash_keygen() FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_generichash_keygen() FROM pgsodium_keymaker;
GRANT ALL ON FUNCTION pgsodium.crypto_generichash_keygen() TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_generichash_keygen() TO pgsodium_keymaker;


--
-- TOC entry 4015 (class 0 OID 0)
-- Dependencies: 410
-- Name: FUNCTION crypto_kdf_derive_from_key(subkey_size bigint, subkey_id bigint, context bytea, primary_key bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_kdf_derive_from_key(subkey_size bigint, subkey_id bigint, context bytea, primary_key bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_kdf_derive_from_key(subkey_size bigint, subkey_id bigint, context bytea, primary_key bytea) FROM pgsodium_keymaker;
GRANT ALL ON FUNCTION pgsodium.crypto_kdf_derive_from_key(subkey_size bigint, subkey_id bigint, context bytea, primary_key bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_kdf_derive_from_key(subkey_size bigint, subkey_id bigint, context bytea, primary_key bytea) TO pgsodium_keymaker;


--
-- TOC entry 4016 (class 0 OID 0)
-- Dependencies: 381
-- Name: FUNCTION crypto_kdf_keygen(); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_kdf_keygen() FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_kdf_keygen() FROM pgsodium_keymaker;
GRANT ALL ON FUNCTION pgsodium.crypto_kdf_keygen() TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_kdf_keygen() TO pgsodium_keymaker;


--
-- TOC entry 4017 (class 0 OID 0)
-- Dependencies: 382
-- Name: FUNCTION crypto_kx_new_keypair(); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_kx_new_keypair() FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_kx_new_keypair() FROM pgsodium_keymaker;
GRANT ALL ON FUNCTION pgsodium.crypto_kx_new_keypair() TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_kx_new_keypair() TO pgsodium_keymaker;


--
-- TOC entry 4018 (class 0 OID 0)
-- Dependencies: 383
-- Name: FUNCTION crypto_kx_new_seed(); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_kx_new_seed() FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_kx_new_seed() FROM pgsodium_keymaker;
GRANT ALL ON FUNCTION pgsodium.crypto_kx_new_seed() TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_kx_new_seed() TO pgsodium_keymaker;


--
-- TOC entry 4019 (class 0 OID 0)
-- Dependencies: 384
-- Name: FUNCTION crypto_kx_seed_new_keypair(seed bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_kx_seed_new_keypair(seed bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_kx_seed_new_keypair(seed bytea) FROM pgsodium_keymaker;
GRANT ALL ON FUNCTION pgsodium.crypto_kx_seed_new_keypair(seed bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_kx_seed_new_keypair(seed bytea) TO pgsodium_keymaker;


--
-- TOC entry 4020 (class 0 OID 0)
-- Dependencies: 361
-- Name: FUNCTION crypto_secretbox(message bytea, nonce bytea, key bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_secretbox(message bytea, nonce bytea, key bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_secretbox(message bytea, nonce bytea, key bytea) FROM pgsodium_keyholder;
GRANT ALL ON FUNCTION pgsodium.crypto_secretbox(message bytea, nonce bytea, key bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_secretbox(message bytea, nonce bytea, key bytea) TO pgsodium_keyholder;


--
-- TOC entry 4021 (class 0 OID 0)
-- Dependencies: 414
-- Name: FUNCTION crypto_secretbox(message bytea, nonce bytea, key_id bigint, context bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_secretbox(message bytea, nonce bytea, key_id bigint, context bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_secretbox(message bytea, nonce bytea, key_id bigint, context bytea) FROM pgsodium_keyiduser;
GRANT ALL ON FUNCTION pgsodium.crypto_secretbox(message bytea, nonce bytea, key_id bigint, context bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_secretbox(message bytea, nonce bytea, key_id bigint, context bytea) TO pgsodium_keyiduser;


--
-- TOC entry 4022 (class 0 OID 0)
-- Dependencies: 359
-- Name: FUNCTION crypto_secretbox_keygen(); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_secretbox_keygen() FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_secretbox_keygen() FROM pgsodium_keymaker;
GRANT ALL ON FUNCTION pgsodium.crypto_secretbox_keygen() TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_secretbox_keygen() TO pgsodium_keymaker;


--
-- TOC entry 4023 (class 0 OID 0)
-- Dependencies: 360
-- Name: FUNCTION crypto_secretbox_noncegen(); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_secretbox_noncegen() FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_secretbox_noncegen() FROM pgsodium_keyiduser;
GRANT ALL ON FUNCTION pgsodium.crypto_secretbox_noncegen() TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_secretbox_noncegen() TO pgsodium_keyiduser;


--
-- TOC entry 4024 (class 0 OID 0)
-- Dependencies: 362
-- Name: FUNCTION crypto_secretbox_open(ciphertext bytea, nonce bytea, key bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_secretbox_open(ciphertext bytea, nonce bytea, key bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_secretbox_open(ciphertext bytea, nonce bytea, key bytea) FROM pgsodium_keyholder;
GRANT ALL ON FUNCTION pgsodium.crypto_secretbox_open(ciphertext bytea, nonce bytea, key bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_secretbox_open(ciphertext bytea, nonce bytea, key bytea) TO pgsodium_keyholder;


--
-- TOC entry 4025 (class 0 OID 0)
-- Dependencies: 415
-- Name: FUNCTION crypto_secretbox_open(message bytea, nonce bytea, key_id bigint, context bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_secretbox_open(message bytea, nonce bytea, key_id bigint, context bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_secretbox_open(message bytea, nonce bytea, key_id bigint, context bytea) FROM pgsodium_keyiduser;
GRANT ALL ON FUNCTION pgsodium.crypto_secretbox_open(message bytea, nonce bytea, key_id bigint, context bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_secretbox_open(message bytea, nonce bytea, key_id bigint, context bytea) TO pgsodium_keyiduser;


--
-- TOC entry 4026 (class 0 OID 0)
-- Dependencies: 367
-- Name: FUNCTION crypto_shorthash(message bytea, key bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_shorthash(message bytea, key bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_shorthash(message bytea, key bytea) FROM pgsodium_keyiduser;
GRANT ALL ON FUNCTION pgsodium.crypto_shorthash(message bytea, key bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_shorthash(message bytea, key bytea) TO pgsodium_keyiduser;


--
-- TOC entry 4027 (class 0 OID 0)
-- Dependencies: 412
-- Name: FUNCTION crypto_shorthash_keygen(); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_shorthash_keygen() FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_shorthash_keygen() FROM pgsodium_keymaker;
GRANT ALL ON FUNCTION pgsodium.crypto_shorthash_keygen() TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_shorthash_keygen() TO pgsodium_keymaker;


--
-- TOC entry 4028 (class 0 OID 0)
-- Dependencies: 394
-- Name: FUNCTION crypto_sign_final_create(state bytea, key bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_sign_final_create(state bytea, key bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_sign_final_create(state bytea, key bytea) FROM pgsodium_keyholder;
GRANT ALL ON FUNCTION pgsodium.crypto_sign_final_create(state bytea, key bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_sign_final_create(state bytea, key bytea) TO pgsodium_keyholder;


--
-- TOC entry 4029 (class 0 OID 0)
-- Dependencies: 395
-- Name: FUNCTION crypto_sign_final_verify(state bytea, signature bytea, key bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_sign_final_verify(state bytea, signature bytea, key bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_sign_final_verify(state bytea, signature bytea, key bytea) FROM pgsodium_keyholder;
GRANT ALL ON FUNCTION pgsodium.crypto_sign_final_verify(state bytea, signature bytea, key bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_sign_final_verify(state bytea, signature bytea, key bytea) TO pgsodium_keyholder;


--
-- TOC entry 4030 (class 0 OID 0)
-- Dependencies: 392
-- Name: FUNCTION crypto_sign_init(); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_sign_init() FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_sign_init() FROM pgsodium_keyholder;
GRANT ALL ON FUNCTION pgsodium.crypto_sign_init() TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_sign_init() TO pgsodium_keyholder;


--
-- TOC entry 4031 (class 0 OID 0)
-- Dependencies: 399
-- Name: FUNCTION crypto_sign_new_keypair(); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_sign_new_keypair() FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_sign_new_keypair() FROM pgsodium_keymaker;
GRANT ALL ON FUNCTION pgsodium.crypto_sign_new_keypair() TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_sign_new_keypair() TO pgsodium_keymaker;


--
-- TOC entry 4032 (class 0 OID 0)
-- Dependencies: 393
-- Name: FUNCTION crypto_sign_update(state bytea, message bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_sign_update(state bytea, message bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_sign_update(state bytea, message bytea) FROM pgsodium_keyholder;
GRANT ALL ON FUNCTION pgsodium.crypto_sign_update(state bytea, message bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_sign_update(state bytea, message bytea) TO pgsodium_keyholder;


--
-- TOC entry 4033 (class 0 OID 0)
-- Dependencies: 396
-- Name: FUNCTION crypto_sign_update_agg1(state bytea, message bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_sign_update_agg1(state bytea, message bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_sign_update_agg1(state bytea, message bytea) FROM pgsodium_keyholder;
GRANT ALL ON FUNCTION pgsodium.crypto_sign_update_agg1(state bytea, message bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_sign_update_agg1(state bytea, message bytea) TO pgsodium_keyholder;


--
-- TOC entry 4034 (class 0 OID 0)
-- Dependencies: 397
-- Name: FUNCTION crypto_sign_update_agg2(cur_state bytea, initial_state bytea, message bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_sign_update_agg2(cur_state bytea, initial_state bytea, message bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_sign_update_agg2(cur_state bytea, initial_state bytea, message bytea) FROM pgsodium_keyholder;
GRANT ALL ON FUNCTION pgsodium.crypto_sign_update_agg2(cur_state bytea, initial_state bytea, message bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_sign_update_agg2(cur_state bytea, initial_state bytea, message bytea) TO pgsodium_keyholder;


--
-- TOC entry 4035 (class 0 OID 0)
-- Dependencies: 445
-- Name: FUNCTION crypto_signcrypt_new_keypair(); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_signcrypt_new_keypair() FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_signcrypt_new_keypair() FROM pgsodium_keymaker;
GRANT ALL ON FUNCTION pgsodium.crypto_signcrypt_new_keypair() TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_signcrypt_new_keypair() TO pgsodium_keymaker;


--
-- TOC entry 4036 (class 0 OID 0)
-- Dependencies: 447
-- Name: FUNCTION crypto_signcrypt_sign_after(state bytea, sender_sk bytea, ciphertext bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_signcrypt_sign_after(state bytea, sender_sk bytea, ciphertext bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_signcrypt_sign_after(state bytea, sender_sk bytea, ciphertext bytea) FROM pgsodium_keyholder;
GRANT ALL ON FUNCTION pgsodium.crypto_signcrypt_sign_after(state bytea, sender_sk bytea, ciphertext bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_signcrypt_sign_after(state bytea, sender_sk bytea, ciphertext bytea) TO pgsodium_keyholder;


--
-- TOC entry 4037 (class 0 OID 0)
-- Dependencies: 446
-- Name: FUNCTION crypto_signcrypt_sign_before(sender bytea, recipient bytea, sender_sk bytea, recipient_pk bytea, additional bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_signcrypt_sign_before(sender bytea, recipient bytea, sender_sk bytea, recipient_pk bytea, additional bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_signcrypt_sign_before(sender bytea, recipient bytea, sender_sk bytea, recipient_pk bytea, additional bytea) FROM pgsodium_keyholder;
GRANT ALL ON FUNCTION pgsodium.crypto_signcrypt_sign_before(sender bytea, recipient bytea, sender_sk bytea, recipient_pk bytea, additional bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_signcrypt_sign_before(sender bytea, recipient bytea, sender_sk bytea, recipient_pk bytea, additional bytea) TO pgsodium_keyholder;


--
-- TOC entry 4038 (class 0 OID 0)
-- Dependencies: 449
-- Name: FUNCTION crypto_signcrypt_verify_after(state bytea, signature bytea, sender_pk bytea, ciphertext bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_signcrypt_verify_after(state bytea, signature bytea, sender_pk bytea, ciphertext bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_signcrypt_verify_after(state bytea, signature bytea, sender_pk bytea, ciphertext bytea) FROM pgsodium_keyholder;
GRANT ALL ON FUNCTION pgsodium.crypto_signcrypt_verify_after(state bytea, signature bytea, sender_pk bytea, ciphertext bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_signcrypt_verify_after(state bytea, signature bytea, sender_pk bytea, ciphertext bytea) TO pgsodium_keyholder;


--
-- TOC entry 4039 (class 0 OID 0)
-- Dependencies: 448
-- Name: FUNCTION crypto_signcrypt_verify_before(signature bytea, sender bytea, recipient bytea, additional bytea, sender_pk bytea, recipient_sk bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_signcrypt_verify_before(signature bytea, sender bytea, recipient bytea, additional bytea, sender_pk bytea, recipient_sk bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_signcrypt_verify_before(signature bytea, sender bytea, recipient bytea, additional bytea, sender_pk bytea, recipient_sk bytea) FROM pgsodium_keyholder;
GRANT ALL ON FUNCTION pgsodium.crypto_signcrypt_verify_before(signature bytea, sender bytea, recipient bytea, additional bytea, sender_pk bytea, recipient_sk bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_signcrypt_verify_before(signature bytea, sender bytea, recipient bytea, additional bytea, sender_pk bytea, recipient_sk bytea) TO pgsodium_keyholder;


--
-- TOC entry 4040 (class 0 OID 0)
-- Dependencies: 450
-- Name: FUNCTION crypto_signcrypt_verify_public(signature bytea, sender bytea, recipient bytea, additional bytea, sender_pk bytea, ciphertext bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.crypto_signcrypt_verify_public(signature bytea, sender bytea, recipient bytea, additional bytea, sender_pk bytea, ciphertext bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.crypto_signcrypt_verify_public(signature bytea, sender bytea, recipient bytea, additional bytea, sender_pk bytea, ciphertext bytea) FROM pgsodium_keyholder;
GRANT ALL ON FUNCTION pgsodium.crypto_signcrypt_verify_public(signature bytea, sender bytea, recipient bytea, additional bytea, sender_pk bytea, ciphertext bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.crypto_signcrypt_verify_public(signature bytea, sender bytea, recipient bytea, additional bytea, sender_pk bytea, ciphertext bytea) TO pgsodium_keyholder;


--
-- TOC entry 4041 (class 0 OID 0)
-- Dependencies: 411
-- Name: FUNCTION derive_key(key_id bigint, key_len integer, context bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.derive_key(key_id bigint, key_len integer, context bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.derive_key(key_id bigint, key_len integer, context bytea) FROM pgsodium_keymaker;
GRANT ALL ON FUNCTION pgsodium.derive_key(key_id bigint, key_len integer, context bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.derive_key(key_id bigint, key_len integer, context bytea) TO pgsodium_keymaker;


--
-- TOC entry 4042 (class 0 OID 0)
-- Dependencies: 404
-- Name: FUNCTION pgsodium_derive(key_id bigint, key_len integer, context bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.pgsodium_derive(key_id bigint, key_len integer, context bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.pgsodium_derive(key_id bigint, key_len integer, context bytea) FROM pgsodium_keymaker;
GRANT ALL ON FUNCTION pgsodium.pgsodium_derive(key_id bigint, key_len integer, context bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.pgsodium_derive(key_id bigint, key_len integer, context bytea) TO pgsodium_keymaker;


--
-- TOC entry 4043 (class 0 OID 0)
-- Dependencies: 358
-- Name: FUNCTION randombytes_buf(size integer); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.randombytes_buf(size integer) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.randombytes_buf(size integer) FROM pgsodium_keyiduser;
GRANT ALL ON FUNCTION pgsodium.randombytes_buf(size integer) TO postgres;
GRANT ALL ON FUNCTION pgsodium.randombytes_buf(size integer) TO pgsodium_keyiduser;


--
-- TOC entry 4044 (class 0 OID 0)
-- Dependencies: 391
-- Name: FUNCTION randombytes_buf_deterministic(size integer, seed bytea); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.randombytes_buf_deterministic(size integer, seed bytea) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.randombytes_buf_deterministic(size integer, seed bytea) FROM pgsodium_keymaker;
REVOKE ALL ON FUNCTION pgsodium.randombytes_buf_deterministic(size integer, seed bytea) FROM pgsodium_keyiduser;
GRANT ALL ON FUNCTION pgsodium.randombytes_buf_deterministic(size integer, seed bytea) TO postgres;
GRANT ALL ON FUNCTION pgsodium.randombytes_buf_deterministic(size integer, seed bytea) TO pgsodium_keymaker;
GRANT ALL ON FUNCTION pgsodium.randombytes_buf_deterministic(size integer, seed bytea) TO pgsodium_keyiduser;


--
-- TOC entry 4045 (class 0 OID 0)
-- Dependencies: 390
-- Name: FUNCTION randombytes_new_seed(); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.randombytes_new_seed() FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.randombytes_new_seed() FROM pgsodium_keymaker;
GRANT ALL ON FUNCTION pgsodium.randombytes_new_seed() TO postgres;
GRANT ALL ON FUNCTION pgsodium.randombytes_new_seed() TO pgsodium_keymaker;


--
-- TOC entry 4046 (class 0 OID 0)
-- Dependencies: 356
-- Name: FUNCTION randombytes_random(); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.randombytes_random() FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.randombytes_random() FROM pgsodium_keyiduser;
GRANT ALL ON FUNCTION pgsodium.randombytes_random() TO postgres;
GRANT ALL ON FUNCTION pgsodium.randombytes_random() TO pgsodium_keyiduser;


--
-- TOC entry 4047 (class 0 OID 0)
-- Dependencies: 357
-- Name: FUNCTION randombytes_uniform(upper_bound integer); Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON FUNCTION pgsodium.randombytes_uniform(upper_bound integer) FROM supabase_admin;
REVOKE ALL ON FUNCTION pgsodium.randombytes_uniform(upper_bound integer) FROM pgsodium_keyiduser;
GRANT ALL ON FUNCTION pgsodium.randombytes_uniform(upper_bound integer) TO postgres;
GRANT ALL ON FUNCTION pgsodium.randombytes_uniform(upper_bound integer) TO pgsodium_keyiduser;


--
-- TOC entry 4048 (class 0 OID 0)
-- Dependencies: 495
-- Name: FUNCTION check_if_user_exist(in_login text, in_email text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.check_if_user_exist(in_login text, in_email text) TO anon;
GRANT ALL ON FUNCTION public.check_if_user_exist(in_login text, in_email text) TO authenticated;
GRANT ALL ON FUNCTION public.check_if_user_exist(in_login text, in_email text) TO service_role;


--
-- TOC entry 4049 (class 0 OID 0)
-- Dependencies: 343
-- Name: FUNCTION extension(name text); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.extension(name text) TO anon;
GRANT ALL ON FUNCTION storage.extension(name text) TO authenticated;
GRANT ALL ON FUNCTION storage.extension(name text) TO service_role;
GRANT ALL ON FUNCTION storage.extension(name text) TO dashboard_user;
GRANT ALL ON FUNCTION storage.extension(name text) TO postgres;


--
-- TOC entry 4050 (class 0 OID 0)
-- Dependencies: 342
-- Name: FUNCTION filename(name text); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.filename(name text) TO anon;
GRANT ALL ON FUNCTION storage.filename(name text) TO authenticated;
GRANT ALL ON FUNCTION storage.filename(name text) TO service_role;
GRANT ALL ON FUNCTION storage.filename(name text) TO dashboard_user;
GRANT ALL ON FUNCTION storage.filename(name text) TO postgres;


--
-- TOC entry 4051 (class 0 OID 0)
-- Dependencies: 341
-- Name: FUNCTION foldername(name text); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.foldername(name text) TO anon;
GRANT ALL ON FUNCTION storage.foldername(name text) TO authenticated;
GRANT ALL ON FUNCTION storage.foldername(name text) TO service_role;
GRANT ALL ON FUNCTION storage.foldername(name text) TO dashboard_user;
GRANT ALL ON FUNCTION storage.foldername(name text) TO postgres;


--
-- TOC entry 4053 (class 0 OID 0)
-- Dependencies: 239
-- Name: TABLE audit_log_entries; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.audit_log_entries TO dashboard_user;
GRANT ALL ON TABLE auth.audit_log_entries TO postgres;


--
-- TOC entry 4056 (class 0 OID 0)
-- Dependencies: 258
-- Name: TABLE identities; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.identities TO postgres;
GRANT ALL ON TABLE auth.identities TO dashboard_user;


--
-- TOC entry 4058 (class 0 OID 0)
-- Dependencies: 238
-- Name: TABLE instances; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.instances TO dashboard_user;
GRANT ALL ON TABLE auth.instances TO postgres;


--
-- TOC entry 4060 (class 0 OID 0)
-- Dependencies: 262
-- Name: TABLE mfa_amr_claims; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.mfa_amr_claims TO postgres;
GRANT ALL ON TABLE auth.mfa_amr_claims TO dashboard_user;


--
-- TOC entry 4062 (class 0 OID 0)
-- Dependencies: 261
-- Name: TABLE mfa_challenges; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.mfa_challenges TO postgres;
GRANT ALL ON TABLE auth.mfa_challenges TO dashboard_user;


--
-- TOC entry 4064 (class 0 OID 0)
-- Dependencies: 260
-- Name: TABLE mfa_factors; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.mfa_factors TO postgres;
GRANT ALL ON TABLE auth.mfa_factors TO dashboard_user;


--
-- TOC entry 4066 (class 0 OID 0)
-- Dependencies: 237
-- Name: TABLE refresh_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.refresh_tokens TO dashboard_user;
GRANT ALL ON TABLE auth.refresh_tokens TO postgres;


--
-- TOC entry 4068 (class 0 OID 0)
-- Dependencies: 236
-- Name: SEQUENCE refresh_tokens_id_seq; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO dashboard_user;
GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO postgres;


--
-- TOC entry 4070 (class 0 OID 0)
-- Dependencies: 265
-- Name: TABLE saml_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.saml_providers TO postgres;
GRANT ALL ON TABLE auth.saml_providers TO dashboard_user;


--
-- TOC entry 4072 (class 0 OID 0)
-- Dependencies: 266
-- Name: TABLE saml_relay_states; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.saml_relay_states TO postgres;
GRANT ALL ON TABLE auth.saml_relay_states TO dashboard_user;


--
-- TOC entry 4074 (class 0 OID 0)
-- Dependencies: 240
-- Name: TABLE schema_migrations; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.schema_migrations TO dashboard_user;
GRANT ALL ON TABLE auth.schema_migrations TO postgres;


--
-- TOC entry 4077 (class 0 OID 0)
-- Dependencies: 259
-- Name: TABLE sessions; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.sessions TO postgres;
GRANT ALL ON TABLE auth.sessions TO dashboard_user;


--
-- TOC entry 4079 (class 0 OID 0)
-- Dependencies: 264
-- Name: TABLE sso_domains; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.sso_domains TO postgres;
GRANT ALL ON TABLE auth.sso_domains TO dashboard_user;


--
-- TOC entry 4082 (class 0 OID 0)
-- Dependencies: 263
-- Name: TABLE sso_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.sso_providers TO postgres;
GRANT ALL ON TABLE auth.sso_providers TO dashboard_user;


--
-- TOC entry 4085 (class 0 OID 0)
-- Dependencies: 235
-- Name: TABLE users; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.users TO dashboard_user;
GRANT ALL ON TABLE auth.users TO postgres;


--
-- TOC entry 4086 (class 0 OID 0)
-- Dependencies: 234
-- Name: TABLE pg_stat_statements; Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON TABLE extensions.pg_stat_statements TO dashboard_user;


--
-- TOC entry 4087 (class 0 OID 0)
-- Dependencies: 233
-- Name: TABLE pg_stat_statements_info; Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON TABLE extensions.pg_stat_statements_info TO dashboard_user;


--
-- TOC entry 4088 (class 0 OID 0)
-- Dependencies: 244
-- Name: SEQUENCE seq_schema_version; Type: ACL; Schema: graphql; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE graphql.seq_schema_version TO postgres;
GRANT ALL ON SEQUENCE graphql.seq_schema_version TO anon;
GRANT ALL ON SEQUENCE graphql.seq_schema_version TO authenticated;
GRANT ALL ON SEQUENCE graphql.seq_schema_version TO service_role;


--
-- TOC entry 4089 (class 0 OID 0)
-- Dependencies: 257
-- Name: TABLE decrypted_key; Type: ACL; Schema: pgsodium; Owner: postgres
--

GRANT ALL ON TABLE pgsodium.decrypted_key TO pgsodium_keyholder;


--
-- TOC entry 4090 (class 0 OID 0)
-- Dependencies: 251
-- Name: SEQUENCE key_key_id_seq; Type: ACL; Schema: pgsodium; Owner: postgres
--

REVOKE ALL ON SEQUENCE pgsodium.key_key_id_seq FROM supabase_admin;
REVOKE ALL ON SEQUENCE pgsodium.key_key_id_seq FROM pgsodium_keymaker;
GRANT ALL ON SEQUENCE pgsodium.key_key_id_seq TO postgres;
GRANT ALL ON SEQUENCE pgsodium.key_key_id_seq TO pgsodium_keymaker;


--
-- TOC entry 4091 (class 0 OID 0)
-- Dependencies: 255
-- Name: TABLE masking_rule; Type: ACL; Schema: pgsodium; Owner: postgres
--

GRANT ALL ON TABLE pgsodium.masking_rule TO pgsodium_keyholder;


--
-- TOC entry 4092 (class 0 OID 0)
-- Dependencies: 256
-- Name: TABLE mask_columns; Type: ACL; Schema: pgsodium; Owner: postgres
--

GRANT ALL ON TABLE pgsodium.mask_columns TO pgsodium_keyholder;


--
-- TOC entry 4093 (class 0 OID 0)
-- Dependencies: 269
-- Name: TABLE cards; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.cards TO anon;
GRANT ALL ON TABLE public.cards TO authenticated;
GRANT ALL ON TABLE public.cards TO service_role;


--
-- TOC entry 4094 (class 0 OID 0)
-- Dependencies: 270
-- Name: TABLE situations; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.situations TO anon;
GRANT ALL ON TABLE public.situations TO authenticated;
GRANT ALL ON TABLE public.situations TO service_role;


--
-- TOC entry 4095 (class 0 OID 0)
-- Dependencies: 267
-- Name: TABLE users; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.users TO anon;
GRANT ALL ON TABLE public.users TO authenticated;
GRANT ALL ON TABLE public.users TO service_role;


--
-- TOC entry 4096 (class 0 OID 0)
-- Dependencies: 241
-- Name: TABLE buckets; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.buckets TO anon;
GRANT ALL ON TABLE storage.buckets TO authenticated;
GRANT ALL ON TABLE storage.buckets TO service_role;
GRANT ALL ON TABLE storage.buckets TO postgres;


--
-- TOC entry 4097 (class 0 OID 0)
-- Dependencies: 243
-- Name: TABLE migrations; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.migrations TO anon;
GRANT ALL ON TABLE storage.migrations TO authenticated;
GRANT ALL ON TABLE storage.migrations TO service_role;
GRANT ALL ON TABLE storage.migrations TO postgres;


--
-- TOC entry 4098 (class 0 OID 0)
-- Dependencies: 242
-- Name: TABLE objects; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.objects TO anon;
GRANT ALL ON TABLE storage.objects TO authenticated;
GRANT ALL ON TABLE storage.objects TO service_role;
GRANT ALL ON TABLE storage.objects TO postgres;


--
-- TOC entry 2433 (class 826 OID 16596)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES  TO dashboard_user;


--
-- TOC entry 2434 (class 826 OID 16597)
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS  TO dashboard_user;


--
-- TOC entry 2432 (class 826 OID 16595)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES  TO dashboard_user;


--
-- TOC entry 2443 (class 826 OID 16622)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES  TO service_role;


--
-- TOC entry 2442 (class 826 OID 16621)
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS  TO service_role;


--
-- TOC entry 2441 (class 826 OID 16620)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES  TO service_role;


--
-- TOC entry 2438 (class 826 OID 16610)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES  TO service_role;


--
-- TOC entry 2440 (class 826 OID 16609)
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS  TO service_role;


--
-- TOC entry 2439 (class 826 OID 16608)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES  TO service_role;


--
-- TOC entry 2448 (class 826 OID 16837)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: pgsodium; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA pgsodium GRANT ALL ON SEQUENCES  TO pgsodium_keyholder;


--
-- TOC entry 2447 (class 826 OID 16836)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: pgsodium; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA pgsodium GRANT ALL ON TABLES  TO pgsodium_keyholder;


--
-- TOC entry 2445 (class 826 OID 16834)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: pgsodium_masks; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA pgsodium_masks GRANT ALL ON SEQUENCES  TO pgsodium_keyiduser;


--
-- TOC entry 2446 (class 826 OID 16835)
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: pgsodium_masks; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA pgsodium_masks GRANT ALL ON FUNCTIONS  TO pgsodium_keyiduser;


--
-- TOC entry 2444 (class 826 OID 16833)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: pgsodium_masks; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA pgsodium_masks GRANT ALL ON TABLES  TO pgsodium_keyiduser;


--
-- TOC entry 2425 (class 826 OID 16483)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES  TO service_role;


--
-- TOC entry 2426 (class 826 OID 16484)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES  TO service_role;


--
-- TOC entry 2424 (class 826 OID 16482)
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS  TO service_role;


--
-- TOC entry 2428 (class 826 OID 16486)
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS  TO service_role;


--
-- TOC entry 2423 (class 826 OID 16481)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES  TO service_role;


--
-- TOC entry 2427 (class 826 OID 16485)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES  TO service_role;


--
-- TOC entry 2436 (class 826 OID 16600)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES  TO dashboard_user;


--
-- TOC entry 2437 (class 826 OID 16601)
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS  TO dashboard_user;


--
-- TOC entry 2435 (class 826 OID 16599)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES  TO dashboard_user;


--
-- TOC entry 2431 (class 826 OID 16538)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES  TO service_role;


--
-- TOC entry 2430 (class 826 OID 16537)
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS  TO service_role;


--
-- TOC entry 2429 (class 826 OID 16536)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES  TO service_role;


--
-- TOC entry 3562 (class 3466 OID 16614)
-- Name: issue_graphql_placeholder; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_graphql_placeholder ON sql_drop
         WHEN TAG IN ('DROP EXTENSION')
   EXECUTE FUNCTION extensions.set_graphql_placeholder();


ALTER EVENT TRIGGER issue_graphql_placeholder OWNER TO supabase_admin;

--
-- TOC entry 3559 (class 3466 OID 16591)
-- Name: issue_pg_cron_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_cron_access ON ddl_command_end
         WHEN TAG IN ('CREATE SCHEMA')
   EXECUTE FUNCTION extensions.grant_pg_cron_access();


ALTER EVENT TRIGGER issue_pg_cron_access OWNER TO supabase_admin;

--
-- TOC entry 3561 (class 3466 OID 16612)
-- Name: issue_pg_graphql_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_graphql_access ON ddl_command_end
         WHEN TAG IN ('CREATE FUNCTION')
   EXECUTE FUNCTION extensions.grant_pg_graphql_access();


ALTER EVENT TRIGGER issue_pg_graphql_access OWNER TO supabase_admin;

--
-- TOC entry 3560 (class 3466 OID 16593)
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_net_access();


ALTER EVENT TRIGGER issue_pg_net_access OWNER TO supabase_admin;

--
-- TOC entry 3563 (class 3466 OID 16615)
-- Name: pgrst_ddl_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_ddl_watch ON ddl_command_end
   EXECUTE FUNCTION extensions.pgrst_ddl_watch();


ALTER EVENT TRIGGER pgrst_ddl_watch OWNER TO supabase_admin;

--
-- TOC entry 3564 (class 3466 OID 16616)
-- Name: pgrst_drop_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_drop_watch ON sql_drop
   EXECUTE FUNCTION extensions.pgrst_drop_watch();


ALTER EVENT TRIGGER pgrst_drop_watch OWNER TO supabase_admin;

-- Completed on 2023-03-08 15:49:44

--
-- PostgreSQL database dump complete
--

-- Completed on 2023-03-08 15:49:44

--
-- PostgreSQL database cluster dump complete
--

