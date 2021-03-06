#!/bin/sh
set -e

db="rulzurlibrary"
user="rulzurlibrary"
password="some_password"

pg_ctl initdb 2> /dev/null
pg_ctl start -w
psql -d template1 -v ON_ERROR_STOP=1 <<- EOSQL
	CREATE EXTENSION IF NOT EXISTS pgcrypto;
	CREATE USER ${user} PASSWORD '${password}';
	CREATE DATABASE ${db};
	GRANT ALL PRIVILEGES ON DATABASE ${db} TO ${user};
EOSQL
pg_ctl stop -w

cat > "${PGDATA}/pg_hba.conf" <<- EOF
	local	all             all                                     trust
	host    all             all             0.0.0.0/0               md5
EOF
