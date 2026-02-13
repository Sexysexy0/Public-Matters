// IPProtectionDAO.sol
pragma solidity ^0.8.0;

contract IPProtectionDAO {
    struct Case {
        uint256 id;
        string violation; // e.g. "Model Replication", "Unauthorized Distillation"
        string status;    // e.g. "Pending", "Resolved"
        uint256 votesFor;
        uint256 votesAgainst;
        bool resolved;
    }

    uint256 public caseCount;
    mapping(uint256 => Case) public cases;

    event CaseCreated(uint256 id, string violation, string status);
    event CaseVoted(uint256 id, string violation, bool support);
    event CaseResolved(uint256 id, string violation);
    event IPDeclared(string message);

    function createCase(string memory violation, string memory status) public {
        caseCount++;
        cases[caseCount] = Case(caseCount, violation, status, 0, 0, false);
        emit CaseCreated(caseCount, violation, status);
    }

    function voteCase(uint256 id, bool support) public {
        if (support) {
            cases[id].votesFor++;
        } else {
            cases[id].votesAgainst++;
        }
        emit CaseVoted(id, cases[id].violation, support);
    }

    function resolveCase(uint256 id) public {
        Case storage c = cases[id];
        require(!c.resolved, "Already resolved");
        require(c.votesFor > c.votesAgainst, "Not enough support");
        c.resolved = true;
        emit CaseResolved(c.id, c.violation);
    }

    function declareIP() public {
        emit IPDeclared("IP Protection DAO: safeguard arcs encoded into communal consequence.");
    }
}
