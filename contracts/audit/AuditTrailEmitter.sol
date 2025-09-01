// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract AuditTrailEmitter {
    struct AuditEvent {
        string module;
        string action;
        string steward;
        uint256 emotionalAPR;
        uint256 civicResonance;
        uint256 timestamp;
    }

    AuditEvent[] public auditLog;

    event AuditLogged(
        string module,
        string action,
        string steward,
        uint256 emotionalAPR,
        uint256 civicResonance,
        uint256 timestamp
    );

    function logAudit(
        string memory _module,
        string memory _action,
        string memory _steward,
        uint256 _emotionalAPR,
        uint256 _civicResonance
    ) public {
        uint256 time = block.timestamp;

        auditLog.push(AuditEvent(_module, _action, _steward, _emotionalAPR, _civicResonance, time));
        emit AuditLogged(_module, _action, _steward, _emotionalAPR, _civicResonance, time);
    }

    function getAuditLog() public view returns (AuditEvent[] memory) {
        return auditLog;
    }
}
