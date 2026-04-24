// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract InventoryOverhaul {
    // [Goal: Organize global resources into 'Sturdy Chests']
    function groupResources(string memory _category, uint256 _count) external pure returns (string memory) {
        return string(abi.encodePacked("ORGANIZED: ", _category, " grouped for maximum efficiency."));
    }
}
