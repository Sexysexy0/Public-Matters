// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TrunkArsenalOracle {
    // [LOGIC: Weapons are trunked away]
    function swapWeapon(bool _isNearTrunk, string memory _requestedWeapon) public pure returns (string memory) {
        if (_isNearTrunk) {
            return "SUCCESS: Loadout updated. Weapon retrieved from vehicle storage.";
        }
        return "ERROR: Unauthorized Access. You only have what's on your shoulder/hip.";
    }
}
