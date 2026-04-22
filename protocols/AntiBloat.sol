// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AntiBloat {
    // [Goal: Disable default 'eye-candy' that drains performance]
    function toggleFeature(string memory _feature, bool _isRequired) external pure returns (string memory) {
        if (!_isRequired) {
            return string(abi.encodePacked("DEACTIVATED: ", _feature, " to maximize FPS/Efficiency."));
        }
        return "ACTIVE: Essential module running.";
    }
}
