// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PhysicsIsolator {
    // [Goal: Prevent mount physics from being affected by aeronautic lift]
    enum EntityType { MOUNT, AIRSHIP, PLAYER }

    function getGravityMultiplier(EntityType _type) external pure returns (uint256) {
        if (_type == EntityType.MOUNT) {
            return 100; // 100% Locked to ground gravity
        }
        if (_type == EntityType.AIRSHIP) {
            return 10;  // 10% Gravity for flight buoyancy
        }
        return 50; // Standard player gravity
    }
}
