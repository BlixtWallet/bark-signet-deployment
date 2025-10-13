#!/bin/sh
set -e

export RUST_BACKTRACE=1

# Check if the mnemonic file exists. If not, run the create command.
if [ ! -f "/data/captaind/mnemonic" ]; then
  echo "Creating new config at ${CAPTAIND_CONFIG_PATH}"
  /usr/local/bin/captaind --config "${CAPTAIND_CONFIG_PATH}" create
fi

echo "Booting captaind..."
/usr/local/bin/captaind --config "${CAPTAIND_CONFIG_PATH}" start