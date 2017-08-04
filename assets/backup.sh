#!/bin/sh
set -ex

backup="$HOME/backup/$(date +%F_%H-%M-%S)"
thumbs="/var/lib/rulzurlibrary/thumbs"

mkdir -p "$backup"
docker exec -ti rulzurlibrary_db pg_dump -U rulzurlibrary > "$backup/dump.sql"
docker exec -i rulzurlibrary_api tar -czf - "$thumbs" > "$backup/thumbs.tgz"

ln -snf "$(basename $backup)" "$(dirname $backup)/latest"
