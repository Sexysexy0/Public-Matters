pragma solidity ^0.8.20;

contract OverpricingAuditProtocol {
    address public admin;

    struct Audit {
        string item;         // e.g. streetlights, bleachers
        uint256 unitCost;    // e.g. 230000
        uint256 totalCost;   // e.g. 300000000
        string verdict;      // e.g. overpriced, fair
        uint256 timestamp;
    }

    Audit[] public audits;

    event AuditLogged(string item, uint256 unitCost, uint256 totalCost, string verdict, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logAudit(string calldata item, uint256 unitCost, uint256 totalCost, string calldata verdict) external onlyAdmin {
        audits.push(Audit(item, unitCost, totalCost, verdict, block.timestamp));
        emit AuditLogged(item, unitCost, totalCost, verdict, block.timestamp);
    }

    function totalAudits() external view returns (uint256) {
        return audits.length;
    }
}
