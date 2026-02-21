// InsiderProtocol.sol
pragma solidity ^0.8.0;

contract InsiderProtocol {
    struct Incident {
        uint256 id;
        string employee;   // e.g. "Engineer A"
        string breach;     // e.g. "Trade Secret Theft"
        string status;     // e.g. "Detected", "Escalated"
        uint256 timestamp;
    }

    uint256 public incidentCount;
    mapping(uint256 => Incident) public incidents;

    event IncidentLogged(uint256 id, string employee, string breach, string status, uint256 timestamp);
    event InsiderDeclared(string message);

    function logIncident(string memory employee, string memory breach, string memory status) public {
        incidentCount++;
        incidents[incidentCount] = Incident(incidentCount, employee, breach, status, block.timestamp);
        emit IncidentLogged(incidentCount, employee, breach, status, block.timestamp);
    }

    function declareInsider() public {
        emit InsiderDeclared("Insider Protocol: validator-grade safeguards encoded into communal dignity.");
    }
}
