// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract NemesisMercenaries {
    // [Goal: Create emergent combat encounters with elite hunters]
    function spawnHunter(uint256 _playerFame) external pure returns (string memory) {
        if (_playerFame > 5000) {
            return "DANGER: An Elite Mercenary has picked up your scent. Prepare for a duel!";
        }
        return "PEACE: No active bounties on your head.";
    }
}
