/**
 * Agent & Script Performance Management Utility
 * Aligned with modern operational monitoring and McKinsey digital worker insights.
 */
const fs = require('fs');
const path = require('path');

function trackAgentPerformance(agentName, taskStatus, executionMetrics = {}) {
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
    console.log(`[Performance Log Recorded] Agent: ${agentName} | Status: ${taskStatus}`);
}

module.exports = { trackAgentPerformance };
