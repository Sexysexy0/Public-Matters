// contracts/GlobalResilience.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title GlobalResilience
 * @notice Protocols for food security, energy resilience, digital sovereignty, and geopolitical audit.
 */
contract GlobalResilience {
    address public admin;

    enum Domain { FoodSecurity, EnergyResilience, DigitalSovereignty, GeopoliticalAudit }

    struct ResilienceDomain {
        Domain domain;
        string status;   // e.g., "Stable", "Watch", "Critical"
        string note;     // summary/details
        uint256 updatedAt;
    }

    struct AuditLog {
        Domain domain;
        string entry;
        uint256 timestamp;
    }

    ResilienceDomain[] public domains;
    AuditLog[] public audits;

    event DomainRegistered(Domain domain, string status, string note, uint256 updatedAt);
    event DomainUpdated(Domain domain, string status, string note, uint256 updatedAt);
    event AuditLogged(Domain domain, string entry, uint256 timestamp);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function registerDomain(Domain domain, string calldata status, string calldata note) external onlyAdmin {
        domains.push(ResilienceDomain(domain, status, note, block.timestamp));
        emit DomainRegistered(domain, status, note, block.timestamp);
    }

    function updateDomain(uint256 id, string calldata status, string calldata note) external onlyAdmin {
        require(id < domains.length, "Invalid id");
        domains[id].status = status;
        domains[id].note = note;
        domains[id].updatedAt = block.timestamp;
        emit DomainUpdated(domains[id].domain, status, note, block.timestamp);
    }

    function logAudit(Domain domain, string calldata entry) external onlyAdmin {
        audits.push(AuditLog(domain, entry, block.timestamp));
        emit AuditLogged(domain, entry, block.timestamp);
    }

    function totalDomains() external view returns (uint256) {
        return domains.length;
    }

    function totalAudits() external view returns (uint256) {
        return audits.length;
    }

    function getDomain(uint256 id) external view returns (ResilienceDomain memory) {
        require(id < domains.length, "Invalid id");
        return domains[id];
    }

    function getAudit(uint256 id) external view returns (AuditLog memory) {
        require(id < audits.length, "Invalid id");
        return audits[id];
    }
}
