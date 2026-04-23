// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MapExpansion {
    // [Goal: Inject hand-crafted regions into the procedural world]
    function discoverNewSector(string memory _sectorName) external pure returns (string memory) {
        if (keccak256(abi.encodePacked(_sectorName)) == keccak256(abi.encodePacked("Puerto Rico"))) {
            return "LOCATION UNLOCKED: The Spanish Fortress and Tropical Coastline are now visible.";
        }
        return "VOYAGE: Sailing through uncharted waters...";
    }
}
