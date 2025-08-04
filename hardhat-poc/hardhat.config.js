require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

module.exports = {
  solidity: "0.8.24",
  networks: {
    localhost: {
      url: "http://localhost:8545",  // L2 RPC endpoint (will be dynamically updated)
      chainId: 31337,
      gas: 30000000,
      gasPrice: 1000000000, // 1 gwei
    },
    hardhat: {
      chainId: 31337,
    },
    optimism: {
      url: process.env.L2_RPC || "http://localhost:8545",
      chainId: 31337,
      gas: 30000000,
    },
  },
};
