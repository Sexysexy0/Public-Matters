// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TortugaTradeEngine {
    // [Goal: Manage trading and player interactions in hub islands]
    function getPrice(string memory _resource, string memory _originBiome) external pure returns (uint256) {
        if (keccak256(abi.encodePacked(_originBiome)) != keccak256(abi.encodePacked("Tortuga"))) {
            return 500; // Rare/Imported price
        }
        return 100; // Local price
    }
}
