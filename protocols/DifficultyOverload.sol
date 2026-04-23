// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DifficultyOverload {
    bool public isHardMode = true;

    // [Goal: Enforce strict execution timing and high-stakes decision making]
    function executeAction() external view returns (string memory) {
        if (isHardMode) {
            return "HARD_MODE: Enemy health and aggression maximized. Healing is no longer instant. Finish the animation.";
        }
        return "NORMAL: Standard protocols.";
    }
}
