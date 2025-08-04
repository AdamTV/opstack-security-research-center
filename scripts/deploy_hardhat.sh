#!/bin/bash
set -e

echo "🚀 Starting Hardhat Contract Deployment"
echo "======================================="

cd ~/opstack-lab/hardhat-poc

# Check if node_modules exists
if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies..."
    npm install || yarn install
fi

echo "🔍 Checking for available blockchain networks..."

# Test if L2 RPC is available
if curl -s http://localhost:9991 -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":1}' > /dev/null 2>&1; then
    echo "✅ L2 RPC found on port 9991 - using OP Stack node"
    NETWORK="localhost"
    RPC_URL="http://localhost:9991"
elif curl -s http://localhost:8545 -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":1}' > /dev/null 2>&1; then
    echo "✅ RPC found on port 8545 - using local node"
    NETWORK="localhost"
    RPC_URL="http://localhost:8545"
    # Update config for port 8545
    sed -i 's/localhost:9991/localhost:8545/' hardhat.config.js
else
    echo "⚠️  No blockchain node detected - starting Hardhat local node"
    echo "🚀 This will deploy to a temporary test network"
    
    # Start Hardhat node in background
    npx hardhat node > /tmp/hardhat-node.log 2>&1 &
    HARDHAT_PID=$!
    echo "� Hardhat node PID: $HARDHAT_PID"
    
    # Wait for node to start
    echo "⏳ Waiting for Hardhat node to start..."
    sleep 5
    
    # Update config for local hardhat node
    sed -i 's/localhost:9991/localhost:8545/' hardhat.config.js
    sed -i 's/chainId: 901/chainId: 31337/' hardhat.config.js
    
    NETWORK="localhost"
    RPC_URL="http://localhost:8545"
    
    # Set cleanup trap
    trap "kill $HARDHAT_PID 2>/dev/null || true" EXIT
fi

echo "🔧 Network: $NETWORK"
echo "📡 RPC: $RPC_URL"

# Deploy contracts
echo "🎯 Deploying contracts..."
npx hardhat run scripts/deploy.js --network $NETWORK

echo ""
echo "✅ Deployment complete!"
echo "🧪 Contracts are ready for security testing"
echo "📋 Network used: $NETWORK ($RPC_URL)"
