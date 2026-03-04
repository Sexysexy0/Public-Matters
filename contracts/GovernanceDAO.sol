// GovernanceDAO.sol
pragma solidity ^0.8.0;

contract GovernanceDAO {
    struct Decision {
        uint256 id;
        string policy;   // e.g. "Compliance Check"
        string detail;   // e.g. "Ensure licenses updated"
        bool approved;
    }

    uint256 public decisionCount;
    mapping(uint256 => Decision) public decisions;

    event DecisionLogged(uint256 id, string policy, string detail);
    event DecisionApproved(uint256 id, string policy);

    function logDecision(string memory policy, string memory detail) public {
        decisionCount++;
        decisions[decisionCount] = Decision(decisionCount, policy, detail, false);
        emit DecisionLogged(decisionCount, policy, detail);
    }

    function approveDecision(uint256 id) public {
        decisions[id].approved = true;
        emit DecisionApproved(id, decisions[id].policy);
    }
}
