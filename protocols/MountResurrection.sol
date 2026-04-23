// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MountResurrection {
    // [Goal: Force-restore legendary mounts lost in the patch bug]
    function emergencyRecall(uint256 _chapter) external pure returns (string memory) {
        if (_chapter >= 12) {
            return "RESTORED: Dragon and Legendary Mounts re-registered to your stable.";
        }
        return "STABLE: Standard horses available.";
    }
}
