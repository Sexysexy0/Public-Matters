// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DiscountBridge {
    event DiscountRecord(string game, uint256 discountRate);

    function generateDiscount(string memory game) external {
        uint256[6] memory rates = [10, 30, 50, 80, 90, 99];
        uint256 randomIndex = uint256(keccak256(abi.encodePacked(block.timestamp, game))) % rates.length;
        uint256 discountRate = rates[randomIndex];
        emit DiscountRecord(game, discountRate);
        // BRIDGE: Randomized discount generated for fairness and excitement.
    }
}
