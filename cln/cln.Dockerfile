# Use the official Core Lightning image as the base
FROM elementsproject/lightningd:v25.02.2 AS base

# Install necessary runtime dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    dos2unix \
    openssl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# --- Builder stage ---
FROM base AS builder
ARG TARGETARCH
ARG HOLD_VERSION=v0.2.2
RUN curl -sSL "https://github.com/BoltzExchange/hold/releases/download/${HOLD_VERSION}/hold-linux-${TARGETARCH}.tar.gz" | tar -xz
RUN mv build/hold-linux-${TARGETARCH} /usr/local/bin/hold

# --- Final image ---
FROM base

# Copy the hold binary from the builder stage
COPY --from=builder /usr/local/bin/hold /usr/local/bin/hold
RUN chmod +x /usr/local/bin/hold

# Copy the start script
COPY cln_start.sh /usr/local/bin/cln_start.sh
RUN chmod +x /usr/local/bin/cln_start.sh && dos2unix /usr/local/bin/cln_start.sh

# Set environment variables
ENV NETWORK=regtest \
    BITCOIN_RPCCONNECT=bitcoind:18443 \
    BITCOIN_RPCUSER=second \
    BITCOIN_RPCPASSWORD=ark

EXPOSE 9988

ENTRYPOINT /usr/local/bin/cln_start.sh