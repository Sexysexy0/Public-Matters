// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ProtectorInstinct {
    // [Goal: Absolute Security for the Next Generation]
    function protectAsset(string memory _target, bool _isVulnerable) external pure returns (string memory) {
        if (_isVulnerable) {
            return string(abi.encodePacked("SHIELD_ACTIVE: Protecting ", _target, " against the world."));
        }
        return "STABLE: Mission ongoing.";
    }
}
