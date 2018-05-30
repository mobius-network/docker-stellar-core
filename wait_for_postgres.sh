#!/bin/bash
# wait-for-postgres.sh

set -eu

until psql "${STELLAR_CORE_DATABASE_URL#postgresql://}" -c '\q'; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done

>&2 echo "Postgres is up - continuing"
