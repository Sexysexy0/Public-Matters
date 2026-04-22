// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract InstantApprehension {
    // [Goal: Streamline the Bounty Capture Process]
    function captureTarget(bool _isTackled) external pure returns (string memory) {
        if (_isTackled) {
            return "INSTANT_CUFF: Redundant violence bypassed. Target secured.";
        }
        return "WAITING: Approach target for tackle.";
    }
}
