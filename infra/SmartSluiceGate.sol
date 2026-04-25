// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SmartSluiceGate {
    // [Goal: Automated activation of drainage gates based on flood levels]
    bool public gateOpen;

    function monitorFlood(uint256 _waterLevelCM) external {
        if (_waterLevelCM >= 10) gateOpen = true; // Intake active
        else gateOpen = false; // Standby
    }
}
