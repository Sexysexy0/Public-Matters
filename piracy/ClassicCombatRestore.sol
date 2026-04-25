// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ClassicCombatRestore {
    // [Goal: Toggle between "Modernized" and "Classic" combat feel]
    function setCombatStyle(bool _isClassic) external pure returns (string memory) {
        if (_isClassic) {
            return "OVERRIDE: Fast-paced flashes disabled. Classic Counter-Kills active.";
        }
        return "MODE: Ubisoft Hybrid active.";
    }
}
