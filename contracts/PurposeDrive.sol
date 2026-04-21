// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PurposeDrive {
    // [Goal: Strength through Internal Truth]
    function calculateWillpower(uint256 _hp, bool _isFightingForPurpose) public pure returns (uint256) {
        if (_isFightingForPurpose && _hp < 20) {
            return 100; // Anti-Hollow: Massive boost when critical.
        }
        return _hp;
    }
}
