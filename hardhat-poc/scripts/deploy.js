const hre = require("hardhat");

async function main() {
  console.log("🚀 Deploying test contracts for security research...");
  console.log("=================================================");
  
  // Get the deployer account
  const [deployer] = await hre.ethers.getSigners();
  console.log("👤 Deploying with account:", deployer.address);
  
  // Get account balance
  const balance = await hre.ethers.provider.getBalance(deployer.address);
  console.log("💰 Account balance:", hre.ethers.formatEther(balance), "ETH");
  
  try {
    // Deploy Vulnerable contract
    console.log("\n🎯 Deploying Vulnerable contract...");
    const Vulnerable = await hre.ethers.getContractFactory("Vulnerable");
    const vulnerable = await Vulnerable.deploy();
    await vulnerable.waitForDeployment();
    const vulnerableAddress = await vulnerable.getAddress();
    console.log("✅ Vulnerable contract deployed to:", vulnerableAddress);
    
    // Deploy Exploit contract
    console.log("\n🔓 Deploying Exploit contract...");
    const Exploit = await hre.ethers.getContractFactory("Exploit");
    const exploit = await Exploit.deploy(vulnerableAddress);
    await exploit.waitForDeployment();
    const exploitAddress = await exploit.getAddress();
    console.log("✅ Exploit contract deployed to:", exploitAddress);
    
    console.log("\n📋 Deployment Summary:");
    console.log("=====================");
    console.log("Vulnerable Contract:", vulnerableAddress);
    console.log("Exploit Contract:", exploitAddress);
    console.log("Network:", hre.network.name);
    console.log("Chain ID:", (await hre.ethers.provider.getNetwork()).chainId);
    
    console.log("\n🧪 Ready for security testing!");
    console.log("Use 'Test Exploits' button to run attack scenarios");
    
  } catch (error) {
    console.error("❌ Deployment failed:", error.message);
    process.exit(1);
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("❌ Script failed:", error);
    process.exit(1);
  });
