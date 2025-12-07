FROM docker.io/elementsproject/lightningd:v25.09.1

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    clang \
    curl \
    dos2unix \
    git \
    libpq-dev \
    libsqlite3-dev \
    openssl \
    protobuf-compiler \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV RUSTUP_TOOLCHAIN_VERSION=1.91.1 \
    PATH=/root/.cargo/bin:${PATH}

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain none && \
    rustup toolchain install ${RUSTUP_TOOLCHAIN_VERSION}

ARG HOLD_VERSION=v0.3.3

RUN git clone https://github.com/BoltzExchange/hold.git /hold && \
    cd /hold && \
    git checkout ${HOLD_VERSION} && \
    cargo build --release && \
    cp /hold/target/release/hold /usr/local/bin/hold && \
    chmod +x /usr/local/bin/hold && \
    rm -rf /hold /root/.cargo /root/.rustup

COPY cln_start.sh /usr/local/bin/cln_start.sh
RUN chmod +x /usr/local/bin/cln_start.sh && dos2unix /usr/local/bin/cln_start.sh

ENV NETWORK=regtest \
    BITCOIN_RPCCONNECT=bitcoind:18443 \
    BITCOIN_RPCUSER=second \
    BITCOIN_RPCPASSWORD=ark

EXPOSE 9988

ENTRYPOINT ["/usr/local/bin/cln_start.sh"]
