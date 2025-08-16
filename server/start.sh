#!/bin/sh
set -e

export RUST_BACKTRACE=1

# Check if the mnemonic file exists. If not, run the create command.
if [ ! -f "/data/aspd/mnemonic" ]; then
  echo "Creating new config at ${ASPD_CONFIG_PATH}"
  /usr/local/bin/aspd --config "${ASPD_CONFIG_PATH}" create
fi

echo "Booting aspd..."
/usr/local/bin/aspd --config "${ASPD_CONFIG_PATH}" start