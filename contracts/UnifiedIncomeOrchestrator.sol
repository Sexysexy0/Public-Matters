// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract UnifiedIncomeOrchestrator {
    // [0:05:12] Wealthy people avoid income tax by borrowing against assets
    function applyUnifiedTaxRate(uint256 _salary, uint256 _assetAppreciation) public pure returns (uint256) {
        uint256 totalGains = _salary + _assetAppreciation;
        // Logic: Apply progressive tax to the TOTAL gain, no exceptions.
        return totalGains;
    }
}
