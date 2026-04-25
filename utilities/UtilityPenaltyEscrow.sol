// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract UtilityPenaltyEscrow {
    // [Goal: Automatic rebates for service failure]
    function processRebate(uint256 _daysWithoutWater) external pure returns (uint256) {
        if (_daysWithoutWater >= 21) { // 3 weeks
            return 100; // 100% Discount on next bill
        }
        return 0;
    }
}
