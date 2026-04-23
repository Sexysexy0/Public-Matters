// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract VillainLogic {
    // [Goal: Challenge the player's brain, not just their brawn]
    function applyKryptoniteEffect(uint256 _distance) external pure returns (uint256) {
        if (_distance < 10) {
            return 50; // 50% strength reduction when close to Kryptonite
        }
        return 0; // Full strength restored
    }
}
