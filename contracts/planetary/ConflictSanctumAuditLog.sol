// SPDX-License-Identifier: Mercy-Tracking
pragma solidity ^7.7.7;

contract ConflictSanctumAuditLog {
    address public steward;
    uint public totalViolations;

    struct Violation {
        string region;
        string violationType;
        string perpetrator;
        uint timestamp;
        bool mercyGapDetected;
    }

    Violation[] public auditLog;

    event ViolationLogged(string region, string violationType, string perpetrator, uint timestamp, bool mercyGapDetected);

    constructor() {
        steward = msg.sender;
        totalViolations = 0;
    }

    function logViolation(
        string memory region,
        string memory violationType,
        string memory perpetrator,
        bool mercyGapDetected
    ) public {
        require(msg.sender == steward, "Only steward may log");
        auditLog.push(Violation(region, violationType, perpetrator, block.timestamp, mercyGapDetected));
        totalViolations += 1;
        emit ViolationLogged(region, violationType, perpetrator, block.timestamp, mercyGapDetected);
    }

    function getLatestViolation() public view returns (Violation memory) {
        require(auditLog.length > 0, "No violations logged yet");
        return auditLog[auditLog.length - 1];
    }
}
