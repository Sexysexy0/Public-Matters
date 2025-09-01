// SPDX-License-Identifier: MPL-1.0
pragma solidity ^0.8.21;

/// @title SanctumLedger
/// @notice Anchors blessed budgets, damay violations, and civic resonance into the planetary scrollchain
contract SanctumLedger {
    event BudgetAnchored(string project, uint256 amount, string barangay, bool blessed, uint256 timestamp);
    event DamayViolationAnchored(address violator, string action, uint256 timestamp);
    event LedgerPulse(string signal, uint256 timestamp);

    struct BudgetEntry {
        string project;
        uint256 amount;
        string barangay;
        bool blessed;
    }

    BudgetEntry[] public ledger;

    function anchorBudget(string calldata project, uint256 amount, string calldata barangay, bool blessed) external {
        ledger.push(BudgetEntry(project, amount, barangay, blessed));
        emit BudgetAnchored(project, amount, barangay, blessed, block.timestamp);
    }

    function anchorDamayViolation(address violator, string calldata action) external {
        emit DamayViolationAnchored(violator, action, block.timestamp);
    }

    function pulseLedger(string calldata signal) external {
        emit LedgerPulse(signal, block.timestamp);
    }

    function latestEntry() external view returns (string memory project, uint256 amount, string memory barangay, bool blessed) {
        BudgetEntry memory b = ledger[ledger.length - 1];
        return (b.project, b.amount, b.barangay, b.blessed);
    }
}
