#!/bin/bash
set -e

echo "🔗 Setting up MCP Servers for Security Research"
echo "=============================================="

# Create MCP directory
mkdir -p ~/opstack-lab/mcp-servers
cd ~/opstack-lab/mcp-servers

echo "📦 Cloning Heurist Mesh MCP Server (Python)..."
if [ ! -d "heurist-mesh-mcp-server" ]; then
    git clone https://github.com/heurist-network/heurist-mesh-mcp-server.git
    cd heurist-mesh-mcp-server
    echo "📝 Setting up Python environment for Heurist..."
    if [ -f "pyproject.toml" ]; then
        # Create virtual environment
        python3 -m venv venv
        source venv/bin/activate
        pip install -e . || echo "⚠️  Heurist setup requires manual configuration"
        deactivate
    fi
    cd ..
else
    echo "✅ Heurist Mesh MCP Server already exists"
fi

echo "📦 Cloning KukaPay MCP Servers..."
if [ ! -d "kukapay-mcp-servers" ]; then
    git clone https://github.com/kukapay/kukapay-mcp-servers.git || echo "⚠️  KukaPay repository may not be accessible"
    if [ -d "kukapay-mcp-servers" ]; then
        cd kukapay-mcp-servers
        echo "📝 Installing KukaPay dependencies..."
        if [ -f "package.json" ]; then
            npm install || echo "⚠️  KukaPay dependencies installation skipped"
        fi
        cd ..
    fi
else
    echo "✅ KukaPay MCP Servers already exists"
fi

echo ""
echo "🔧 Configuring MCP servers for security research..."

# Create MCP configuration for Python-based Heurist
cat > mcp-config.json << 'EOF'
{
  "mcpServers": {
    "heurist-mesh": {
      "command": "python",
      "args": ["-m", "mesh_mcp_server"],
      "cwd": "./heurist-mesh-mcp-server",
      "env": {
        "HEURIST_API_KEY": "${HEURIST_API_KEY}",
        "PYTHONPATH": "./heurist-mesh-mcp-server"
      }
    },
    "kukapay": {
      "command": "node", 
      "args": ["./kukapay-mcp-servers/dist/index.js"],
      "env": {
        "KUKA_API_KEY": "${KUKA_API_KEY}"
      }
    }
  }
}
EOF

# Create environment template
cat > .env.mcp.template << 'EOF'
# Heurist Network API Configuration
HEURIST_API_KEY=your_heurist_api_key_here

# KukaPay API Configuration  
KUKA_API_KEY=your_kuka_api_key_here

# Security Research Configuration
SECURITY_ANALYSIS_ENABLED=true
AUTO_VULNERABILITY_SCAN=false
MCP_DEBUG=true
EOF

echo "✅ MCP servers setup complete!"
echo ""
echo "📋 Next Steps:"
echo "1. Copy .env.mcp.template to .env.mcp and configure API keys"
echo "2. For Heurist: Activate venv and configure API credentials"
echo "3. Use the enhanced dashboard with AI-powered security analysis"
echo ""
echo "🎯 Available MCP Capabilities:"
echo "- AI-powered vulnerability analysis (Heurist - Python)"
echo "- Blockchain payment integration (KukaPay - Node.js)"
echo "- Enhanced security research workflows"

echo ""
echo "🔧 Configuring MCP servers for security research..."

# Create MCP configuration
cat > mcp-config.json << 'EOF'
{
  "mcpServers": {
    "heurist-mesh": {
      "command": "node",
      "args": ["./heurist-mesh-mcp-server/dist/index.js"],
      "env": {
        "HEURIST_API_KEY": "${HEURIST_API_KEY}"
      }
    },
    "kukapay": {
      "command": "node", 
      "args": ["./kukapay-mcp-servers/dist/index.js"],
      "env": {
        "KUKA_API_KEY": "${KUKA_API_KEY}"
      }
    }
  }
}
EOF

# Create environment template
cat > .env.mcp.template << 'EOF'
# Heurist Network API Configuration
HEURIST_API_KEY=your_heurist_api_key_here

# KukaPay API Configuration  
KUKA_API_KEY=your_kuka_api_key_here

# Security Research Configuration
SECURITY_ANALYSIS_ENABLED=true
AUTO_VULNERABILITY_SCAN=false
EOF

echo "✅ MCP servers setup complete!"
echo ""
echo "📋 Next Steps:"
echo "1. Copy .env.mcp.template to .env.mcp and configure API keys"
echo "2. Start MCP servers with: npm run start:mcp"
echo "3. Use the enhanced dashboard with AI-powered security analysis"
echo ""
echo "🎯 Available MCP Capabilities:"
echo "- AI-powered vulnerability analysis (Heurist)"
echo "- Blockchain payment integration (KukaPay)"
echo "- Enhanced security research workflows"
