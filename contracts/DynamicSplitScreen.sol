// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DynamicSplitScreen {
    // [Goal: Total Freedom of Movement]
    function toggleSplit(uint256 _distance) external pure returns (string memory) {
        if (_distance > 50) {
            return "SCREEN_SPLIT: Players are now independent.";
        }
        return "SCREEN_MERGE: Unified focus enabled.";
    }
}
