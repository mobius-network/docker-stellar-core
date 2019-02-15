FROM debian:stretch-slim

LABEL maintainer="Mobius Operations Team <ops@mobius.network>"

ARG STELLAR_VERSION="10.2.0-19"
ARG DEBIAN_FRONTEND=noninteractive

# hack to make postgresql-client install work on slim
RUN mkdir -p /usr/share/man/man1 \
    && mkdir -p /usr/share/man/man7

# prerequisites for stellar-core & some usefull tools
RUN apt-get update \
    && apt-get -y install curl gnupg1 apt-transport-https \
    && curl -s https://apt.stellar.org/SDF.asc | apt-key add - \
    && echo "deb https://apt.stellar.org/public stable/" > /etc/apt/sources.list.d/SDF.list \
    && apt-get purge -y --auto-remove gnupg1 \
    && rm -rf /var/lib/apt/lists/*

# Stellar core installation
RUN apt-get update \
    && apt-get -y install stellar-core=$STELLAR_VERSION jq postgresql-client python-pip \
    && pip install "pyasn1>=0.4.3" \
    && pip install gsutil \
    && pip install awscli \
    && apt-get remove --purge --auto-remove -y apt-transport-https ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && rm /etc/apt/sources.list.d/SDF.list

ADD scripts/stellar_init_db.sh /usr/local/bin/
ADD scripts/stellar_init_history.sh /usr/local/bin/
ADD scripts/wait_for_postgres.sh /usr/local/bin/wait_for_postgres.sh
ADD scripts/entrypoint.sh /entrypoint.sh

USER stellar

EXPOSE 11625
EXPOSE 11626

WORKDIR /var/lib/stellar

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "run", "--conf", "/etc/stellar/stellar-core.cfg" ]
