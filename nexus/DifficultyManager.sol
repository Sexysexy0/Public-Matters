// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DifficultyManager {
    enum Mode { EASY, NORMAL, HARD }
    
    function getCombatStats(Mode _mode) external pure returns (uint256 damageMult, uint256 iFrames) {
        if (_mode == Mode.EASY) return (75, 20);   // 75% enemy damage, 20 frames
        if (_mode == Mode.HARD) return (150, 10);  // 150% enemy damage, 10 frames
        return (100, 15);                          // Default Normal
    }
}
