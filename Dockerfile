FROM debian:stretch-slim

LABEL maintainer="Evil Martians <admin@evilmartians.com>"

ARG STELLAR_VERSION="9.2.0-9"

# hack to make postgresql-client install work on slim
RUN mkdir -p /usr/share/man/man1 \
    && mkdir -p /usr/share/man/man7

# prerequisites for stellar-core
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get -y dist-upgrade \
    && DEBIAN_FRONTEND=noninteractive apt-get -y install curl gnupg2 apt-transport-https man-db \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Stellar core installation
RUN curl -q https://apt.stellar.org/SDF.asc | apt-key add - \
    && echo "deb https://apt.stellar.org/public stable/" | tee -a /etc/apt/sources.list.d/SDF.list \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get -y install stellar-core=$STELLAR_VERSION \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Additional packages
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get -y install postgresql-client s3cmd python-pip \
    && pip install "pyasn1>=0.4.3" \
    && pip install gsutil \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


ADD init_db.sh /usr/local/bin/stellar_init_db.sh
ADD init_cache.sh /usr/local/bin/stellar_init_cache.sh
ADD entrypoint.sh /entrypoint.sh
ADD wait_for_postgres.sh /usr/local/bin/wait_for_postgres.sh

# USER stellar

EXPOSE 11625
EXPOSE 11626

WORKDIR /var/lib/stellar

ENTRYPOINT [ "/entrypoint.sh" ]
