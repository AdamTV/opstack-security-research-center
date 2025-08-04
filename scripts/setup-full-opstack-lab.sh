#!/bin/bash
set -e

### --- VARIABLES ---
WORKDIR="$HOME/opstack-lab"
OP_GETTING_STARTED_REPO="https://github.com/ethereum-optimism/op-getting-started.git"
OPTIMISM_REPO="https://github.com/ethereum-optimism/optimism.git"

### --- INSTALL SYSTEM DEPENDENCIES ---
echo "[*] Installing prerequisites..."
sudo apt update && sudo apt install -y git curl make jq docker.io docker-compose-plugin nodejs npm python3-pip libssl-dev libffi-dev cabal-install libgmp-dev zlib1g-dev

sudo systemctl enable --now docker

mkdir -p "$WORKDIR"
cd "$WORKDIR"

### --- CLONE REPOSITORIES ---
if [ ! -d "op-getting-started" ]; then
  echo "[*] Cloning OP devnet repo..."
  git clone "$OP_GETTING_STARTED_REPO"
fi

if [ ! -d "optimism" ]; then
  echo "[*] Cloning OP stack contracts..."
  git clone "$OPTIMISM_REPO"
fi

### --- SET UP DEVNET ---
cd "$WORKDIR/op-getting-started"
cp -n .env.example .env

echo "[*] Launching OP Stack devnet..."
docker compose up -d
sleep 30

### --- INSTALL HARDHAT + PROJECT SETUP ---
echo "[*] Setting up Hardhat..."
cd "$WORKDIR"
mkdir -p hardhat-poc && cd hardhat-poc
npm init -y
npm install --save-dev hardhat
npx hardhat init --force
npm install --save-dev @nomicfoundation/hardhat-toolbox dotenv

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

### --- INSTALL FOUNDRY ---
echo "[*] Installing Foundry..."
curl -L https://foundry.paradigm.xyz | bash
source ~/.bashrc
foundryup

mkdir -p "$WORKDIR/foundry-poc"
cd "$WORKDIR/foundry-poc"
forge init --force
echo 'rpc_endpoints = { optimism = "http://localhost:8545" }' >> foundry.toml

### --- INSTALL SLITHER ---
echo "[*] Installing Slither..."
pip3 install slither-analyzer

### --- INSTALL ECHIDNA ---
echo "[*] Installing Echidna..."
cd "$WORKDIR"
if [ ! -d echidna ]; then
  git clone https://github.com/crytic/echidna.git
  cd echidna && make && sudo make install
fi

### --- DONE ---
echo
echo "[✔] OP Stack Security Lab Ready"
echo "    - Devnet:      http://localhost:8545"
echo "    - Hardhat:     $WORKDIR/hardhat-poc"
echo "    - Foundry:     $WORKDIR/foundry-poc"
echo "    - Slither:     Global"
echo "    - Echidna:     Global"
