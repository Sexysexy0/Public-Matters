/**
 * Governance Risk & Accountability Tracker
 * Monitors regulatory decisions, policy disruptions, and institutional risks.
 */
const fs = require('fs');
const path = require('path');

function logGovernanceRisk(entity, issueType, description, severity = 'HIGH') {
    const record = {
        timestamp: new Date().toISOString(),
        targetEntity: entity,
        issue: issueType,
        severityLevel: severity,
        details: description,
        actionRequired: "Formal investigation and public audit"
    };

    const logDir = path.join(__dirname, '../logs');
    if (!fs.existsSync(logDir)) {
        fs.mkdirSync(logDir, { recursive: true });
    }

    const logFile = path.join(logDir, 'governance-risks.log');
    fs.appendFileSync(logFile, JSON.stringify(record) + '\n');
    console.log(`[Governance Alert] Recorded issue for ${entity}: ${issueType} [Severity: ${severity}]`);
}

module.exports = { logGovernanceRisk };
