// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SoloBalance {
    // [Goal: Adjust enemy scaling for solo adventurers]
    function scaleEnemies(uint256 _playerCount) external pure returns (uint256) {
        if (_playerCount == 1) {
            return 60; // 60% spawn rate and damage for solo players
        }
        return 100; // Standard scaling for groups
    }
}
