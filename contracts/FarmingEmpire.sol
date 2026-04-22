// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract FarmingEmpire {
    // [Goal: Transition from Mercenary to Landowner]
    function harvestResources(uint256 _landSize) external pure returns (uint256) {
        // Logic: More land + more workers = higher resource output.
        return _landSize * 50; 
    }
}
