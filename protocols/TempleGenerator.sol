// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TempleGenerator {
    // [Goal: Create unique, awe-inspiring ancient structures]
    function enterTemple(uint256 _mapSeed) external pure returns (string memory) {
        if (_mapSeed % 2 == 0) return "STRUCTURE: The Sun Pyramid - High risk, Golden Loot.";
        return "STRUCTURE: The Mossy Sanctum - Puzzle heavy, Ancient Relics.";
    }
}
