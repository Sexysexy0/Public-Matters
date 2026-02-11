// ConsumerRightsDAO.sol
pragma solidity ^0.8.0;

contract ConsumerRightsDAO {
    struct Right {
        uint256 id;
        string category;   // e.g. "Pricing", "Transparency"
        string protection; // e.g. "No Exploitation", "Clear Disclosure"
        uint256 votesFor;
        uint256 votesAgainst;
        bool resolved;
    }

    uint256 public rightCount;
    mapping(uint256 => Right) public rights;

    event RightCreated(uint256 id, string category, string protection);
    event RightVoted(uint256 id, string category, bool support);
    event RightResolved(uint256 id, string category);
    event ConsumerDeclared(string message);

    function createRight(string memory category, string memory protection) public {
        rightCount++;
        rights[rightCount] = Right(rightCount, category, protection, 0, 0, false);
        emit RightCreated(rightCount, category, protection);
    }

    function voteRight(uint256 id, bool support) public {
        if (support) {
            rights[id].votesFor++;
        } else {
            rights[id].votesAgainst++;
        }
        emit RightVoted(id, rights[id].category, support);
    }

    function resolveRight(uint256 id) public {
        Right storage r = rights[id];
        require(!r.resolved, "Already resolved");
        require(r.votesFor > r.votesAgainst, "Not enough support");
        r.resolved = true;
        emit RightResolved(r.id, r.category);
    }

    function declareConsumer() public {
        emit ConsumerDeclared("Consumer Rights DAO: safeguard arcs encoded into communal consequence.");
    }
}
