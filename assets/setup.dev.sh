#!/bin/sh

docker-compose down 2> /dev/null

docker-compose build --force-rm --no-cache db
docker-compose up -d db

# check if there is a backup passed as parameter
if [ -d "$1" ] && [ -f "$1/dump.sql" ] && [ -f "$1/thumbs.tgz" ]; then
	echo "restoring from backup"
	cat "$1/dump.sql" | docker exec -i rulzurlibrary_db psql -d rulzurlibrary
	cat "$1/thumbs.tgz" |  tar --transform='s|var/lib/rulzurlibrary|api/assets|' -xzf -
else
	cat api/assets/sql/init.sql | docker exec -i rulzurlibrary_db psql -U rulzurlibrary
fi
