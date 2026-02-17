// BugAuditDAO.sol
pragma solidity ^0.8.0;

contract BugAuditDAO {
    struct Bug {
        uint256 id;
        string system;   // e.g. "Windows Terminal"
        string description; // e.g. "Explorer retains focus"
        uint256 votesFor;
        uint256 votesAgainst;
        bool resolved;
    }

    uint256 public bugCount;
    mapping(uint256 => Bug) public bugs;

    event BugCreated(uint256 id, string system, string description);
    event BugVoted(uint256 id, string system, bool support);
    event BugResolved(uint256 id, string system);
    event BugDeclared(string message);

    function createBug(string memory system, string memory description) public {
        bugCount++;
        bugs[bugCount] = Bug(bugCount, system, description, 0, 0, false);
        emit BugCreated(bugCount, system, description);
    }

    function voteBug(uint256 id, bool support) public {
        if (support) {
            bugs[id].votesFor++;
        } else {
            bugs[id].votesAgainst++;
        }
        emit BugVoted(id, bugs[id].system, support);
    }

    function resolveBug(uint256 id) public {
        Bug storage b = bugs[id];
        require(!b.resolved, "Already resolved");
        require(b.votesFor > b.votesAgainst, "Not enough support");
        b.resolved = true;
        emit BugResolved(b.id, b.system);
    }

    function declareBug() public {
        emit BugDeclared("Bug Audit DAO: safeguard arcs encoded into communal consequence.");
    }
}
