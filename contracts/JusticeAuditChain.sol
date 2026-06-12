// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title JusticeAuditChain
/// @notice Fairness-driven audit trail covenant for governance and tax systems
contract JusticeAuditChain {
    address public oversightCommittee;
    uint256 public auditCount;

    struct JusticeAudit {
        uint256 id;
        address auditor;
        string principle; // e.g. fairness, dignity, transparency
        string details;
        uint256 timestamp;
    }

    mapping(uint256 => JusticeAudit) public audits;

    event JusticeAuditLogged(uint256 indexed id, address indexed auditor, string principle, string details);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight Committee logs fairness-driven audits
    function logJusticeAudit(string calldata principle, string calldata details) external onlyOversight {
        auditCount++;
        audits[auditCount] = JusticeAudit({
            id: auditCount,
            auditor: msg.sender,
            principle: principle,
            details: details,
            timestamp: block.timestamp
        });
        emit JusticeAuditLogged(auditCount, msg.sender, principle, details);
    }

    /// @notice Citizens can view justice audits
    function viewJusticeAudit(uint256 id) external view returns (JusticeAudit memory) {
        return audits[id];
    }
}
