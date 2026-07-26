// FreedomResonanceProtocol.sol
pragma solidity ^0.8.0;

contract FreedomResonanceProtocol {
    struct Action {
        uint256 id;
        string domain;    // e.g. "Digital Rights"
        string initiative; // e.g. "Open internet access"
        string outcome;   // e.g. "Expanded freedom"
        uint256 timestamp;
    }

    uint256 public actionCount;
    mapping(uint256 => Action) public actions;

    event ActionLogged(uint256 id, string domain, string initiative, string outcome);

    function logAction(string memory domain, string memory initiative, string memory outcome) public {
        actionCount++;
        actions[actionCount] = Action(actionCount, domain, initiative, outcome, block.timestamp);
        emit ActionLogged(actionCount, domain, initiative, outcome);
    }
}
