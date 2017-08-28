#!/bin/sh

password=$(date | md5sum | head -c 32) # generate random password
alias compose='docker-compose -f docker-compose.yml -f docker-compose.prod.yml'

compose down 2> /dev/null

compose build --force-rm --no-cache db
compose up -d db

cat <<- EOF | docker exec -i rulzurlibrary_db psql -U rulzurlibrary
ALTER USER "rulzurlibrary" WITH PASSWORD '$password';
EOF


cat > "assets/api.prod.toml" <<- EOF
	debug = true
	dev = false
	host = "0.0.0.0"
	port = 8888
	url = "rulz.xyz"

	[database]
	name = "rulzurlibrary"
	user = "rulzurlibrary"
	host = "rulzurlibrary_db"
	port = 5432
	password = "${password}"
EOF

compose build --force-rm --no-cache api
compose build --force-rm --no-cache captcha
compose up -d api
compose up -d captcha

# check if there is a backup passed as parameter
if [ -d "$1" ] && [ -f "$1/dump.sql" ] && [ -f "$1/thumbs.tgz" ]; then
	echo "restoring from backup"
	cat "$1/dump.sql" | docker exec -i rulzurlibrary_db psql -d rulzurlibrary
	cat "$1/thumbs.tgz" | docker exec -i rulzurlibrary_api tar -xzf -
else
	cat api/assets/sql/init.sql | docker exec -i rulzurlibrary_db psql -U rulzurlibrary
fi

docker rmi $(docker images | awk '$1 ~ /\<none\>/ {print $3}')
docker volume rm $(docker volume ls -qf dangling=true)
