// ResiliencePathDAO.sol
pragma solidity ^0.8.0;

contract ResiliencePathDAO {
    struct Path {
        uint256 id;
        string challenge;   // e.g. "Market Crash", "Job Loss"
        string response;    // e.g. "Adaptation", "Recovery"
        uint256 votesFor;
        uint256 votesAgainst;
        bool resolved;
    }

    uint256 public pathCount;
    mapping(uint256 => Path) public paths;

    event PathCreated(uint256 id, string challenge, string response);
    event PathVoted(uint256 id, string challenge, bool support);
    event PathResolved(uint256 id, string challenge);
    event ResilienceDeclared(string message);

    function createPath(string memory challenge, string memory response) public {
        pathCount++;
        paths[pathCount] = Path(pathCount, challenge, response, 0, 0, false);
        emit PathCreated(pathCount, challenge, response);
    }

    function votePath(uint256 id, bool support) public {
        if (support) {
            paths[id].votesFor++;
        } else {
            paths[id].votesAgainst++;
        }
        emit PathVoted(id, paths[id].challenge, support);
    }

    function resolvePath(uint256 id) public {
        Path storage p = paths[id];
        require(!p.resolved, "Already resolved");
        require(p.votesFor > p.votesAgainst, "Not enough support");
        p.resolved = true;
        emit PathResolved(p.id, p.challenge);
    }

    function declareResilience() public {
        emit ResilienceDeclared("Resilience Path DAO: safeguard arcs encoded into communal consequence.");
    }
}
