// Gumagamit ng modern ES Module import pattern
import { ethers } from "ethers";

// 1. Ang Contract ABI Profile Template Maps
const ABI = [
    "function steward() view returns (address)",
    "function emotionalApr() view returns (string)",
    "function getStatus() view returns (string, string, bool)"
];

// 2. Ang Deployed Target Address Parameter Pointer
const CONTRACT_ADDRESS = "0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0"; 

async function main() {
    console.log("System Status: Synchronizing client gateway pipeline via Ethers v6 Modules...");
    
    // Inayos para sa Ethers v6: Direkta nang tinatawag ang JsonRpcProvider nang walang `.providers` layer
    const provider = new ethers.JsonRpcProvider("http://127.0.0.1:8545");
    
    // I-hydrate ang live abstraction interface node instance
    const protocolContract = new ethers.Contract(CONTRACT_ADDRESS, ABI, provider);
    
    try {
        // Hihilahin ng kabilang dulo ang pinakabagong live operational state metrics
        const [emotionalApr, mythicSync, defenseReady] = await protocolContract.getStatus();
        const currentSteward = await protocolContract.steward();
        
        console.log("\n--- CONTRACT STATE TRACE RECEIVED ---");
        console.log(`Target Address:    ${CONTRACT_ADDRESS}`);
        console.log(`Current Steward:   ${currentSteward}`);
        console.log(`Emotional APR:     ${emotionalApr}`);
        console.log(`Mythic Sync State: ${mythicSync}`);
        console.log(`Planetary Defense: ${defenseReady ? "ONLINE 🛡️" : "OFFLINE 🛑"}`);
        console.log("-------------------------------------\n");
        
    } catch (error) {
        console.error("\nError: Connection timeout. Siguraduhing tumatakbo ang local Anvil node chain at tugma ang contract address mo!");
        console.error(`Details: ${error.message}\n`);
    }
}

main();
