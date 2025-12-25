// contracts/AITragedyLog.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title AITragedyLog
 * @notice Logs incidents attributed to AI systems for communal audit.
 */
contract AITragedyLog {
    address public admin;

    struct Incident {
        string description; // "Self-driving crash", "Algorithmic bias"
        string severity;    // "Minor", "Major", "Fatal"
        uint256 timestamp;
    }

    Incident[] public incidents;

    event IncidentLogged(string description, string severity, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logIncident(string calldata description, string calldata severity) external onlyAdmin {
        incidents.push(Incident(description, severity, block.timestamp));
        emit IncidentLogged(description, severity, block.timestamp);
    }

    function totalIncidents() external view returns (uint256) { return incidents.length; }

    function getIncident(uint256 id) external view returns (Incident memory) {
        require(id < incidents.length, "Invalid id");
        return incidents[id];
    }
}
