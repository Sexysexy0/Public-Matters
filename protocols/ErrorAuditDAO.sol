// ErrorAuditDAO.sol
pragma solidity ^0.8.0;

contract ErrorAuditDAO {
    struct Error {
        uint256 id;
        string system;   // e.g. "Explorer Context Menu"
        string description; // e.g. "Focus not applied"
        uint256 votesFor;
        uint256 votesAgainst;
        bool resolved;
    }

    uint256 public errorCount;
    mapping(uint256 => Error) public errors;

    event ErrorCreated(uint256 id, string system, string description);
    event ErrorVoted(uint256 id, string system, bool support);
    event ErrorResolved(uint256 id, string system);
    event ErrorDeclared(string message);

    function createError(string memory system, string memory description) public {
        errorCount++;
        errors[errorCount] = Error(errorCount, system, description, 0, 0, false);
        emit ErrorCreated(errorCount, system, description);
    }

    function voteError(uint256 id, bool support) public {
        if (support) {
            errors[id].votesFor++;
        } else {
            errors[id].votesAgainst++;
        }
        emit ErrorVoted(id, errors[id].system, support);
    }

    function resolveError(uint256 id) public {
        Error storage e = errors[id];
        require(!e.resolved, "Already resolved");
        require(e.votesFor > e.votesAgainst, "Not enough support");
        e.resolved = true;
        emit ErrorResolved(e.id, e.system);
    }

    function declareError() public {
        emit ErrorDeclared("Error Audit DAO: safeguard arcs encoded into communal consequence.");
    }
}
