// JusticeDAO.sol
pragma solidity ^0.8.0;

contract JusticeDAO {
    struct Case {
        uint256 id;
        string subject;   // e.g. "Mary Jane Veloso"
        string issue;     // e.g. "Detention", "Human Trafficking Victim"
        uint256 votesFor;
        uint256 votesAgainst;
        bool resolved;
    }

    uint256 public caseCount;
    mapping(uint256 => Case) public cases;

    event CaseCreated(uint256 id, string subject, string issue);
    event CaseVoted(uint256 id, string subject, bool support);
    event CaseResolved(uint256 id, string subject);
    event JusticeDeclared(string message);

    function createCase(string memory subject, string memory issue) public {
        caseCount++;
        cases[caseCount] = Case(caseCount, subject, issue, 0, 0, false);
        emit CaseCreated(caseCount, subject, issue);
    }

    function voteCase(uint256 id, bool support) public {
        if (support) {
            cases[id].votesFor++;
        } else {
            cases[id].votesAgainst++;
        }
        emit CaseVoted(id, cases[id].subject, support);
    }

    function resolveCase(uint256 id) public {
        Case storage c = cases[id];
        require(!c.resolved, "Already resolved");
        require(c.votesFor > c.votesAgainst, "Not enough support");
        c.resolved = true;
        emit CaseResolved(c.id, c.subject);
    }

    function declareJustice() public {
        emit JusticeDeclared("Justice DAO: safeguard arcs encoded into communal consequence.");
    }
}
