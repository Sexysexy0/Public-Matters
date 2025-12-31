// contracts/KnowledgeAudit.sol
pragma solidity ^0.8.20;

contract KnowledgeAudit {
    address public admin;

    struct Audit {
        string domain;      // "Academia", "Tech", "Media"
        string finding;
        uint256 timestamp;
    }

    Audit[] public audits;

    event AuditLogged(string domain, string finding, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }
    constructor() { admin = msg.sender; }

    function logAudit(string calldata domain, string calldata finding) external onlyAdmin {
        audits.push(Audit(domain, finding, block.timestamp));
        emit AuditLogged(domain, finding, block.timestamp);
    }
}
