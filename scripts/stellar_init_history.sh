#!/bin/bash

set -ue

if [ -z ${STELLAR_CORE_HISTORY_ARCHIVES+x} ]
then
  echo "STELLAR_CORE_HISTORY_ARCHIVES variable is missing. Define it."
  exit 1
else
  IFS=';' read -ra _archives <<< ${STELLAR_CORE_HISTORY_ARCHIVES}
  for _archive in ${_archives[@]}
  do
    _init_cache=false
    _name=$(echo $_archive | cut -f 1 -d ',')
    _type=$(echo $_archive | cut -f 2 -d ',')
    _path=$(echo $_archive | cut -f 3 -d ',')

    case $_type in
    gcloud)
      echo "Stellar core cache will be stored on GCloud Storage."
      if ! gsutil -q stat ${_path%/}/.well-known/stellar-history.json
      then
        _init_cache=true
      fi
      ;;
    local)
      echo "Stellar core cache will be sored locally."

      if [ ! -e ${_path%/}/.well-known/stellar-history.json ]
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
      stellar-core new-hist $_name --conf /etc/stellar/stellar-core.cfg
    else
      echo "Skipping Stellar core cache creation."
    fi
  done
fi


