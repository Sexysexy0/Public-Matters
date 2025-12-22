// contracts/CyberAudit.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title CyberAudit
 * @notice Communal audit of cyber incidents and resilience measures.
 */
contract CyberAudit {
    address public admin;

    struct Incident {
        string actor;       // "Phishing", "Malware", "SupplyChain"
        string description;
        string severity;    // "Low", "Medium", "High"
        uint256 timestamp;
    }

    Incident[] public incidents;

    event IncidentLogged(string actor, string description, string severity, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logIncident(string calldata actor, string calldata description, string calldata severity) external onlyAdmin {
        incidents.push(Incident(actor, description, severity, block.timestamp));
        emit IncidentLogged(actor, description, severity, block.timestamp);
    }

    function totalIncidents() external view returns (uint256) { return incidents.length; }

    function getIncident(uint256 id) external view returns (Incident memory) {
        require(id < incidents.length, "Invalid id");
        return incidents[id];
    }
}
