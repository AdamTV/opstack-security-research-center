# 🔐 OP Stack Security Research Lab

A comprehensive security testing and analysis platform for OP Stack (Optimism) blockchain infrastructure. This project provides automated vulnerability detection, exploit testing, and AI-powered security analysis tools specifically designed for Layer 2 security research.

![OP Stack Security Research Center](https://img.shields.io/badge/Security-Research-red) ![Python](https://img.shields.io/badge/Python-3.8+-blue) ![Solidity](https://img.shields.io/badge/Solidity-0.8+-green) ![License](https://img.shields.io/badge/License-MIT-yellow)

## 🎯 Features

### **Core Security Tools**
- **🛡️ Slither Integration** - Advanced static analysis for smart contracts
- **🎯 Exploit Testing** - Automated PoC generation and testing framework
- **🔍 Vulnerability Scanning** - Multi-layered security assessment
- **📊 Bytecode Analysis** - Low-level contract inspection
- **⚡ Real-time Monitoring** - Live network and system metrics

### **AI-Powered Analysis**
- **🤖 Heurist Mesh Integration** - AI-driven vulnerability detection
- **💰 KukaPay Analysis** - Blockchain payment security assessment
- **🧠 Smart Pattern Recognition** - Advanced threat detection
- **📈 Confidence Scoring** - AI-generated security ratings

### **Web Dashboard**
- **🎨 Modern Interface** - Professional security researcher UI
- **📱 Responsive Design** - Works on desktop and mobile
- **⚡ Real-time Updates** - Live terminal output and metrics
- **🔗 Service Integration** - BlockScout, Grafana, Prometheus

## 🚀 Quick Start

### Prerequisites
- Python 3.8+
- Node.js 16+
- Docker & Docker Compose
- Git

### Installation

```bash
# Clone the repository
git clone <your-repo-url>
cd opstack-lab

# Set up the environment
chmod +x scripts/setup-opstack-security-lab.sh
./scripts/setup-opstack-security-lab.sh

# Install Python dependencies
python3 -m venv .venv
source .venv/bin/activate
pip install flask slither-analyzer

# Install Node.js dependencies for Hardhat
cd hardhat-poc
npm install
cd ..

# Start the dashboard
python app.py
```

### Access the Dashboard
Open your browser to `http://localhost:5000` to access the Security Research Center.

## 📁 Project Structure

```
opstack-lab/
├── app.py                          # Flask web application
├── templates/
│   └── index.html                  # Security dashboard UI
├── scripts/                        # Automation scripts
│   ├── run_slither.sh             # Slither analysis
│   ├── deploy_hardhat.sh          # Contract deployment
│   ├── setup-mcp-servers.sh       # MCP integration
│   └── run-all-tests.sh           # Test automation
├── hardhat-poc/                    # Hardhat testing environment
│   ├── contracts/
│   │   ├── Vulnerable.sol         # Test vulnerable contract
│   │   └── Exploit.sol            # Exploit contract
│   └── scripts/deploy.js          # Deployment script
├── foundry-poc/                    # Foundry testing environment
│   ├── src/L2ReplayPoC.sol        # L2 replay attack PoC
│   └── test/L2Replay.t.sol        # Security tests
├── security-reports/               # Generated security reports
├── mcp-servers/                    # MCP server configurations
└── infra/                         # Infrastructure code
```

## 🛠️ Usage Guide

### **1. Deploy Test Contracts**
```bash
# Deploy vulnerable contracts for testing
curl -X GET http://localhost:5000/deploy/hardhat
```

### **2. Run Security Analysis**
```bash
# Comprehensive Slither analysis
curl -X GET http://localhost:5000/run/slither

# Specific vulnerability scans
curl -X GET http://localhost:5000/scan/reentrancy
curl -X GET http://localhost:5000/scan/access-control
```

### **3. AI-Powered Analysis**
```bash
# Heurist AI analysis
curl -X POST http://localhost:5000/mcp/heurist/analyze \
  -H "Content-Type: application/json" \
  -d '{"code": "your_contract_code_here"}'
```

### **4. Test Exploits**
```bash
# Run exploit scenarios
curl -X GET http://localhost:5000/exploit/test
```

## 🔧 Configuration

### **Environment Variables**
Create `.env` files for different components:

```bash
# .env.mcp (MCP Servers)
HEURIST_API_KEY=your_heurist_api_key
KUKA_API_KEY=your_kuka_api_key
SECURITY_ANALYSIS_ENABLED=true
```

### **Network Configuration**
Update `hardhat-poc/hardhat.config.js` for different networks:

```javascript
networks: {
  localhost: {
    url: "http://localhost:8545",
    chainId: 31337
  },
  optimism: {
    url: process.env.L2_RPC,
    chainId: 10
  }
}
```

## 🧪 Testing Framework

### **Foundry Tests**
```bash
cd foundry-poc
forge test -vv
```

### **Hardhat Tests**
```bash
cd hardhat-poc
npx hardhat test
```

### **Security Test Suite**
```bash
./scripts/run-all-tests.sh
```

## 📊 Security Reports

The platform generates detailed security reports in multiple formats:

- **JSON Reports** - Machine-readable vulnerability data
- **Text Reports** - Human-readable analysis summaries
- **Real-time Dashboard** - Live security metrics and alerts

Reports are saved in `security-reports/` with timestamps for tracking.

## 🤝 Contributing

1. **Fork the repository**
2. **Create a feature branch** (`git checkout -b feature/amazing-feature`)
3. **Commit your changes** (`git commit -m 'Add amazing feature'`)
4. **Push to the branch** (`git push origin feature/amazing-feature`)
5. **Open a Pull Request**

### **Development Guidelines**
- Follow Python PEP 8 style guide
- Add tests for new security features
- Update documentation for new tools
- Ensure all security tests pass

## 🔒 Security Considerations

⚠️ **Important**: This tool is designed for security research and testing purposes only.

- **Use only on test networks** or isolated environments
- **Never run on mainnet** with real funds
- **Vulnerable contracts** included are for educational purposes
- **MCP servers** may require API keys - keep them secure

## 📚 Documentation

- [**Dashboard Guide**](DASHBOARD_GUIDE.md) - Comprehensive UI documentation
- [**Security Testing**](docs/security-testing.md) - Testing methodologies
- [**MCP Integration**](docs/mcp-integration.md) - AI analysis setup
- [**Exploit Development**](docs/exploit-dev.md) - PoC creation guide

## 🏗️ Architecture

The platform consists of:

1. **Flask Backend** - API endpoints and automation
2. **React-like Frontend** - Modern security dashboard
3. **Slither Integration** - Static analysis engine
4. **MCP Servers** - AI-powered analysis
5. **Testing Frameworks** - Hardhat & Foundry
6. **Docker Infrastructure** - Containerized services

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Optimism Team** - For the OP Stack architecture
- **Trail of Bits** - For Slither static analysis
- **Heurist Network** - For AI-powered security analysis
- **Foundry Team** - For the testing framework
- **Security Research Community** - For continuous improvements

## 📞 Support

- **Issues**: Open a GitHub issue
- **Discussions**: Use GitHub Discussions
- **Security Reports**: Email security@yourproject.com

---

**⚠️ Disclaimer**: This tool is for educational and research purposes only. Users are responsible for ensuring compliance with applicable laws and regulations when conducting security research.
