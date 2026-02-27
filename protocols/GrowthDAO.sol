// GrowthDAO.sol
pragma solidity ^0.8.0;

contract GrowthDAO {
    struct Initiative {
        uint256 id;
        string sector;    // e.g. "Agriculture Exports"
        string project;   // e.g. "Made in PH Testing Abroad"
        uint256 votesFor;
        uint256 votesAgainst;
        bool ratified;
    }

    uint256 public initiativeCount;
    mapping(uint256 => Initiative) public initiatives;

    event InitiativeCreated(uint256 id, string sector, string project);
    event InitiativeVoted(uint256 id, string sector, bool support);
    event InitiativeRatified(uint256 id, string sector);
    event GrowthDeclared(string message);

    function createInitiative(string memory sector, string memory project) public {
        initiativeCount++;
        initiatives[initiativeCount] = Initiative(initiativeCount, sector, project, 0, 0, false);
        emit InitiativeCreated(initiativeCount, sector, project);
    }

    function voteInitiative(uint256 id, bool support) public {
        if (support) {
            initiatives[id].votesFor++;
        } else {
            initiatives[id].votesAgainst++;
        }
        emit InitiativeVoted(id, initiatives[id].sector, support);
    }

    function ratifyInitiative(uint256 id) public {
        Initiative storage i = initiatives[id];
        require(!i.ratified, "Already ratified");
        require(i.votesFor > i.votesAgainst, "Not enough support");
        i.ratified = true;
        emit InitiativeRatified(i.id, i.sector);
    }

    function declareGrowth() public {
        emit GrowthDeclared("Growth DAO: safeguard arcs encoded into communal consequence.");
    }
}
