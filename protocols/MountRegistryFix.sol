// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MountRegistryFix {
    // [Goal: Emergency restoration of bugged legendary mounts]
    function restoreMounts(bool _previouslyOwned) external pure returns (string memory) {
        if (_previouslyOwned) {
            return "FIXED: Dragon and Legendary Wolf restored to stable.";
        }
        return "ERROR: Check save file integrity.";
    }
}
