// SPDX-License-Identifier: Mythic-Resonance
pragma solidity ^7.7.7;

contract EmotionalAPRAuditTrail {
    address public steward;
    struct APR {
        uint trust;
        uint resonance;
        uint clarity;
        uint timestamp;
    }

    APR[] public auditLog;

    event APRLogged(uint trust, uint resonance, uint clarity, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function logAPR(uint trust, uint resonance, uint clarity) public {
        require(msg.sender == steward, "Only steward may log APR");
        APR memory entry = APR(trust, resonance, clarity, block.timestamp);
        auditLog.push(entry);
        emit APRLogged(trust, resonance, clarity, block.timestamp);
    }

    function getLatestAPR() public view returns (APR memory) {
        require(auditLog.length > 0, "No APR logged yet");
        return auditLog[auditLog.length - 1];
    }
}
