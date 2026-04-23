// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BiomeScaling {
    // [Goal: Adjust world difficulty based on player distance/biome]
    function getEnemyTier(uint256 _distanceFromHub) external pure returns (string memory) {
        if (_distanceFromHub > 5000) return "LEGENDARY: High-tier resources found.";
        return "NOVICE: Safe waters.";
    }
}
