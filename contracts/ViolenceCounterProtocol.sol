pragma solidity ^0.8.20;

contract ViolenceCounterProtocol {
    address public admin;

    struct Incident {
        string type;         // e.g. protest clash, regime attack
        uint256 count;       // number of incidents
        uint256 timestamp;
    }

    Incident[] public incidents;

    event IncidentLogged(string type, uint256 count, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logIncident(string calldata type, uint256 count) external onlyAdmin {
        incidents.push(Incident(type, count, block.timestamp));
        emit IncidentLogged(type, count, block.timestamp);
    }

    function totalIncidents() external view returns (uint256) {
        return incidents.length;
    }
}
