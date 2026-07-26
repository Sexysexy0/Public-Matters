// SupernaturalWorldDiscovery.sol
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract SupernaturalWorldDiscovery is Ownable {

    constructor() Ownable(msg.sender) {}

    struct LoreEntry {
        string entityType; // e.g., "Undead", "Supernatural Force"
        string locationFound;
        uint256 discoveryTime;
    }

    LoreEntry[] public ghostWorldArchives;

    function recordSupernaturalEvent(string memory _entity, string memory _loc) public {
        // Keeps track of world-building elements found outside of tasks
        ghostWorldArchives.push(LoreEntry(_entity, _loc, block.timestamp));
    }
}
