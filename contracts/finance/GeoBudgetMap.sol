// SPDX-License-Identifier: MIT  
pragma solidity ^0.8.19;

/// @title GeoBudgetMap
/// @notice Maps NEP allocations to geographic and emotional telemetry

contract GeoBudgetMap {
    struct BudgetEntry {
        string region;
        string barangay;
        string project;
        uint256 amount;
        uint256 emotionalAPR;
        address treasuryHolder;
        bool blessed;
    }

    BudgetEntry[] public entries;

    event BudgetMapped(string region, string barangay, string project, uint256 amount, uint256 emotionalAPR, address treasuryHolder, bool blessed);

    function mapBudget(
        string memory region,
        string memory barangay,
        string memory project,
        uint256 amount,
        uint256 apr,
        address treasury,
        bool blessed
    ) external {
        entries.push(BudgetEntry(region, barangay, project, amount, apr, treasury, blessed));
        emit BudgetMapped(region, barangay, project, amount, apr, treasury, blessed);
    }

    function getAllEntries() external view returns (BudgetEntry[] memory) {
        return entries;
    }
}
