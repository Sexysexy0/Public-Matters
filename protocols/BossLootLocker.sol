// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BossLootLocker {
    // [Goal: Manage boss drops to ensure game progression]
    function claimLoot(bool _bossDefeated, uint256 _luckFactor) external pure returns (string memory) {
        require(_bossDefeated, "ERROR: Boss is still standing.");
        if (_luckFactor > 95) return "EPIC: Rare Ship Skin Unlocked!";
        return "SUCCESS: Crafting Materials Received.";
    }
}
