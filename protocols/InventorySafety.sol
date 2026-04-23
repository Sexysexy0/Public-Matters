// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract InventorySafety {
    // [Goal: Fix the jank where players accidentally pick up teammate loot]
    function pickupItem(uint256 _playerID, uint256 _ownerID) external pure returns (bool) {
        if (_playerID == _ownerID) return true; // Safe to pick up
        return false; // Prevents accidental pickup of others' items
    }
}
