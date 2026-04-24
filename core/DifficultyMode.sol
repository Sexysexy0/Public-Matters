// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DifficultyMode {
    // [Goal: Provide a flexible life-experience for all tiers of citizens]
    enum Mode { Easy, Normal, Hard, Sovereign }
    Mode public currentSetting = Mode.Normal;

    function setPerspective(Mode _newMode) external {
        currentSetting = _newMode;
    }
}
