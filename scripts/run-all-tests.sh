#!/bin/bash
set -e

WORKDIR="$HOME/opstack-lab"

echo "[*] Running all PoC tests in Hardhat and Foundry..."

# Run Hardhat tests
cd "$WORKDIR/hardhat-poc"
echo "[+] Running Hardhat tests..."
npx hardhat test || { echo "❌ Hardhat tests failed"; exit 1; }

# Run Foundry tests
cd "$WORKDIR/foundry-poc"
echo "[+] Running Foundry tests..."
forge test --fork-url http://localhost:8545 || { echo "❌ Foundry tests failed"; exit 1; }

echo "[✔] All tests completed successfully."
