// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract LethalMechanisms {
    // [Goal: Implement traps that force players into new situations]
    function triggerTrap(string memory _trapType) external pure returns (string memory) {
        if (keccak256(abi.encodePacked(_trapType)) == keccak256(abi.encodePacked("SlidingFloor"))) {
            return "TRAP ACTIVATED: Floor collapsed! You are sliding into the darkness...";
        }
        return "SAFE: Watch your step, Captain.";
    }
}
