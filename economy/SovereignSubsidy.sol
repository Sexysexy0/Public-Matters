// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SovereignSubsidy {
    // [Goal: Use the Architect's wealth to shield the public from inflation]
    function applySubsidy(uint256 _marketPrice) external pure returns (uint256) {
        uint256 discountedPrice = (_marketPrice * 70) / 100; // 30% Sovereign Discount
        return discountedPrice;
    }
}
