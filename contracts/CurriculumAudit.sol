// contracts/CurriculumAudit.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title CurriculumAudit
 * @notice Tracks curriculum fairness and communal dignity in education systems.
 */
contract CurriculumAudit {
    address public admin;

    struct Audit {
        string subject;     // "Math", "Science", "History"
        string verdict;     // "Balanced", "Biased"
        uint256 timestamp;
    }

    Audit[] public audits;

    event AuditLogged(string subject, string verdict, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logAudit(string calldata subject, string calldata verdict) external onlyAdmin {
        audits.push(Audit(subject, verdict, block.timestamp));
        emit AuditLogged(subject, verdict, block.timestamp);
    }

    function totalAudits() external view returns (uint256) { return audits.length; }

    function getAudit(uint256 id) external view returns (Audit memory) {
        require(id < audits.length, "Invalid id");
        return audits[id];
    }
}
