// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MeritocraticEngine {
    // [Goal: Validation through Real Adoption]
    function calculateTrueSuccess(uint256 _playerCount, uint256 _sales) external pure returns (bool) {
        // Logic: If players are growing, the game is a Masterpiece.
        return _playerCount > 0 && _sales >= 5_000_000;
    }
}
