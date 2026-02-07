// CommunityResilienceDAO.sol
pragma solidity ^0.8.0;

contract CommunityResilienceDAO {
    struct Initiative {
        uint256 id;
        string focus;   // e.g. "Education", "Health", "Security"
        string outcome; // e.g. "Improved", "Needs Work"
        uint256 votesFor;
        uint256 votesAgainst;
        bool published;
    }

    uint256 public initiativeCount;
    mapping(uint256 => Initiative) public initiatives;

    event InitiativeCreated(uint256 id, string focus, string outcome);
    event InitiativeVoted(uint256 id, string focus, bool support);
    event InitiativePublished(uint256 id, string focus);
    event ResilienceDeclared(string message);

    function createInitiative(string memory focus, string memory outcome) public {
        initiativeCount++;
        initiatives[initiativeCount] = Initiative(initiativeCount, focus, outcome, 0, 0, false);
        emit InitiativeCreated(initiativeCount, focus, outcome);
    }

    function voteInitiative(uint256 id, bool support) public {
        if (support) {
            initiatives[id].votesFor++;
        } else {
            initiatives[id].votesAgainst++;
        }
        emit InitiativeVoted(id, initiatives[id].focus, support);
    }

    function publishInitiative(uint256 id) public {
        Initiative storage i = initiatives[id];
        require(!i.published, "Already published");
        require(i.votesFor > i.votesAgainst, "Not enough support");
        i.published = true;
        emit InitiativePublished(i.id, i.focus);
    }

    function declareResilience() public {
        emit ResilienceDeclared("Community Resilience DAO: safeguard arcs encoded into communal consequence.");
    }
}
