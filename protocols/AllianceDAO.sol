// AllianceDAO.sol
pragma solidity ^0.8.0;

contract AllianceDAO {
    struct Pact {
        uint256 id;
        string partner;   // e.g. "Palantir"
        string focus;     // e.g. "Defense Collaboration"
        uint256 votesFor;
        uint256 votesAgainst;
        bool ratified;
    }

    uint256 public pactCount;
    mapping(uint256 => Pact) public pacts;

    event PactCreated(uint256 id, string partner, string focus);
    event PactVoted(uint256 id, string partner, bool support);
    event PactRatified(uint256 id, string partner);
    event AllianceDeclared(string message);

    function createPact(string memory partner, string memory focus) public {
        pactCount++;
        pacts[pactCount] = Pact(pactCount, partner, focus, 0, 0, false);
        emit PactCreated(pactCount, partner, focus);
    }

    function votePact(uint256 id, bool support) public {
        if (support) {
            pacts[id].votesFor++;
        } else {
            pacts[id].votesAgainst++;
        }
        emit PactVoted(id, pacts[id].partner, support);
    }

    function ratifyPact(uint256 id) public {
        Pact storage p = pacts[id];
        require(!p.ratified, "Already ratified");
        require(p.votesFor > p.votesAgainst, "Not enough support");
        p.ratified = true;
        emit PactRatified(p.id, p.partner);
    }

    function declareAlliance() public {
        emit AllianceDeclared("Alliance DAO: safeguard arcs encoded into communal consequence.");
    }
}
