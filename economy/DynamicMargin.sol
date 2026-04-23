// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DynamicMargin {
    // [Goal: Prevent players from over-leveraging their in-game assets]
    function calculateRequiredMargin(uint256 _tradeSize, uint256 _volatility) external pure returns (uint256) {
        // Higher trade size = exponentially higher margin requirement
        uint256 baseMargin = (_tradeSize * 20) / 100; // Start at 20%
        if (_tradeSize > 1000000) {
            return baseMargin * 2; // Double the margin for whale trades
        }
        return baseMargin;
    }
}
