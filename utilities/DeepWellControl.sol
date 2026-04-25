// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DeepWellControl {
    // [Goal: Automated water extraction via solar-powered deep wells]
    bool public pumpActive;
    uint256 public tankLevel;

    function monitorTank(uint256 _level) external {
        tankLevel = _level;
        if (_level < 20) pumpActive = true; // Refill triggered
        if (_level > 95) pumpActive = false; // Reservoir full
    }
}
