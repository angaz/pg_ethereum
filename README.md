# PG Ethereum

A PostgreSQL extension with datatypes and functions useful for working with
Ethereum data in Postgres.

## Compiling

This project uses Nix Flakes for package management. Import the flake into your
configuration and add the extension to your Postgres deployment.

## Testing

Postgres and the extension are installed into the devshell as part of the Flake.

You first need to run `initdb test` to initialize the Postgres data directory.

Then you can run the database with `postgres -D test/`.

A `test.sql` is provided for testing the extension, and provides examples on how
to use the datatypes and functions. Run it with `psql postgres -f test.sql`.
Postgres needs to be running as shown in the previous steps.
