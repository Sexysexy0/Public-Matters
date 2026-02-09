// HumanAdaptationDAO.sol
pragma solidity ^0.8.0;

contract HumanAdaptationDAO {
    struct Adaptation {
        uint256 id;
        string role;   // e.g. "Developer", "Manager"
        string path;   // e.g. "Reskilled", "Reoriented"
        uint256 votesFor;
        uint256 votesAgainst;
        bool resolved;
    }

    uint256 public adaptationCount;
    mapping(uint256 => Adaptation) public adaptations;

    event AdaptationCreated(uint256 id, string role, string path);
    event AdaptationVoted(uint256 id, string role, bool support);
    event AdaptationResolved(uint256 id, string role);
    event HumanDeclared(string message);

    function createAdaptation(string memory role, string memory path) public {
        adaptationCount++;
        adaptations[adaptationCount] = Adaptation(adaptationCount, role, path, 0, 0, false);
        emit AdaptationCreated(adaptationCount, role, path);
    }

    function voteAdaptation(uint256 id, bool support) public {
        if (support) {
            adaptations[id].votesFor++;
        } else {
            adaptations[id].votesAgainst++;
        }
        emit AdaptationVoted(id, adaptations[id].role, support);
    }

    function resolveAdaptation(uint256 id) public {
        Adaptation storage a = adaptations[id];
        require(!a.resolved, "Already resolved");
        require(a.votesFor > a.votesAgainst, "Not enough support");
        a.resolved = true;
        emit AdaptationResolved(a.id, a.role);
    }

    function declareHuman() public {
        emit HumanDeclared("Human Adaptation DAO: safeguard arcs encoded into communal consequence.");
    }
}
