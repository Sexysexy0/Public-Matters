// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BoardingInitiator {
    // [Goal: Reward preparation before naval boarding]
    function checkReadiness(uint256 _foodLevel, bool _hasRangedWeapon) external pure returns (string memory) {
        if (_foodLevel > 80 && _hasRangedWeapon) {
            return "READY: Strategic advantage active. Boarding authorized.";
        }
        return "WARNING: Low supplies. High risk of failure.";
    }
}
