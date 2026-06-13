// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title GuardianAuditChain
/// @notice Chain covenant for continuous auditing of compliance guardrails
contract GuardianAuditChain {
    address public oversightCommittee;
    uint256 public auditCount;

    struct AuditRecord {
        uint256 id;
        string guardrail;    // e.g. compliance fence, deployment bridge
        string status;       // compliant, violation, pending
        string notes;
        uint256 timestamp;
    }

    mapping(uint256 => AuditRecord) public audits;

    event AuditLogged(uint256 indexed id, string guardrail, string status, string notes);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight logs audit record for guardrail
    function logAudit(string calldata guardrail, string calldata status, string calldata notes) external onlyOversight {
        auditCount++;
        audits[auditCount] = AuditRecord({
            id: auditCount,
            guardrail: guardrail,
            status: status,
            notes: notes,
            timestamp: block.timestamp
        });
        emit AuditLogged(auditCount, guardrail, status, notes);
    }

    /// @notice Citizens can view audit records
    function viewAudit(uint256 id) external view returns (AuditRecord memory) {
        return audits[id];
    }
}
