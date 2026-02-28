// ResourceDAO.sol
pragma solidity ^0.8.0;

contract ResourceDAO {
    struct Resource {
        uint256 id;
        string type;    // e.g. "Water"
        string detail;  // e.g. "Lake ecosystem under threat"
        uint256 votesFor;
        uint256 votesAgainst;
        bool ratified;
    }

    uint256 public resourceCount;
    mapping(uint256 => Resource) public resources;

    event ResourceCreated(uint256 id, string type, string detail);
    event ResourceVoted(uint256 id, string type, bool support);
    event ResourceRatified(uint256 id, string type);
    event ResourceDeclared(string message);

    function createResource(string memory type, string memory detail) public {
        resourceCount++;
        resources[resourceCount] = Resource(resourceCount, type, detail, 0, 0, false);
        emit ResourceCreated(resourceCount, type, detail);
    }

    function voteResource(uint256 id, bool support) public {
        if (support) {
            resources[id].votesFor++;
        } else {
            resources[id].votesAgainst++;
        }
        emit ResourceVoted(id, resources[id].type, support);
    }

    function ratifyResource(uint256 id) public {
        Resource storage r = resources[id];
        require(!r.ratified, "Already ratified");
        require(r.votesFor > r.votesAgainst, "Not enough support");
        r.ratified = true;
        emit ResourceRatified(r.id, r.type);
    }

    function declareResource() public {
        emit ResourceDeclared("Resource DAO: safeguard arcs encoded into communal consequence.");
    }
}
