// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract GameRatingMatrix {
    // [Goal: Objective Quality Assessment]
    function calculateRating(uint256 _hoursPlayed, uint256 _bugsFixed) external pure returns (string memory) {
        if (_hoursPlayed > 100 && _bugsFixed > 0) {
            return "MASTERPIECE: Generational success confirmed.";
        }
        return "LIABILITY: High risk of corporate collapse.";
    }
}
