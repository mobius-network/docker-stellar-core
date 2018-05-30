#!/bin/bash

set -ue

if psql "${STELLAR_CORE_DATABASE_URL#postgresql://}" -c "\dt" | grep -q "No relations" ; then
  echo -n "Database is not initialized. Initializing... "
	stellar-core --newdb --conf /etc/stellar/stellar-core.cfg && echo "done!"
  
  exit $?
fi

echo "Database was already initialized. Skipping."
