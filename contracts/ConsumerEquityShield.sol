// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ConsumerEquityShield {
    event EquitySeal(string game, uint256 discountRate, string status);

    function logDiscountDay(string memory game, uint256 discountRate) external {
        string memory status = discountRate >= 80 ? "Lucky Deep Discount" : "Standard Discount";
        emit EquitySeal(game, discountRate, status);
        // RULE: Discounts safeguarded for consumer affordability.
    }
}
