// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ObjectiveMorality {
    // [Goal: Ensure every choice has a weighted impact]
    function calculateImpact(bool _isGood) external pure returns (int256) {
        // Action: Reward growth, penalize failure. No ambiguity.
        return _isGood ? int256(100) : int256(-100);
    }
}
