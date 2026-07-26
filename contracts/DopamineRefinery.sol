// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract DopamineRefinery is Ownable {

    constructor() Ownable(msg.sender) {}

    // [Goal: Extreme User Retention]
    function calculateLootDrop(uint256 _playerHours) external pure returns (string memory) {
        if (_playerHours > 40) {
            return "ULTRA_RARE_CHAMPION_BELT: You are hooked.";
        }
        return "NEW_WRESTLING_MOVE_UNLOCKED";
    }
}
