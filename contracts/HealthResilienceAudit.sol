// contracts/HealthResilienceAudit.sol
pragma solidity ^0.8.20;

/**
 * @title HealthResilienceAudit
 * @notice Logs audits of health system resilience and preparedness.
 */
contract HealthResilienceAudit {
    address public admin;

    struct Audit {
        string sector;      // "Hospitals", "Clinics", "SupplyChain"
        string finding;
        uint256 timestamp;
    }

    Audit[] public audits;

    event AuditLogged(string sector, string finding, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }
    constructor() { admin = msg.sender; }

    function logAudit(string calldata sector, string calldata finding) external onlyAdmin {
        audits.push(Audit(sector, finding, block.timestamp));
        emit AuditLogged(sector, finding, block.timestamp);
    }
}
