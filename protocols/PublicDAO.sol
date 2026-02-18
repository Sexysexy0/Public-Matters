// PublicDAO.sol
pragma solidity ^0.8.0;

contract PublicDAO {
    struct Initiative {
        uint256 id;
        string issue;    // e.g. "Utility Rates"
        string proposer; // e.g. "Community Board"
        uint256 votesFor;
        uint256 votesAgainst;
        bool ratified;
    }

    uint256 public initiativeCount;
    mapping(uint256 => Initiative) public initiatives;

    event InitiativeCreated(uint256 id, string issue, string proposer);
    event InitiativeVoted(uint256 id, string issue, bool support);
    event InitiativeRatified(uint256 id, string issue);
    event PublicDeclared(string message);

    function createInitiative(string memory issue, string memory proposer) public {
        initiativeCount++;
        initiatives[initiativeCount] = Initiative(initiativeCount, issue, proposer, 0, 0, false);
        emit InitiativeCreated(initiativeCount, issue, proposer);
    }

    function voteInitiative(uint256 id, bool support) public {
        if (support) {
            initiatives[id].votesFor++;
        } else {
            initiatives[id].votesAgainst++;
        }
        emit InitiativeVoted(id, initiatives[id].issue, support);
    }

    function ratifyInitiative(uint256 id) public {
        Initiative storage i = initiatives[id];
        require(!i.ratified, "Already ratified");
        require(i.votesFor > i.votesAgainst, "Not enough support");
        i.ratified = true;
        emit InitiativeRatified(i.id, i.issue);
    }

    function declarePublic() public {
        emit PublicDeclared("Public DAO: safeguard arcs encoded into communal consequence.");
    }
}
