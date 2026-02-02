// InnovationEcosystemDAO.sol
pragma solidity ^0.8.0;

contract InnovationEcosystemDAO {
    struct Initiative {
        uint256 id;
        string sector;   // e.g. "GenAI", "Digital Transformation", "Climate Tech"
        uint256 votesFor;
        uint256 votesAgainst;
        bool enacted;
    }

    uint256 public initiativeCount;
    mapping(uint256 => Initiative) public initiatives;

    event InitiativeCreated(uint256 id, string sector);
    event InitiativeVoted(uint256 id, string sector, bool support);
    event InitiativeEnacted(uint256 id, string sector);
    event InnovationDeclared(string message);

    function createInitiative(string memory sector) public {
        initiativeCount++;
        initiatives[initiativeCount] = Initiative(initiativeCount, sector, 0, 0, false);
        emit InitiativeCreated(initiativeCount, sector);
    }

    function voteInitiative(uint256 id, bool support) public {
        if (support) {
            initiatives[id].votesFor++;
        } else {
            initiatives[id].votesAgainst++;
        }
        emit InitiativeVoted(id, initiatives[id].sector, support);
    }

    function enactInitiative(uint256 id) public {
        Initiative storage i = initiatives[id];
        require(!i.enacted, "Already enacted");
        require(i.votesFor > i.votesAgainst, "Not enough support");
        i.enacted = true;
        emit InitiativeEnacted(i.id, i.sector);
    }

    function declareInnovation() public {
        emit InnovationDeclared("Innovation Ecosystem DAO: experimentation arcs encoded into communal consequence.");
    }
}
