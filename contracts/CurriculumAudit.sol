// contracts/CurriculumAudit.sol
pragma solidity ^0.8.20;

/**
 * @title CurriculumAudit
 * @notice Logs audits of educational curricula for balance and relevance.
 */
contract CurriculumAudit {
    address public admin;

    struct Audit {
        string subject;     // "Math", "Science", "History"
        string finding;
        uint256 timestamp;
    }

    Audit[] public audits;

    event AuditLogged(string subject, string finding, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }
    constructor() { admin = msg.sender; }

    function logAudit(string calldata subject, string calldata finding) external onlyAdmin {
        audits.push(Audit(subject, finding, block.timestamp));
        emit AuditLogged(subject, finding, block.timestamp);
    }
}
