// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract HuntingHarpoon {
    // [Goal: Implement resource gathering from marine giants]
    function harvestWildlife(string memory _target) external pure returns (uint256) {
        if (keccak256(abi.encodePacked(_target)) == keccak256(abi.encodePacked("Whale"))) {
            return 500; // High-tier Oil/Meat yield
        }
        return 50; // Standard fish yield
    }
}
