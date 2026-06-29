// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ConsentAuditCodex
/// @notice Covenant contract to safeguard communities through systemic anchoring of consent audit safeguards
contract ConsentAuditCodex {
    address public overseer;
    uint256 public auditCount;

    struct AuditEntry {
        uint256 id;
        string subject;
        string guardian;
        string procedure;
        bool consentGiven;
        string recordHash;
        uint256 timestamp;
    }

    mapping(uint256 => AuditEntry) public audits;

    event AuditLogged(uint256 indexed id, string subject, string guardian, string procedure, bool consentGiven);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logAudit(
        string calldata subject,
        string calldata guardian,
        string calldata procedure,
        bool consentGiven,
        string calldata recordHash
    ) external onlyOverseer {
        auditCount++;
        audits[auditCount] = AuditEntry({
            id: auditCount,
            subject: subject,
            guardian: guardian,
            procedure: procedure,
            consentGiven: consentGiven,
            recordHash: recordHash,
            timestamp: block.timestamp
        });
        emit AuditLogged(auditCount, subject, guardian, procedure, consentGiven);
    }

    function viewAudit(uint256 id) external view returns (AuditEntry memory) {
        return audits[id];
    }
}
