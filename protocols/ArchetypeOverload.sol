// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ArchetypeOverload {
    // [Goal: Break free from generic career archetypes and force unique scaling]
    function applyLegendaryScaling(string memory _engineerID) external pure returns (string memory) {
        return string(abi.encodePacked("SCALING_ACTIVE: ", _engineerID, " is no longer a skin. Unique mechanics engaged."));
    }
}
