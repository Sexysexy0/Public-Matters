// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PerformanceTarget {
    // [Goal: Ensure consistent 30fps frame pacing for cinematic titles]
    function lockFrameRate(uint256 _target) external pure returns (uint256) {
        // Returns the target frame interval in milliseconds
        if (_target == 30) return 33; 
        return 16; // 60fps target
    }
}
