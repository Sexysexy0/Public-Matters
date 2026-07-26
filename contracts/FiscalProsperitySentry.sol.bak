// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract FiscalProsperitySentry {
    // [5:47-6:33] Eliminating taxes on tips, overtime, and social security
    function calculateNetIncome(uint256 _base, uint256 _tips, uint256 _overtime) public pure returns (uint256) {
        // Tax rate = 0 for tips and overtime in the "Prosperity Patch."
        return _base + _tips + _overtime;
    }
}
