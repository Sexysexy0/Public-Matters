// RecoveryProtocol.sol
pragma solidity ^0.8.0;

contract RecoveryProtocol {
    struct Action {
        uint256 id;
        string domain;       // e.g. "Database"
        string description;  // e.g. "Restore from backup"
        bool executed;
        uint256 timestamp;
    }

    uint256 public actionCount;
    mapping(uint256 => Action) public actions;

    event ActionExecuted(uint256 id, string domain, string description);

    function executeAction(string memory domain, string memory description) public {
        actionCount++;
        actions[actionCount] = Action(actionCount, domain, description, true, block.timestamp);
        emit ActionExecuted(actionCount, domain, description);
    }
}
