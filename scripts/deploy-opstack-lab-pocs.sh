#!/bin/bash
set -e

echo "[*] Setting up OP Stack PoC workspace..."

WORKDIR="$HOME/opstack-lab"
ZIPFILE="opstack-lab-pocs.zip"

# Ensure unzip is available
sudo apt install -y unzip

# Copy and unzip if WORKDIR does not exist
if [[ ! -d "$WORKDIR" ]]; then
  mkdir -p "$WORKDIR"
  cp "$ZIPFILE" "$WORKDIR/"
  cd "$WORKDIR"
  unzip -o "$ZIPFILE"
fi


# Setup Hardhat project
cd hardhat-poc
yarn add hardhat @nomicfoundation/hardhat-toolbox dotenv
echo "L2_RPC=http://localhost:8545" > .env

cat <<EOF > hardhat.config.js
require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

module.exports = {
  solidity: "0.8.24",
  networks: {
    optimism: {
      url: process.env.L2_RPC,
      chainId: 420,
      gas: 30000000,
    },
  },
};
EOF

echo "[+] Hardhat PoC environment ready: cd $WORKDIR/hardhat-poc && npx hardhat test"

# Setup Foundry project
cd "$WORKDIR/foundry-poc"
curl -L https://foundry.paradigm.xyz | bash
source ~/.bashrc
foundryup
forge init --force
echo 'rpc_endpoints = { optimism = "http://localhost:8545" }' >> foundry.toml

echo "[+] Foundry PoC environment ready: cd $WORKDIR/foundry-poc && forge test --fork-url http://localhost:8545"
