pragma solidity ^0.8.20;

contract LaborEquityAuditProtocol {
    address public admin;

    struct Audit {
        string region;       // e.g. NCR, Bulacan
        string finding;      // e.g. wage gap identified
        string recommendation; // e.g. standardization needed
        uint256 timestamp;
    }

    Audit[] public audits;

    event AuditLogged(string region, string finding, string recommendation, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logAudit(string calldata region, string calldata finding, string calldata recommendation) external onlyAdmin {
        audits.push(Audit(region, finding, recommendation, block.timestamp));
        emit AuditLogged(region, finding, recommendation, block.timestamp);
    }

    function totalAudits() external view returns (uint256) {
        return audits.length;
    }
}
