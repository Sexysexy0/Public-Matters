// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BusinessExpenseAudit {
    // [Goal: Optimize financial deductions through legitimate corporate status]
    function calculateNetImpact(uint256 _grossIncome, uint256 _expenses) external pure returns (uint256) {
        // [Logic: Now allowed to subtract expenses from taxable income]
        return _grossIncome - _expenses;
    }
}
