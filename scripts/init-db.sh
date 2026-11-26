#!/bin/sh
set -eu
# A fresh local database has a privileged migration owner and a restricted runtime role.
# Flyway grants only the runtime permissions required by the application.
psql --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" --set ON_ERROR_STOP=1 \
  --set app_password="$APP_DB_PASSWORD" <<'SQL'
SELECT format('CREATE ROLE tpp_app LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOREPLICATION PASSWORD %L', :'app_password') \gexec
REVOKE CREATE ON SCHEMA public FROM PUBLIC;
SQL
