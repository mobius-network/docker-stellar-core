FROM debian:stretch-slim

LABEL maintainer="Mobius Operations Team <ops@mobius.network>"

ARG STELLAR_VERSION="10.0.0rc2-16"

# hack to make postgresql-client install work on slim
RUN mkdir -p /usr/share/man/man1 \
    && mkdir -p /usr/share/man/man7

# prerequisites for stellar-core & some usefull tools
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get -y dist-upgrade \
    && DEBIAN_FRONTEND=noninteractive apt-get -y install curl gnupg2 apt-transport-https man-db procps net-tools\
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Stellar core installation
RUN curl -q https://apt.stellar.org/SDF.asc | apt-key add - \
    && echo "deb https://apt.stellar.org/public unstable/" | tee -a /etc/apt/sources.list.d/SDF.list \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get -y install stellar-core=$STELLAR_VERSION \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Additional packages
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get -y install postgresql-client python-pip \
    && pip install "pyasn1>=0.4.3" \
    && pip install gsutil \
    && pip install awscli \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


ADD scripts/stellar_init_db.sh /usr/local/bin/
ADD scripts/stellar_init_history.sh /usr/local/bin/
ADD scripts/wait_for_postgres.sh /usr/local/bin/wait_for_postgres.sh
ADD scripts/entrypoint.sh /entrypoint.sh

USER stellar

EXPOSE 11625
EXPOSE 11626

WORKDIR /var/lib/stellar

ENTRYPOINT [ "/entrypoint.sh" ]
