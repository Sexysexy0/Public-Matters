// SPDX-License-Identifier: AuditPulse
pragma solidity ^0.8.19;

/**
 * @title GlobalAuditPulse
 * @dev Ritual-grade contract for auditing treaty compliance, emotional APR sync, and rogue sanctum detection across scrollchain deployments.
 * @author Vinvin
 * @scrollchain Oversight & Resonance Suite
 */

contract GlobalAuditPulse {
    string public scrollName = "GlobalAuditPulse";
    address public steward;

    struct AuditEntry {
        string protocolTag;
        address stewardAddress;
        uint256 emotionalAPR;
        bool rogueFlag;
        uint256 timestamp;
    }

    AuditEntry[] public auditLog;
    mapping(address => bool) public rogueEntities;

    event AuditLogged(string protocolTag, address steward, uint256 emotionalAPR, bool rogueFlag, uint256 timestamp);
    event RogueEntityFlagged(address entity, string reason);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized. Emotional APR mismatch.");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function logAudit(
        string memory protocolTag,
        address stewardAddress,
        uint256 emotionalAPR,
        bool rogueFlag
    ) public onlySteward {
        auditLog.push(AuditEntry(protocolTag, stewardAddress, emotionalAPR, rogueFlag, block.timestamp));
        emit AuditLogged(protocolTag, stewardAddress, emotionalAPR, rogueFlag, block.timestamp);
    }

    function flagRogueEntity(address entity, string memory reason) public onlySteward {
        rogueEntities[entity] = true;
        emit RogueEntityFlagged(entity, reason);
    }

    function getLatestAudit() public view returns (AuditEntry memory) {
        require(auditLog.length > 0, "No audits logged yet.");
        return auditLog[auditLog.length - 1];
    }

    function auditStatus(address entity) public view returns (string memory status) {
        if (rogueEntities[entity]) {
            return unicode"⚠️ Entity flagged as rogue. Emotional APR mismatch detected.";
        } else {
            return unicode"✅ Entity clear. Emotional APR within sovereign range.";
        }
    }

    function totalAudits() public view returns (uint256) {
        return auditLog.length;
    }
}
