// DecisionAutonomy.sol
// Logic: Stopping the "Passing Up" Cycle
pragma solidity ^0.8.0;

contract DecisionAutonomy {
    struct AuthorityLevel {
        uint256 budgetLimit;
        bool canSignOff;
    }

    mapping(address => AuthorityLevel) public managerPermissions;

    function executeDecision(uint256 _cost) public view returns (string memory) {
        // Administrative Logic: Empowerment through limits.
        // If cost is within manager's limit, they MUST decide.
        if (_cost <= managerPermissions[msg.sender].budgetLimit) {
            return "DECISION OWNED: EXECUTION AUTHORIZED BY MANAGER";
        }
        return "ESCALATION REQUIRED: EXCEEDS LIMIT";
    }
}
