// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract NuancedSpeedController {
    // [12:21-13:40] User-defined percentage-based speed offset
    function calculateTargetSpeed(uint256 _limit, uint256 _percentOffset) public pure returns (uint256) {
        // Logic: Flexibility for school zones vs highways.
        return _limit + (_limit * _percentOffset / 100);
    }
}
