# Deploy Bark ASP, Client, Bitcoin Core and Core Lightning on Signet

## Prerequisites

- Docker
- Docker Compose

## Getting Started

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/BlixtWallet/bark-signet-deployment
    cd bark-signet-deployment
    ```

2.  **Create a `.env` file:**
    Copy the `.env.template` file to a new file named `.env`.
    ```bash
    cp .env.template .env
    ```

3.  **Set your RPC credentials:**
    Open the `.env` file and set your desired `BITCOIN_RPCUSER` and `BITCOIN_RPCPASSWORD`.

4.  **Start the services:**
    ```bash
    docker-compose up -d
    ```

## Services

-   **`bitcoind`**: The Bitcoin Core node running on `signet`.
-   **`cln`**: The Core Lightning node connected to the `bitcoind` node.
-   **`aspd`**: The aspd service.
-   **`bark`**: The bark service.

## Connecting to the nodes

-   **Bitcoin CLI:**
    ```bash
    docker-compose exec bitcoind bitcoin-cli -signet getblockchaininfo
    ```

-   **Lightning CLI:**
    ```bash
    docker-compose exec cln lightning-cli --network signet getinfo