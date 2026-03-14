// AccountabilityProtocol.sol
pragma solidity ^0.8.0;

contract AccountabilityProtocol {
    struct Action {
        uint256 id;
        string safeguard;  // e.g. "Frame news as context, not panic"
        string mechanism;  // e.g. "Team briefing with risk matrix"
        uint256 timestamp;
    }

    uint256 public actionCount;
    mapping(uint256 => Action) public actions;

    event ActionLogged(uint256 id, string safeguard, string mechanism);

    function logAction(string memory safeguard, string memory mechanism) public {
        actionCount++;
        actions[actionCount] = Action(actionCount, safeguard, mechanism, block.timestamp);
        emit ActionLogged(actionCount, safeguard, mechanism);
    }
}
