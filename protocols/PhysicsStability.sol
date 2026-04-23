// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PhysicsStability {
    // [Goal: Correct abnormal physics behavior like flying or floating]
    function validatePhysics(uint256 _altitude, bool _isFlying) external pure returns (string memory) {
        if (_altitude > 500 && !_isFlying) {
            return "SYSTEM: Physics anomaly detected. Resetting character to ground.";
        }
        return "STABLE: Gravity behaving normally.";
    }
}
