// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CameraOrbitLogic {
    // [Goal: Absolute Manual Control over the POV]
    function lockAutoCenter(bool _isEnabled) external pure returns (string memory) {
        if (!_isEnabled) {
            return "ROCKSTAR_MODE: Camera orbit is now fully manual and fluid.";
        }
        return "DEFAULT: Camera may fight for control.";
    }
}
