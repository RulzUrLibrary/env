#!/bin/sh
set -ex

backup="./backup/site/$(date +%F_%H-%M-%S)"
thumbs="./api/assets/thumbs"

mkdir -p "$backup"
docker exec -i rulzurlibrary_db pg_dump -U rulzurlibrary > "$backup/dump.sql"
tar --transform='s|api/assets|var/lib/rulzurlibrary|' -czf - "$thumbs" > "$backup/thumbs.tgz"

ln -snf "$(basename $backup)" "$(dirname $backup)/latest"
