// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ReformAuditLedger
/// @notice Covenant contract to audit and record effectiveness of policy reforms
contract ReformAuditLedger {
    address public overseer;
    uint256 public auditCount;

    struct AuditEntry {
        uint256 id;
        string policyName;
        string auditResult;
        string notes;
        string auditor;
        uint256 timestamp;
    }

    mapping(uint256 => AuditEntry) public audits;

    event ReformAudited(uint256 indexed id, string policyName, string auditResult, string auditor);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logAudit(
        string calldata policyName,
        string calldata auditResult,
        string calldata notes,
        string calldata auditor
    ) external onlyOverseer {
        auditCount++;
        audits[auditCount] = AuditEntry({
            id: auditCount,
            policyName: policyName,
            auditResult: auditResult,
            notes: notes,
            auditor: auditor,
            timestamp: block.timestamp
        });
        emit ReformAudited(auditCount, policyName, auditResult, auditor);
    }

    function viewAudit(uint256 id) external view returns (AuditEntry memory) {
        return audits[id];
    }
}
