// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract UnboxedProductionLogic is Ownable {

    constructor() Ownable(msg.sender) {}

    // [3:00-4:26] Maximizing efficiency for the budget segment
    function calculateProductionCost(uint256 _traditionalCost) public pure returns (uint256) {
        // Unboxed method targets a 40-50% reduction in assembly footprint and cost
        uint256 unboxedSavings = (_traditionalCost * 40) / 100;
        return _traditionalCost - unboxedSavings;
    }
}
