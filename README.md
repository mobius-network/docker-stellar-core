# Stellar Core Docker Image

This repository is used to build a [Docker image](https://quay.io/repository/evilmartians/docker-stellar-core?tab=info) containing Stellar Core package with some tools to bootstrap Stellar Core installation and manage remote history uploading.

Currently, only `gsutil` and Google Cloud Storage are supported as a remote backend. s3cmd & AWS S3 implementation is planned for the future release. There is an option to store history locally for test purposes.

This image does not support a multiple Stellar Core history backend yet. It's a big downside, sorry.

There is **no** `confd` or other template or configuration engines included as it is intended to be used in a Helm Chart which has its own templating capabilities.

## Example

See included `docker-compose-example.yml` for clues how to hack it.
