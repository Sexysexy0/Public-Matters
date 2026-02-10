// GamingFocusDAO.sol
pragma solidity ^0.8.0;

contract GamingFocusDAO {
    struct Initiative {
        uint256 id;
        string company;   // e.g. "Nvidia"
        string focus;     // e.g. "Gaming GPU", "AI Accelerator"
        uint256 votesFor;
        uint256 votesAgainst;
        bool resolved;
    }

    uint256 public initiativeCount;
    mapping(uint256 => Initiative) public initiatives;

    event InitiativeCreated(uint256 id, string company, string focus);
    event InitiativeVoted(uint256 id, string company, bool support);
    event InitiativeResolved(uint256 id, string company);
    event GamingDeclared(string message);

    function createInitiative(string memory company, string memory focus) public {
        initiativeCount++;
        initiatives[initiativeCount] = Initiative(initiativeCount, company, focus, 0, 0, false);
        emit InitiativeCreated(initiativeCount, company, focus);
    }

    function voteInitiative(uint256 id, bool support) public {
        if (support) {
            initiatives[id].votesFor++;
        } else {
            initiatives[id].votesAgainst++;
        }
        emit InitiativeVoted(id, initiatives[id].company, support);
    }

    function resolveInitiative(uint256 id) public {
        Initiative storage i = initiatives[id];
        require(!i.resolved, "Already resolved");
        require(i.votesFor > i.votesAgainst, "Not enough support");
        i.resolved = true;
        emit InitiativeResolved(i.id, i.company);
    }

    function declareGaming() public {
        emit GamingDeclared("Gaming Focus DAO: safeguard arcs encoded into communal consequence.");
    }
}
