// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract DifficultyEngine is Ownable {

    constructor() Ownable(msg.sender) {}

    enum Tier { EASY, NORMAL, HARD }
    Tier public currentTier;

    // [Goal: Cater to both Casuals and Hardcore Combatants]
    function setDifficulty(Tier _tier) external {
        currentTier = _tier;
        // Action: Scale enemy health and AI response times.
    }
}
