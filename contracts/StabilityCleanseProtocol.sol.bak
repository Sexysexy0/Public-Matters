// StabilityCleanseProtocol.sol
pragma solidity ^0.8.0;

contract StabilityCleanseProtocol {
    struct Action {
        uint256 id;
        string target;   // e.g. "Residual/Idle agents"
        string result;   // e.g. "Removed"
        uint256 timestamp;
    }

    uint256 public actionCount;
    mapping(uint256 => Action) public actions;

    event ActionLogged(uint256 id, string target, string result);

    function logAction(string memory target, string memory result) public {
        actionCount++;
        actions[actionCount] = Action(actionCount, target, result, block.timestamp);
        emit ActionLogged(actionCount, target, result);
    }
}
