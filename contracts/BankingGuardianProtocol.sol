pragma solidity ^0.8.20;

contract BankingGuardianProtocol {
    address public admin;

    struct GuardianAction {
        string role;         // e.g. stabilize system, protect deposits
        string outcome;      // e.g. resilience, trust, security
        uint256 timestamp;
    }

    GuardianAction[] public actions;

    event GuardianActionLogged(string role, string outcome, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logAction(string calldata role, string calldata outcome) external onlyAdmin {
        actions.push(GuardianAction(role, outcome, block.timestamp));
        emit GuardianActionLogged(role, outcome, block.timestamp);
    }

    function totalActions() external view returns (uint256) {
        return actions.length;
    }
}
