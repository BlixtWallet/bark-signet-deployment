# Builder stage - get libsqlite3 and hold binary
FROM debian:bookworm-slim AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    libsqlite3-0 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

ARG TARGETARCH
ARG HOLD_VERSION=v0.3.3

RUN curl -sSL "https://github.com/BoltzExchange/hold/releases/download/${HOLD_VERSION}/hold-linux-${TARGETARCH}.tar.gz" | tar -xz && \
    mv build/hold-linux-${TARGETARCH} /usr/local/bin/hold && \
    chmod +x /usr/local/bin/hold

# Final image
FROM docker.io/elementsproject/lightningd:v25.09.1

# Copy libsqlite3 from builder (avoids apt conflicts with lightningd's built-in sqlite)
COPY --from=builder /usr/lib/*-linux-gnu/libsqlite3.so* /usr/lib/

RUN apt-get update && apt-get install -y --no-install-recommends \
    dos2unix \
    openssl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy the hold binary from builder
COPY --from=builder /usr/local/bin/hold /usr/local/bin/hold

COPY cln_start.sh /usr/local/bin/cln_start.sh
RUN chmod +x /usr/local/bin/cln_start.sh && dos2unix /usr/local/bin/cln_start.sh

ENV NETWORK=regtest \
    BITCOIN_RPCCONNECT=bitcoind:18443 \
    BITCOIN_RPCUSER=second \
    BITCOIN_RPCPASSWORD=ark

EXPOSE 9988

ENTRYPOINT ["/usr/local/bin/cln_start.sh"]
