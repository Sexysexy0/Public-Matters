// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DiscountEquityShield {
    event DiscountSeal(string game, uint256 originalPrice, uint256 discountRate, string status);

    function logDiscount(string memory game, uint256 originalPrice, uint256 discountRate) external {
        string memory status = discountRate >= 90 ? "Community Benefit" : "Standard Sale";
        emit DiscountSeal(game, originalPrice, discountRate, status);
        // RULE: Deep discounts safeguarded for consumer affordability.
    }
}
