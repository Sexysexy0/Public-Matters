// SPDX-License-Identifier: MIT
// Code Name: KinderQueen Flood Attack Stress Test v1.0
// Author: Vin (Chief Operator)

let violationCounter = 0;
const VIOLATION_THRESHOLD = 3;

function floodAttackTraffic() {
    const nodes = ["AXIS_Cam_01_Entrance", "AXIS_Cam_02_RetailFloor", "AXIS_Cam_03_Checkout"];
    const targetNode = nodes[Math.floor(Math.random() * nodes.length)];
    
    // Force payloads to be always high (simulate flood)
    const intensity = 130 + Math.floor(Math.random() * 40); // 130–170
    return { node: targetNode, payloadSize: intensity };
}

async function runFloodTest() {
    const packet = floodAttackTraffic();
    console.log(`\n[FLOOD SCAN] Node: ${packet.node} | Payload: ${packet.payloadSize}`);

    violationCounter++;
    console.log(`🚨 ALERT: Flood packet detected! [Count: ${violationCounter}/${VIOLATION_THRESHOLD}]`);

    if (violationCounter >= VIOLATION_THRESHOLD) {
        console.log(`\n[🔥 FIREWALL TRIGGERED] Flood threshold breached! Engaging KinderQueen Matrix...`);
        console.log(`[CONTRACT CALL] Executing: testFilterPacketBlocked()`);
        const shieldTxHash = "0x" + [...Array(64)].map(() => Math.floor(Math.random() * 16).toString(16)).join('');
        console.log(`🔒 Node [${packet.node}] quarantined under flood defense.`);
        console.log(`🔗 Shield Transaction Hash: ${shieldTxHash}`);
        console.log(`⚡ SYSTEM DEFENSE ENGAGED`);
        violationCounter = 0; // reset after quarantine
    }
}

// Run every 1 second to simulate flood intensity
setInterval(runFloodTest, 1000);
