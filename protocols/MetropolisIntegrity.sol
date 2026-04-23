// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MetropolisIntegrity {
    // [Goal: Focus gameplay on the responsibility of a hero]
    uint256 public cityHealth = 100;

    function reportDestruction(uint256 _impactLevel) external {
        cityHealth -= _impactLevel; // If cityHealth reaches 0, MISSION FAILED.
    }
}
