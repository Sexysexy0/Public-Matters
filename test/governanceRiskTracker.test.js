const { logGovernanceRisk } = require('../scripts/governanceRiskTracker');
const fs = require('fs');
const path = require('path');

console.log("Running Governance Risk Tracker Test...");
try {
    logGovernanceRisk("TestEntity", "Regulatory Disruption", "Testing accountability logging utility.", "HIGH");
    
    const logPath = path.join(__dirname, '../logs/governance-risks.log');
    if (fs.existsSync(logPath)) {
        console.log("Test Passed: Governance risk log successfully written.");
        process.exit(0);
    } else {
        console.error("Test Failed: Governance risk log file not found.");
        process.exit(1);
    }
} catch (error) {
    console.error("Test Failed with exception:", error);
    process.exit(1);
}
