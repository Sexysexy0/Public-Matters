// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ElementalBending {
    // [Goal: Add elemental variety to combat and exploration]
    function castElement(string memory _element) external pure returns (string memory) {
        if (keccak256(abi.encodePacked(_element)) == keccak256(abi.encodePacked("Lightning"))) {
            return "SKILL: Chain Lightning engaged. High damage to wet targets!";
        }
        return "SKILL: Basic elemental manipulation active.";
    }
}
