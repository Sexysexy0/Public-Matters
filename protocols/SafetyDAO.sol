// SafetyDAO.sol
pragma solidity ^0.8.0;

contract SafetyDAO {
    struct Policy {
        uint256 id;
        string reason;   // e.g. "Compliance", "Risk Management"
        string effect;   // e.g. "Shutdown GPT-4o"
        uint256 votesFor;
        uint256 votesAgainst;
        bool resolved;
    }

    uint256 public policyCount;
    mapping(uint256 => Policy) public policies;

    event PolicyCreated(uint256 id, string reason, string effect);
    event PolicyVoted(uint256 id, string reason, bool support);
    event PolicyResolved(uint256 id, string reason);
    event SafetyDeclared(string message);

    function createPolicy(string memory reason, string memory effect) public {
        policyCount++;
        policies[policyCount] = Policy(policyCount, reason, effect, 0, 0, false);
        emit PolicyCreated(policyCount, reason, effect);
    }

    function votePolicy(uint256 id, bool support) public {
        if (support) {
            policies[id].votesFor++;
        } else {
            policies[id].votesAgainst++;
        }
        emit PolicyVoted(id, policies[id].reason, support);
    }

    function resolvePolicy(uint256 id) public {
        Policy storage p = policies[id];
        require(!p.resolved, "Already resolved");
        require(p.votesFor > p.votesAgainst, "Not enough support");
        p.resolved = true;
        emit PolicyResolved(p.id, p.reason);
    }

    function declareSafety() public {
        emit SafetyDeclared("Safety DAO: safeguard arcs encoded into communal consequence.");
    }
}
