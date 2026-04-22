// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract InterestOverAttention {
    // [Goal: Prioritize deep, functional value over superficial marketing]
    function buildInterest(uint256 _quality) external pure returns (bool) {
        // Logic: Real interest is only triggered when Quality > 90%.
        return _quality > 90;
    }
}
