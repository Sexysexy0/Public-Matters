pragma solidity ^0.8.20;

contract IndependentAuditProtocol {
    address public admin;

    struct Audit {
        string entity;       // e.g. Company, Agency
        string finding;      // e.g. Anomaly, Compliance issue
        uint256 timestamp;
    }

    Audit[] public audits;

    event AuditLogged(string entity, string finding, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logAudit(string calldata entity, string calldata finding) external onlyAdmin {
        audits.push(Audit(entity, finding, block.timestamp));
        emit AuditLogged(entity, finding, block.timestamp);
    }

    function totalAudits() external view returns (uint256) {
        return audits.length;
    }
}
