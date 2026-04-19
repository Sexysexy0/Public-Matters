// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TacticalLoadoutSentry {
    struct Loadout {
        uint8 longGuns;  // Max 2
        uint8 handguns;  // Max 2
        uint256 ammoCount;
    }

    // [USER REQUEST: "carry two long guns... and two handguns... along with limited ammo"]
    function validateInventory(uint8 _long, uint8 _hand, uint256 _ammo) public pure returns (string memory) {
        if (_long > 2 || _hand > 2 || _ammo > 500) {
            // "Doraemon Protocol Detected. Overload blocked."
            return "ERROR: Physical Capacity Exceeded. Store excess in vehicle trunk.";
        }
        return "SUCCESS: Tactical Loadout Verified. Mobility and Weight optimized.";
    }
}
