y#!/bin/bash
set -e

# === BASE CONFIG ===
WORKDIR="$HOME/opstack-lab"
NODE_REPO="https://github.com/smartcontracts/simple-optimism-node.git"

echo "[*] Installing system packages..."
sudo apt update
sudo apt install -y git curl make jq docker.io docker-compose-plugin nodejs npm python3-pip libssl-dev libffi-dev cabal-install libgmp-dev zlib1g-dev

sudo systemctl enable --now docker

mkdir -p "$WORKDIR"
cd "$WORKDIR"

# === OP STACK DEVNET ===
echo "[*] Cloning OP Stack devnet repo..."
git clone "$NODE_REPO"
cd simple-optimism-node
cp -n .env.example .env
docker compose up -d --build

echo "[*] Waiting 30s for services to initialize..."
sleep 30

# === HARDHAT SETUP ===
echo "[*] Installing Hardhat..."
cd "$WORKDIR"
mkdir -p hardhat-poc && cd hardhat-poc
npm init -y
npm install --save-dev hardhat @nomicfoundation/hardhat-toolbox dotenv

npx hardhat init --force

cat <<EOF > .env
L2_RPC=http://localhost:8545
EOF

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

# === FOUNDRY INSTALL ===
echo "[*] Installing Foundry..."
curl -L https://foundry.paradigm.xyz | bash
source ~/.bashrc
foundryup

mkdir -p "$WORKDIR/foundry-poc"
cd "$WORKDIR/foundry-poc"
forge init --force
echo 'rpc_endpoints = { optimism = "http://localhost:8545" }' >> foundry.toml

# === SLITHER ===
echo "[*] Installing Slither..."
pip3 install slither-analyzer

# === ECHIDNA ===
echo "[*] Installing Echidna..."
cd "$WORKDIR"
git clone https://github.com/crytic/echidna.git
cd echidna
make && sudo make install

echo
echo "[✔] Lab setup complete."
echo "    - RPC:        http://localhost:8545"
echo "    - Hardhat:    $WORKDIR/hardhat-poc"
echo "    - Foundry:    $WORKDIR/foundry-poc"
echo "    - Slither:    CLI available"
echo "    - Echidna:    CLI available"
