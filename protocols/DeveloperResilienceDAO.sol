// DeveloperResilienceDAO.sol
pragma solidity ^0.8.0;

contract DeveloperResilienceDAO {
    struct Case {
        uint256 id;
        string role;   // e.g. "Junior Dev", "Senior Dev"
        string status; // e.g. "Empowered", "Shaken"
        uint256 votesFor;
        uint256 votesAgainst;
        bool resolved;
    }

    uint256 public caseCount;
    mapping(uint256 => Case) public cases;

    event CaseCreated(uint256 id, string role, string status);
    event CaseVoted(uint256 id, string role, bool support);
    event CaseResolved(uint256 id, string role);
    event DevDeclared(string message);

    function createCase(string memory role, string memory status) public {
        caseCount++;
        cases[caseCount] = Case(caseCount, role, status, 0, 0, false);
        emit CaseCreated(caseCount, role, status);
    }

    function voteCase(uint256 id, bool support) public {
        if (support) {
            cases[id].votesFor++;
        } else {
            cases[id].votesAgainst++;
        }
        emit CaseVoted(id, cases[id].role, support);
    }

    function resolveCase(uint256 id) public {
        Case storage c = cases[id];
        require(!c.resolved, "Already resolved");
        require(c.votesFor > c.votesAgainst, "Not enough support");
        c.resolved = true;
        emit CaseResolved(c.id, c.role);
    }

    function declareDev() public {
        emit DevDeclared("Developer Resilience DAO: safeguard arcs encoded into communal consequence.");
    }
}
