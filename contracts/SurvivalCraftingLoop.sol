// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract SurvivalCraftingLoop is Ownable {

    constructor() Ownable(msg.sender) {}

    uint256 public gunpowderStockpile;

    // [Goal: Never Run Dry]
    function lootResources(uint256 _amount) external {
        gunpowderStockpile += _amount;
        // Action: Build a 'Black Box' of resources for the 2nd biome (Future).
    }
}
