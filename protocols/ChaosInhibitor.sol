// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ChaosInhibitor {
    // [Goal: Add consequences to chaotic player behavior]
    function registerShenanigans(uint256 _chaosCount) external pure returns (string memory) {
        if (_chaosCount > 10) {
            return "BOUNTY: You are now wanted for disturbing the peace!";
        }
        return "OBSERVE: The townspeople are watching you suspiciously.";
    }
}
