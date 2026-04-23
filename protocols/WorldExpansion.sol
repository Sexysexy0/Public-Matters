// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract WorldExpansion {
    // [Goal: Manage the injection of new biomes and story arcs]
    function unlockNewRegion(uint256 _artifactLevel) external pure returns (string memory) {
        if (_artifactLevel >= 4) {
            return "DISCOVERY: New Biome detected on the horizon. Expansion active.";
        }
        return "PROGRESS: Continue the main story to unlock more islands.";
    }
}
