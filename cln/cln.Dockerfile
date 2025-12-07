FROM docker.io/elementsproject/lightningd:v25.09.1

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    dos2unix \
    libsqlite3-dev \
    openssl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

ARG TARGETARCH
ARG HOLD_VERSION=v0.3.3

RUN curl -sSL "https://github.com/BoltzExchange/hold/releases/download/${HOLD_VERSION}/hold-linux-${TARGETARCH}.tar.gz" | tar -xz && \
    mv build/hold-linux-${TARGETARCH} /usr/local/bin/hold && \
    chmod +x /usr/local/bin/hold && \
    rm -rf build

COPY cln_start.sh /usr/local/bin/cln_start.sh
RUN chmod +x /usr/local/bin/cln_start.sh && dos2unix /usr/local/bin/cln_start.sh

ENV NETWORK=regtest \
    BITCOIN_RPCCONNECT=bitcoind:18443 \
    BITCOIN_RPCUSER=second \
    BITCOIN_RPCPASSWORD=ark

EXPOSE 9988

ENTRYPOINT ["/usr/local/bin/cln_start.sh"]
