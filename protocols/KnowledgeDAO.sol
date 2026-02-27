// KnowledgeDAO.sol
pragma solidity ^0.8.0;

contract KnowledgeDAO {
    struct Resource {
        uint256 id;
        string title;     // e.g. "YouTube Tutorial"
        string author;    // e.g. "Community Creator"
        uint256 votesFor;
        uint256 votesAgainst;
        bool ratified;
    }

    uint256 public resourceCount;
    mapping(uint256 => Resource) public resources;

    event ResourceCreated(uint256 id, string title, string author);
    event ResourceVoted(uint256 id, string title, bool support);
    event ResourceRatified(uint256 id, string title);
    event KnowledgeDeclared(string message);

    function createResource(string memory title, string memory author) public {
        resourceCount++;
        resources[resourceCount] = Resource(resourceCount, title, author, 0, 0, false);
        emit ResourceCreated(resourceCount, title, author);
    }

    function voteResource(uint256 id, bool support) public {
        if (support) {
            resources[id].votesFor++;
        } else {
            resources[id].votesAgainst++;
        }
        emit ResourceVoted(id, resources[id].title, support);
    }

    function ratifyResource(uint256 id) public {
        Resource storage r = resources[id];
        require(!r.ratified, "Already ratified");
        require(r.votesFor > r.votesAgainst, "Not enough support");
        r.ratified = true;
        emit ResourceRatified(r.id, r.title);
    }

    function declareKnowledge() public {
        emit KnowledgeDeclared("Knowledge DAO: safeguard arcs encoded into communal consequence.");
    }
}
