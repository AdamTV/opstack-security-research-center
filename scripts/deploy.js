const { ethers } = require("ethers");

async function main() {
    // Connect to Anvil
    const provider = new ethers.JsonRpcProvider("http://localhost:8545");
    const signer = await provider.getSigner(0);

    // Compile the contract
    const fs = require("fs");
    const solc = require("solc");

    const source = fs.readFileSync("StorageProject/src/SimpleStorage.sol", "utf8");
    const input = {
        language: "Solidity",
        sources: {
            "SimpleStorage.sol": {
                content: source,
            },
        },
        settings: {
            outputSelection: {
                "*": {
                    "*": ["abi", "evm.bytecode"],
                },
            },
        },
    };

    const output = JSON.parse(solc.compile(JSON.stringify(input)));
    const contractData = output.contracts["SimpleStorage.sol"]["SimpleStorage"];
    const bytecode = contractData.evm.bytecode.object;
    const abi = contractData.abi;

    // Deploy the contract
    const factory = new ethers.ContractFactory(abi, bytecode, signer);
    const contract = await factory.deploy();
    await contract.waitForDeployment();

    console.log("SimpleStorage deployed to:", await contract.getAddress());
}

main().catch((error) => {
    console.error(error);
    process.exit(1);
});