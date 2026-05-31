// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title DefenseAudit
/// @notice Periodic audit contract for reviewing flagged prompts and defense bridge actions
/// @dev Complements PromptInjectionDefense + DefenseBridge

contract DefenseAudit {
    address public auditor;
    uint256 public auditCount;

    struct AuditReport {
        uint256 id;
        string scope;
        string findings;
        uint256 timestamp;
    }

    mapping(uint256 => AuditReport) public reports;

    event AuditLogged(uint256 id, string scope, string findings, uint256 timestamp);
    event AuditReviewed(uint256 id, address reviewer, uint256 timestamp);

    modifier onlyAuditor() {
        require(msg.sender == auditor, "Not authorized");
        _;
    }

    constructor(address _auditor) {
        auditor = _auditor;
        auditCount = 0;
    }

    /// @notice Log a new audit report
    /// @param scope coverage of the audit (e.g., "PromptDefense Q2", "Bridge Sync Review")
    /// @param findings narrative of audit results
    function logAudit(string calldata scope, string calldata findings) external onlyAuditor {
        auditCount++;
        reports[auditCount] = AuditReport(auditCount, scope, findings, block.timestamp);
        emit AuditLogged(auditCount, scope, findings, block.timestamp);
    }

    /// @notice Review an existing audit report
    /// @param id identifier of the audit report
    function reviewAudit(uint256 id) external onlyAuditor {
        require(bytes(reports[id].findings).length > 0, "Audit not found");
        emit AuditReviewed(id, msg.sender, block.timestamp);
    }

    /// @notice Retrieve audit report by ID
    /// @param id identifier of the audit report
    /// @return full audit report struct
    function getAudit(uint256 id) external view returns (AuditReport memory) {
        return reports[id];
    }
}
