#!/bin/bash
# wait-for-postgres.sh

set -eu

_service_db_url=$(echo $STELLAR_CORE_DATABASE_URL | sed -E 's/dbname=[0-9a-zA-Z_\-]+/dbname=postgres/')

until psql "${_service_db_url#postgresql://}" -c '\q'; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done

>&2 echo "Postgres is up - continuing"
