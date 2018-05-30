#!/bin/bash

set -ue

_init_cache=false

case $STELLAR_CORE_HISTORY_CACHE_TYPE in
gcloud)
  echo "Stellar core cache will be stored on GCloud Storage."
  if ! gsutil -q stat ${STELLAR_CORE_HISTORY_CACHE_PATH%/}/.well-known/stellar-history.json
  then
    _init_cache=true
  fi
  ;;
local)
  echo "Stellar core cache will be sored locally."

  if [ ! -e ${STELLAR_CORE_HISTORY_CACHE_PATH%/}/.well-known/stellar-history.json ]
  then
    _init_cache=true
  fi
  ;;
*)
  echo "Unknown storage type for Stellar Core"
  ;;
esac

# Stellar core checks history archive cache before initializing one.
if [ "X$_init_cache" == "Xtrue" ]
then
  stellar-core --newhist cache --conf /etc/stellar/stellar-core.cfg
else
  echo "Skipping Stellar core cache creation."
fi
