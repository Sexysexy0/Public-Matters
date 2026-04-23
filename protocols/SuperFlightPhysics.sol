// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SuperFlightPhysics {
    // [Goal: Deliver the sensation of breaking the sound barrier]
    function toggleSuperSpeed(bool _isBoosting) external pure returns (string memory) {
        if (_isBoosting) {
            return "PHYSICS: Breaking Mach 5. Motion blur maxed. Sonic boom triggered.";
        }
        return "PHYSICS: Cruising altitude. City-wide scanning active.";
    }
}
