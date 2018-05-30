#!/bin/bash

set -ue

/usr/local/bin/wait_for_postgres.sh
/usr/local/bin/stellar_init_db.sh
/usr/local/bin/stellar_init_cache.sh

exec /usr/bin/stellar-core $@
