pragma solidity ^0.8.20;

contract FalseFlagProtocol {
    address public admin;

    struct Incident {
        string perpetrator;  // e.g. Homelander
        string tactic;       // e.g. staged attack, demonizing opponents
        string outcome;      // e.g. division, fear manipulation
        uint256 timestamp;
    }

    Incident[] public incidents;

    event IncidentLogged(string perpetrator, string tactic, string outcome, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logIncident(string calldata perpetrator, string calldata tactic, string calldata outcome) external onlyAdmin {
        incidents.push(Incident(perpetrator, tactic, outcome, block.timestamp));
        emit IncidentLogged(perpetrator, tactic, outcome, block.timestamp);
    }

    function totalIncidents() external view returns (uint256) {
        return incidents.length;
    }
}
