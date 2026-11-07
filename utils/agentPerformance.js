const fs = require('fs');
const path = require('path');
const { ethers } = require('ethers');
require('dotenv').config();

const provider = new ethers.JsonRpcProvider(process.env.RPC_URL);
const wallet = new ethers.Wallet(process.env.PRIVATE_KEY, provider);

const CONTRACT_ADDRESS = process.env.AGENT_TELEMETRY_ADDRESS || "0x0000000000000000000000000000000000000000";
const CONTRACT_ABI = [
    "function recordTelemetry(bytes32 agentHash, string calldata status, bytes32 metricsHash) external returns (uint256)"
];

const registryContract = new ethers.Contract(CONTRACT_ADDRESS, CONTRACT_ABI, wallet);

async function trackAgentPerformance(agentName, taskStatus, executionMetrics = {}) {
    const record = {
        timestamp: new Date().toISOString(),
        agent: agentName,
        status: taskStatus,
        metrics: executionMetrics
    };

    const logDir = path.join(__dirname, '../logs');
    if (!fs.existsSync(logDir)) {
        fs.mkdirSync(logDir, { recursive: true });
    }

    const logFile = path.join(logDir, 'agent-performance.log');
    fs.appendFileSync(logFile, JSON.stringify(record) + '\n');
    console.log(`[Off-Chain] Logged: ${agentName} | Status: ${taskStatus}`);

    if (CONTRACT_ADDRESS !== "0x0000000000000000000000000000000000000000") {
        try {
            const agentHash = ethers.id(agentName);
            const metricsHash = ethers.id(JSON.stringify(executionMetrics));

            console.log(`[On-Chain] Sending telemetry to Sepolia...`);
            const tx = await registryContract.recordTelemetry(agentHash, taskStatus, metricsHash);
            const receipt = await tx.wait();
            console.log(`[On-Chain] Success! Tx: ${receipt.hash}`);
        } catch (error) {
            console.error(`[On-Chain] Failed:`, error.message);
        }
    }
}

module.exports = { trackAgentPerformance };
