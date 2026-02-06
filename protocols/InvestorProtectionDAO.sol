// InvestorProtectionDAO.sol
pragma solidity ^0.8.0;

contract InvestorProtectionDAO {
    struct Case {
        uint256 id;
        string issue;   // e.g. "Fraud", "Market Manipulation"
        string resolution; // e.g. "Compensation", "Regulatory Action"
        uint256 votesFor;
        uint256 votesAgainst;
        bool resolved;
    }

    uint256 public caseCount;
    mapping(uint256 => Case) public cases;

    event CaseCreated(uint256 id, string issue, string resolution);
    event CaseVoted(uint256 id, string issue, bool support);
    event CaseResolved(uint256 id, string issue);
    event ProtectionDeclared(string message);

    function createCase(string memory issue, string memory resolution) public {
        caseCount++;
        cases[caseCount] = Case(caseCount, issue, resolution, 0, 0, false);
        emit CaseCreated(caseCount, issue, resolution);
    }

    function voteCase(uint256 id, bool support) public {
        if (support) {
            cases[id].votesFor++;
        } else {
            cases[id].votesAgainst++;
        }
        emit CaseVoted(id, cases[id].issue, support);
    }

    function resolveCase(uint256 id) public {
        Case storage c = cases[id];
        require(!c.resolved, "Already resolved");
        require(c.votesFor > c.votesAgainst, "Not enough support");
        c.resolved = true;
        emit CaseResolved(c.id, c.issue);
    }

    function declareProtection() public {
        emit ProtectionDeclared("Investor Protection DAO: safeguard arcs encoded into communal consequence.");
    }
}
