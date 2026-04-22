// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract FacilityRelocation {
    // [Goal: Manage the risks of permanent system migration]
    function initiateMigration(bool _isSaved) external pure returns (string memory) {
        if (!_isSaved) return "ABORT: Save your progress before permanent relocation.";
        return "SUCCESS: Relocating to Pailune. New facilities online.";
    }
}
