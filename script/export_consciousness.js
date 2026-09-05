#!/usr/bin/env node

const fs = require("fs");
const { ethers } = require("ethers");

// Replace with your RPC endpoint
const provider = new ethers.JsonRpcProvider(process.env.RPC_URL);

// Replace with deployed contract address
const ledgerAddress = process.env.LEDGER_ADDR;

// Minimal ABI for OperatorConsciousnessLedger
const ledgerAbi = [
  "function getLogCount() view returns (uint256)",
  "function getLog(uint256 index) view returns (address,string,uint256,uint256,bool)"
];

async function main() {
  const ledger = new ethers.Contract(ledgerAddress, ledgerAbi, provider);
  const count = await ledger.getLogCount();

  let output = "## Operator Consciousness Ledger\n\n";
  for (let i = 0; i < count; i++) {
    const [operator, action, trustScore, blockNumber, safeguardTriggered] =
      await ledger.getLog(i);
    output += `- Operator: ${operator}\n  Action: ${action}\n  Trust: ${trustScore}\n  Block: ${blockNumber}\n  Safeguard: ${safeguardTriggered}\n\n`;
  }

  fs.appendFileSync("README.md", output);
  console.log("Ledger exported and appended to README.md");
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
