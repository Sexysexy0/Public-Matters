pragma solidity ^0.8.20;

contract IncidentResponseCommonsProtocol {
    address public admin;

    struct Incident {
        string system;       // e.g. server, app, network
        string description;  // e.g. breach, malware, phishing
        string status;       // e.g. detected, contained, resolved
        uint256 timestamp;
    }

    Incident[] public incidents;

    event IncidentLogged(string system, string description, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logIncident(string calldata system, string calldata description, string calldata status) external onlyAdmin {
        incidents.push(Incident(system, description, status, block.timestamp));
        emit IncidentLogged(system, description, status, block.timestamp);
    }

    function totalIncidents() external view returns (uint256) {
        return incidents.length;
    }
}
