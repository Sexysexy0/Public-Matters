// LegalActionDAO.sol
pragma solidity ^0.8.0;

contract LegalActionDAO {
    struct Case {
        uint256 id;
        string party;   // e.g. "Customer", "Exchange"
        string action;  // e.g. "Restitution", "Litigation"
        uint256 votesFor;
        uint256 votesAgainst;
        bool resolved;
    }

    uint256 public caseCount;
    mapping(uint256 => Case) public cases;

    event CaseCreated(uint256 id, string party, string action);
    event CaseVoted(uint256 id, string party, bool support);
    event CaseResolved(uint256 id, string party);
    event LegalDeclared(string message);

    function createCase(string memory party, string memory action) public {
        caseCount++;
        cases[caseCount] = Case(caseCount, party, action, 0, 0, false);
        emit CaseCreated(caseCount, party, action);
    }

    function voteCase(uint256 id, bool support) public {
        if (support) {
            cases[id].votesFor++;
        } else {
            cases[id].votesAgainst++;
        }
        emit CaseVoted(id, cases[id].party, support);
    }

    function resolveCase(uint256 id) public {
        Case storage c = cases[id];
        require(!c.resolved, "Already resolved");
        require(c.votesFor > c.votesAgainst, "Not enough support");
        c.resolved = true;
        emit CaseResolved(c.id, c.party);
    }

    function declareLegal() public {
        emit LegalDeclared("Legal Action DAO: safeguard arcs encoded into communal consequence.");
    }
}
