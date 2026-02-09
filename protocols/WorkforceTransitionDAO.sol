// WorkforceTransitionDAO.sol
pragma solidity ^0.8.0;

contract WorkforceTransitionDAO {
    struct Transition {
        uint256 id;
        string role;   // e.g. "Developer", "Analyst"
        string path;   // e.g. "Reskilled", "Displaced"
        uint256 votesFor;
        uint256 votesAgainst;
        bool resolved;
    }

    uint256 public transitionCount;
    mapping(uint256 => Transition) public transitions;

    event TransitionCreated(uint256 id, string role, string path);
    event TransitionVoted(uint256 id, string role, bool support);
    event TransitionResolved(uint256 id, string role);
    event WorkforceDeclared(string message);

    function createTransition(string memory role, string memory path) public {
        transitionCount++;
        transitions[transitionCount] = Transition(transitionCount, role, path, 0, 0, false);
        emit TransitionCreated(transitionCount, role, path);
    }

    function voteTransition(uint256 id, bool support) public {
        if (support) {
            transitions[id].votesFor++;
        } else {
            transitions[id].votesAgainst++;
        }
        emit TransitionVoted(id, transitions[id].role, support);
    }

    function resolveTransition(uint256 id) public {
        Transition storage t = transitions[id];
        require(!t.resolved, "Already resolved");
        require(t.votesFor > t.votesAgainst, "Not enough support");
        t.resolved = true;
        emit TransitionResolved(t.id, t.role);
    }

    function declareWorkforce() public {
        emit WorkforceDeclared("Workforce Transition DAO: safeguard arcs encoded into communal consequence.");
    }
}
