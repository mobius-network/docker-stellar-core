# Stellar Core Docker Image

This repository is used to build a [Docker image](https://quay.io/repository/evilmartians/docker-stellar-core?tab=info) containing Stellar Core package with some tools to bootstrap Stellar Core installation and manage remote history uploading.

Currently, only `gsutil` (Google Cloud Storage) is supported as a remote backend. awscli & AWS S3 implementation is planned for the future release. There is an option to store history locally for test purposes.

There is **no** `confd` or other template or configuration engines included as it is intended to be used in a Helm Chart which has its own templating capabilities.

## How to get

```shell
docker pull mobiusnetwork/stellar-core:10.2.0-19
```

## How to use

### STELLAR_CORE_HISTORY_ARCHIVES variable

This variable is used to initialize archives for Stellar Core.

Format: `name1,gcloud,gs://core-testnet-history-cache/;name2,local,/tmp/archive/name2`

Since Stellar Core requires archive initialization and does not provide any idempotent tools to achive that this image has a script which solves the problem for us. This script relies on this variable.

### STELLAR_CORE_DATABASE_URL variable

This variable is used to initialize Stellar Core DB. The problem is entirely the same as above: there are no idempotent tools for DB initialization inside Stellar Core.

Format `postgresql://dbname=stellarcore host=postgres user=postgres password=password` (Exactly the same, as in config file)

### Stellar Core config file

Provide this image with `/etc/stellar/stellar-core.cfg` file. The default [example](https://github.com/mobius-network/docker-stellar-core/blob/master/stellar-core-testnet-example.cfg).

### gsutil configuration

If you use `gsutil` and Google Cloud Storage for archive, you have to provide `/etc/boto.cfg` and service account file you mentioned inside `/etc/boot.cfg` (`/etc/gcloud-service-account.json` for [boto-example.cfg](https://github.com/mobius-network/docker-stellar-core/blob/master/boto-example.cfg))

### Data directory

Stellar core stores its state to `/var/lib/stellar` by default. You may want to mount a persistent volume to that directory.

### Example

See included `docker-compose-example.yml` for clues how to hack it.
