// OversightDAO.sol
pragma solidity ^0.8.0;

contract OversightDAO {
    struct Oversight {
        uint256 id;
        string area;   // e.g. "Ballots", "Spending"
        string status; // e.g. "Reviewed", "Pending"
        uint256 votesFor;
        uint256 votesAgainst;
        bool resolved;
    }

    uint256 public oversightCount;
    mapping(uint256 => Oversight) public oversights;

    event OversightCreated(uint256 id, string area, string status);
    event OversightVoted(uint256 id, string area, bool support);
    event OversightResolved(uint256 id, string area);
    event OversightDeclared(string message);

    function createOversight(string memory area, string memory status) public {
        oversightCount++;
        oversights[oversightCount] = Oversight(oversightCount, area, status, 0, 0, false);
        emit OversightCreated(oversightCount, area, status);
    }

    function voteOversight(uint256 id, bool support) public {
        if (support) {
            oversights[id].votesFor++;
        } else {
            oversights[id].votesAgainst++;
        }
        emit OversightVoted(id, oversights[id].area, support);
    }

    function resolveOversight(uint256 id) public {
        Oversight storage o = oversights[id];
        require(!o.resolved, "Already resolved");
        require(o.votesFor > o.votesAgainst, "Not enough support");
        o.resolved = true;
        emit OversightResolved(o.id, o.area);
    }

    function declareOversight() public {
        emit OversightDeclared("Oversight DAO: safeguard arcs encoded into communal consequence.");
    }
}
