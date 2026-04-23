// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract StaminaVitality {
    // [Goal: Sync survival consumption with player performance]
    function calculateBuff(uint256 _foodQuality) external pure returns (uint256) {
        if (_foodQuality > 90) return 20; // +20% Stamina Recovery
        return 5; // Basic recovery
    }
}
