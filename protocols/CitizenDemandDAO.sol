// CitizenDemandDAO.sol
pragma solidity ^0.8.0;

contract CitizenDemandDAO {
    struct Demand {
        uint256 id;
        string citizen;   // e.g. "Juan Dela Cruz"
        string request;   // e.g. "Faster Processing", "Digitalization"
        uint256 votesFor;
        uint256 votesAgainst;
        bool resolved;
    }

    uint256 public demandCount;
    mapping(uint256 => Demand) public demands;

    event DemandCreated(uint256 id, string citizen, string request);
    event DemandVoted(uint256 id, string citizen, bool support);
    event DemandResolved(uint256 id, string citizen);
    event DemandDeclared(string message);

    function createDemand(string memory citizen, string memory request) public {
        demandCount++;
        demands[demandCount] = Demand(demandCount, citizen, request, 0, 0, false);
        emit DemandCreated(demandCount, citizen, request);
    }

    function voteDemand(uint256 id, bool support) public {
        if (support) {
            demands[id].votesFor++;
        } else {
            demands[id].votesAgainst++;
        }
        emit DemandVoted(id, demands[id].citizen, support);
    }

    function resolveDemand(uint256 id) public {
        Demand storage d = demands[id];
        require(!d.resolved, "Already resolved");
        require(d.votesFor > d.votesAgainst, "Not enough support");
        d.resolved = true;
        emit DemandResolved(d.id, d.citizen);
    }

    function declareDemand() public {
        emit DemandDeclared("Citizen Demand DAO: safeguard arcs encoded into communal consequence.");
    }
}
