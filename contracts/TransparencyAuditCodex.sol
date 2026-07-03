// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title TransparencyAuditCodex
/// @notice Covenant contract to safeguard transparency through auditing of safety reports and compliance logs
contract TransparencyAuditCodex {
    address public overseer;
    uint256 public auditCount;

    struct AuditEntry {
        uint256 id;
        string reportType;
        string status;
        string remarks;
        uint256 timestamp;
    }

    mapping(uint256 => AuditEntry) public audits;

    event AuditLogged(uint256 indexed id, string reportType, string status);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logAudit(
        string calldata reportType,
        string calldata status,
        string calldata remarks
    ) external onlyOverseer {
        auditCount++;
        audits[auditCount] = AuditEntry({
            id: auditCount,
            reportType: reportType,
            status: status,
            remarks: remarks,
            timestamp: block.timestamp
        });
        emit AuditLogged(auditCount, reportType, status);
    }

    function viewAudit(uint256 id) external view returns (AuditEntry memory) {
        return audits[id];
    }
}
