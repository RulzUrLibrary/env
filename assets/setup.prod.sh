#!/bin/sh

password=$(date | md5sum | head -c 32) # generate random password
alias compose='docker-compose -f docker-compose.yml -f docker-compose.prod.yml'

compose down 2> /dev/null
compose build --force-rm --no-cache db
compose up -d db

cat <<- EOF | docker exec -i rulzurlibrary_db psql -U rulzurlibrary
ALTER USER "rulzurlibrary" WITH PASSWORD '$password';
EOF

cat api/assets/sql/init.sql | docker exec -i rulzurlibrary_db psql -U rulzurlibrary

cat > "assets/api.prod.toml" <<- EOF
	debug = true
	dev = false
	host = "0.0.0.0"
	port = 8888
	url = ""

	[database]
	name = "rulzurlibrary"
	user = "rulzurlibrary"
	host = "rulzurlibrary_db"
	port = 5432
	password = "${password}"
EOF

compose build --force-rm --no-cache api
compose up -d api
