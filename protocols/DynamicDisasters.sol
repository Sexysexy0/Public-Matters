// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DynamicDisasters {
    // [Goal: Make the world feel urgent and alive]
    function spawnEvent(uint256 _timeOfDay) external pure returns (string memory) {
        if (_timeOfDay > 1800) { // Night-time events
            return "ALERT: Massive fire at the Daily Planet! Residents trapped.";
        }
        return "ALERT: High-speed chase on 5th Avenue.";
    }
}
