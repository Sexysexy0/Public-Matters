// IncidentDAO.sol
pragma solidity ^0.8.0;

contract IncidentDAO {
    struct Incident {
        uint256 id;
        string system;   // e.g. "DepEd Imus City HRMS"
        string description; // e.g. "Partial Defacement"
        uint256 votesFor;
        uint256 votesAgainst;
        bool resolved;
    }

    uint256 public incidentCount;
    mapping(uint256 => Incident) public incidents;

    event IncidentCreated(uint256 id, string system, string description);
    event IncidentVoted(uint256 id, string system, bool support);
    event IncidentResolved(uint256 id, string system);
    event IncidentDeclared(string message);

    function createIncident(string memory system, string memory description) public {
        incidentCount++;
        incidents[incidentCount] = Incident(incidentCount, system, description, 0, 0, false);
        emit IncidentCreated(incidentCount, system, description);
    }

    function voteIncident(uint256 id, bool support) public {
        if (support) {
            incidents[id].votesFor++;
        } else {
            incidents[id].votesAgainst++;
        }
        emit IncidentVoted(id, incidents[id].system, support);
    }

    function resolveIncident(uint256 id) public {
        Incident storage i = incidents[id];
        require(!i.resolved, "Already resolved");
        require(i.votesFor > i.votesAgainst, "Not enough support");
        i.resolved = true;
        emit IncidentResolved(i.id, i.system);
    }

    function declareIncident() public {
        emit IncidentDeclared("Incident DAO: safeguard arcs encoded into communal consequence.");
    }
}
