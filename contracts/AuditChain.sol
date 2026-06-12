// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title AuditChain
/// @notice Immutable audit trail for tax expenditures and collections
contract AuditChain {
    address public oversightCommittee;
    uint256 public auditCount;

    struct AuditLog {
        uint256 id;
        address auditor;
        string details;
        uint256 timestamp;
    }

    mapping(uint256 => AuditLog) public audits;

    event AuditRecorded(uint256 indexed id, address indexed auditor, string details);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight Committee records immutable audit logs
    function recordAudit(string calldata details) external onlyOversight {
        auditCount++;
        audits[auditCount] = AuditLog({
            id: auditCount,
            auditor: msg.sender,
            details: details,
            timestamp: block.timestamp
        });
        emit AuditRecorded(auditCount, msg.sender, details);
    }

    /// @notice Citizens can view audit logs
    function viewAudit(uint256 id) external view returns (AuditLog memory) {
        return audits[id];
    }
}
