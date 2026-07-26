// IncidentDAO.sol
pragma solidity ^0.8.0;

contract IncidentDAO {
    struct Incident {
        uint256 id;
        string module;   // e.g. "API Gateway"
        string detail;   // e.g. "Outage detected"
        bool resolved;
    }

    uint256 public incidentCount;
    mapping(uint256 => Incident) public incidents;

    event IncidentLogged(uint256 id, string module, string detail);
    event IncidentResolved(uint256 id, string module);

    function logIncident(string memory module, string memory detail) public {
        incidentCount++;
        incidents[incidentCount] = Incident(incidentCount, module, detail, false);
        emit IncidentLogged(incidentCount, module, detail);
    }

    function resolveIncident(uint256 id) public {
        incidents[id].resolved = true;
        emit IncidentResolved(id, incidents[id].module);
    }
}
