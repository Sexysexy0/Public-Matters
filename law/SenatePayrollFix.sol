// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SenatePayrollFix {
    // [Goal: Enforce strict fiscal discipline on public servants]
    function calculatePay(bool _isPresent, uint256 _basePay) external pure returns (uint256) {
        if (!_isPresent) {
            return 0; // The "No Work, No Pay" Logic
        }
        return _basePay;
    }
}
