# Auto scripts

This small command-line application need to set up based data and files in Supabase.

## Description
There are scripts:
- add_situations_script.dart - uploads situations descriptions from file to table.
- upload_cards_script.dart - uploads card images and link on storage to table.

## How to run

### 1. Add supabase credential to env
- Create ".env.development.yaml" in root of this directory (near the ".env.example.yaml")
- Add credential from supabase there

### 2. Run script

Scripts includes in ./bin/auto_scripts.dart

To run script you have to run in console the following command:

    dart run

Scripts will upload to your supabase project situations and images.