const { trackAgentPerformance } = require('../utils/agentPerformance');
const fs = require('fs');
const path = require('path');

console.log("Running Agent Performance Logger Test...");
try {
    trackAgentPerformance("TestAgent", "SUCCESS", { cpuLoad: "12%", memory: "512MB" });
    const logPath = path.join(__dirname, '../logs/agent-performance.log');
    if (fs.existsSync(logPath)) {
        console.log("Test Passed: Performance log successfully written.");
        process.exit(0);
    } else {
        console.error("Test Failed: Log file not found.");
        process.exit(1);
    }
} catch (error) {
    console.error("Test Failed with exception:", error);
    process.exit(1);
}
