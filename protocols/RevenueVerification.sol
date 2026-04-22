// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract RevenueVerification {
    // [Goal: Prevent deficit spending in personal development]
    function hasExcess(uint256 _currentRevenue, uint256 _projectedCost) external pure returns (bool) {
        return _currentRevenue > _projectedCost;
    }
}
