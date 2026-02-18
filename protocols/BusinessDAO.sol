// BusinessDAO.sol
pragma solidity ^0.8.0;

contract BusinessDAO {
    struct Decision {
        uint256 id;
        string company;   // e.g. "Retail Chain"
        string issue;     // e.g. "Price Increase"
        uint256 votesFor;
        uint256 votesAgainst;
        bool ratified;
    }

    uint256 public decisionCount;
    mapping(uint256 => Decision) public decisions;

    event DecisionCreated(uint256 id, string company, string issue);
    event DecisionVoted(uint256 id, string company, bool support);
    event DecisionRatified(uint256 id, string company);
    event BusinessDeclared(string message);

    function createDecision(string memory company, string memory issue) public {
        decisionCount++;
        decisions[decisionCount] = Decision(decisionCount, company, issue, 0, 0, false);
        emit DecisionCreated(decisionCount, company, issue);
    }

    function voteDecision(uint256 id, bool support) public {
        if (support) {
            decisions[id].votesFor++;
        } else {
            decisions[id].votesAgainst++;
        }
        emit DecisionVoted(id, decisions[id].company, support);
    }

    function ratifyDecision(uint256 id) public {
        Decision storage d = decisions[id];
        require(!d.ratified, "Already ratified");
        require(d.votesFor > d.votesAgainst, "Not enough support");
        d.ratified = true;
        emit DecisionRatified(d.id, d.company);
    }

    function declareBusiness() public {
        emit BusinessDeclared("Business DAO: safeguard arcs encoded into communal consequence.");
    }
}
