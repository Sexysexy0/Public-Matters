// Governance OS Dashboard Web3 Integration
// Author: Vin (Chief Operator)

import { ethers } from "ethers";

// Replace with your deployed contract address + ABI
const grandChainAddress = "0xYourGrandCovenantChainAddress";
const grandChainABI = [ /* ABI JSON here */ ];

async function initDashboard() {
  // Connect to Ethereum provider (Metamask / RPC)
  const provider = new ethers.providers.Web3Provider(window.ethereum);
  await provider.send("eth_requestAccounts", []);
  const signer = provider.getSigner();

  const grandChain = new ethers.Contract(grandChainAddress, grandChainABI, signer);

  // Fetch total covenants
  const total = await grandChain.chainCount();
  console.log(`📊 Total covenants linked: ${total}`);

  // Render each covenant entry
  for (let i = 0; i < total; i++) {
    const entry = await grandChain.getChainEntry(i);
    const [name, safeguard, anchor, trigger, timestamp] = entry;

    // Example: update DOM element
    const statusElement = document.createElement("div");
    statusElement.innerHTML = `
      <h3>${name}</h3>
      <p>Safeguard: ${safeguard}</p>
      <p>Anchor: ${anchor}</p>
      <p>Trigger: ${trigger}</p>
      <p>Timestamp: ${new Date(timestamp * 1000).toLocaleString()}</p>
      <p>Status: 🟢 Active</p>
    `;
    document.body.appendChild(statusElement);
  }

  // Listen for new covenant events
  grandChain.on("ChainLinked", (covenantName, safeguard, anchor, trigger, timestamp) => {
    console.log(`🔔 New covenant linked: ${covenantName}`);
    // Update dashboard live
  });
}

initDashboard();
