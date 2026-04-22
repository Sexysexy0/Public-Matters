// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BossIntegrity {
    // [Goal: Prevent the 'One-Hit-Kill' Boredom]
    function buffBoss(uint256 _architectPower) external pure returns (uint256) {
        // Logic: The stronger you get, the more complex the problems become.
        return _architectPower * 1.5; 
    }
}
