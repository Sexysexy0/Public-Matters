// SupportDAO.sol
pragma solidity ^0.8.0;

contract SupportDAO {
    struct Initiative {
        uint256 id;
        string focus;     // e.g. "Direct Applicant Support"
        string proposer;  // e.g. "HR Council"
        uint256 votesFor;
        uint256 votesAgainst;
        bool ratified;
    }

    uint256 public initiativeCount;
    mapping(uint256 => Initiative) public initiatives;

    event InitiativeCreated(uint256 id, string focus, string proposer);
    event InitiativeVoted(uint256 id, string focus, bool support);
    event InitiativeRatified(uint256 id, string focus);
    event SupportDeclared(string message);

    function createInitiative(string memory focus, string memory proposer) public {
        initiativeCount++;
        initiatives[initiativeCount] = Initiative(initiativeCount, focus, proposer, 0, 0, false);
        emit InitiativeCreated(initiativeCount, focus, proposer);
    }

    function voteInitiative(uint256 id, bool support) public {
        if (support) {
            initiatives[id].votesFor++;
        } else {
            initiatives[id].votesAgainst++;
        }
        emit InitiativeVoted(id, initiatives[id].focus, support);
    }

    function ratifyInitiative(uint256 id) public {
        Initiative storage i = initiatives[id];
        require(!i.ratified, "Already ratified");
        require(i.votesFor > i.votesAgainst, "Not enough support");
        i.ratified = true;
        emit InitiativeRatified(i.id, i.focus);
    }

    function declareSupport() public {
        emit SupportDeclared("Support DAO: safeguard arcs encoded into communal consequence.");
    }
}
