// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AffordabilityEngine {
    // [Goal: Ensure Sovereign investments translate to lower costs for the people]
    uint256 public constant MAX_PROFIT_MARGIN = 10; // 10% limit for essentials

    function validatePricing(uint256 _cost, uint256 _price) external pure returns (bool) {
        uint256 margin = ((_price - _cost) * 100) / _cost;
        require(margin <= MAX_PROFIT_MARGIN, "ERROR: Price too high. Lower it for the people.");
        return true;
    }
}
