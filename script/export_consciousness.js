const { ethers } = require("ethers");
const fs = require("fs");
const path = require("path");

async function main() {
    // Use a reliable public Sepolia RPC endpoint
    const rpcUrl = process.env.SEPOLIA_RPC || "https://ethereum-sepolia-rpc.publicnode.com";
    const provider = new ethers.JsonRpcProvider(rpcUrl);

    // Locate the latest broadcast deployment file for OperatorConsciousnessLedger
    const broadcastPath = path.join(__dirname, "../broadcast/DeployMasterArchitecture.s.sol/11155111/run-latest.json");
    
    if (!fs.existsSync(broadcastPath)) {
        console.error("❌ Broadcast file not found. Please run your deployment script first.");
        process.exit(1);
    }

    const broadcastData = JSON.parse(fs.readFileSync(broadcastPath, "utf8"));
    const deploymentTx = broadcastData.transactions.find(tx => tx.contractName === "OperatorConsciousnessLedger");

    if (!deploymentTx || !deploymentTx.contractAddress) {
        console.error("❌ OperatorConsciousnessLedger address not found in broadcast data.");
        process.exit(1);
    }

    const contractAddress = deploymentTx.contractAddress;
    console.log(`Connecting to OperatorConsciousnessLedger at: ${contractAddress}`);

    // Minimal ABI for fetching log count
    const abi = [
        "function getLogCount() view returns (uint256)"
    ];

    const ledgerContract = new ethers.Contract(contractAddress, abi, provider);
    const count = await ledgerContract.getLogCount();
    
    console.log(`✅ Successfully connected! Current Consciousness Log Count: ${count.toString()}`);
}

main().catch((error) => {
    console.error("❌ Error executing export script:", error);
    process.exit(1);
});
