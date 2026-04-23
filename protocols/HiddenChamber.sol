// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract HiddenChamber {
    // [Goal: Reward players for surviving lethal traps]
    function discoverMysteryZone(bool _isTrapped) external pure returns (string memory) {
        if (_isTrapped) {
            return "DISCOVERY: You've found the Grotto of the First Admiral. Rare Blueprints located!";
        }
        return "LOCKED: This door requires an ancient key or a leap of faith.";
    }
}
