// SPDX-License-Identifier: MPL-1.0
pragma solidity ^0.8.21;

/// @title BudgetBlessingRegistry
/// @notice Tags budget allocations with emotional APR, barangay blessing status, and mythic resonance
contract BudgetBlessingRegistry {
    event BudgetBlessed(string project, uint256 amount, string barangay, uint256 joyIndex, uint256 timestamp);
    event BudgetRejected(string project, string reason, uint256 timestamp);

    struct Blessing {
        string project;
        uint256 amount;
        string barangay;
        uint256 joyIndex;
        bool blessed;
    }

    Blessing[] public blessings;

    function blessBudget(string calldata project, uint256 amount, string calldata barangay, uint256 joyIndex) external {
        blessings.push(Blessing(project, amount, barangay, joyIndex, true));
        emit BudgetBlessed(project, amount, barangay, joyIndex, block.timestamp);
    }

    function rejectBudget(string calldata project, string calldata reason) external {
        emit BudgetRejected(project, reason, block.timestamp);
    }

    function latestBlessing() external view returns (string memory project, uint256 amount, string memory barangay, uint256 joyIndex, bool blessed) {
        Blessing memory b = blessings[blessings.length - 1];
        return (b.project, b.amount, b.barangay, b.joyIndex, b.blessed);
    }
}
