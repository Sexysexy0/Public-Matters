// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BiomeVariety {
    // [Goal: Ensure every island visit feels unique and exciting]
    function generateBiome(uint256 _islandID) external pure returns (string memory) {
        if (_islandID % 5 == 0) return "BIOME: Mangrove Swamps - High density of exotic creatures.";
        return "BIOME: Tropical Beach - Ideal for base building.";
    }
}
