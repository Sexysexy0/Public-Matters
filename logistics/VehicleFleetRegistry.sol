// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TollDiscountOracle {
    uint256 public constant SUBSIDY_RATE = 80; // 80% Discount

    function calculateToll(uint256 _baseRate, bool _isWorker) external pure returns (uint256) {
        if (_isWorker) {
            return (_baseRate * (100 - SUBSIDY_RATE)) / 100; // Worker pays only 20%
        }
        return _baseRate;
    }
}
