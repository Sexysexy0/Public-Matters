// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PauseMechanism {
    // [Goal: Allow solo players to pause the persistent world simulation]
    function togglePause(bool _isSolo, bool _isPaused) external pure returns (string memory) {
        if (_isSolo && _isPaused) {
            return "WORLD SUSPENDED: AI and Survival ticks paused.";
        }
        return "WORLD RUNNING: Real-time simulation active.";
    }
}
