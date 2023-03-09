# Supabase project configuration

## Set up data in table ans storage

To set up data in table and storage in Supabase project yon can use [auto_scripts](../auto_scripts/README.md).

## Primary tables (created for the business logic of app)

### **users**
    CREATE TABLE public.users (
        id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
        login text,
        email text,
        "createdAt" timestamp with time zone DEFAULT now(),
        "imageUrl" text,
        color text,
        "backgroundColor" text
    );

### **cards**
    CREATE TABLE public.cards (
        id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
        "createdAt" timestamp with time zone DEFAULT now(),
        "createdBy" text,
        "imageUrl" text,
        "isPrivate" boolean DEFAULT false
    
### **situations**
    CREATE TABLE public.situations (
        id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
        "createdAt" timestamp with time zone DEFAULT now(),
        "createdBy" text,
        description text
    );

## Authentication
### Authentication > Settings > General settings:
- Switch on: User Signups

### Authentication > Settings > Auth Providers:
- Switch on: Email

## Storage
- Create bucket: meme-card-game

### Policy

Look at policies for tables and storage in meme_card_game.sql (it's a dump).

## SQL Editor 

### Functions (as backend api)

#### **check_if_user_exist code**
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
