// LeadershipAccountabilityProtocol.sol
pragma solidity ^0.8.0;

contract LeadershipAccountabilityProtocol {
    struct Action {
        uint256 id;
        string leader;     // e.g. "Senior Deputy Minority Leader"
        string decision;   // e.g. "Removed due to dissent"
        uint256 timestamp;
    }

    uint256 public actionCount;
    mapping(uint256 => Action) public actions;

    event ActionLogged(uint256 id, string leader, string decision);

    function logAction(string memory leader, string memory decision) public {
        actionCount++;
        actions[actionCount] = Action(actionCount, leader, decision, block.timestamp);
        emit ActionLogged(actionCount, leader, decision);
    }
}
