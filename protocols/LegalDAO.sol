// LegalDAO.sol
pragma solidity ^0.8.0;

contract LegalDAO {
    struct Clause {
        uint256 id;
        string domain;    // e.g. "Licensing"
        string detail;    // e.g. "MIT, Apache 2.0 compliance"
        uint256 votesFor;
        uint256 votesAgainst;
        bool ratified;
    }

    uint256 public clauseCount;
    mapping(uint256 => Clause) public clauses;

    event ClauseCreated(uint256 id, string domain, string detail);
    event ClauseVoted(uint256 id, string domain, bool support);
    event ClauseRatified(uint256 id, string domain);
    event LegalDeclared(string message);

    function createClause(string memory domain, string memory detail) public {
        clauseCount++;
        clauses[clauseCount] = Clause(clauseCount, domain, detail, 0, 0, false);
        emit ClauseCreated(clauseCount, domain, detail);
    }

    function voteClause(uint256 id, bool support) public {
        if (support) {
            clauses[id].votesFor++;
        } else {
            clauses[id].votesAgainst++;
        }
        emit ClauseVoted(id, clauses[id].domain, support);
    }

    function ratifyClause(uint256 id) public {
        Clause storage c = clauses[id];
        require(!c.ratified, "Already ratified");
        require(c.votesFor > c.votesAgainst, "Not enough support");
        c.ratified = true;
        emit ClauseRatified(c.id, c.domain);
    }

    function declareLegal() public {
        emit LegalDeclared("Legal DAO: safeguard arcs encoded into communal consequence.");
    }
}
