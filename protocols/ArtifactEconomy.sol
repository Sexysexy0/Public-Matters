// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ArtifactEconomy {
    // [Goal: Prevent upgrade fatigue by balancing artifact requirements]
    function getUpgradeCost(uint256 _currentLevel) external pure returns (uint256) {
        if (_currentLevel < 5) return 5; // Early game cheap costs
        return 20 + (_currentLevel * 2); // Gradual scaling for late game
    }
}
