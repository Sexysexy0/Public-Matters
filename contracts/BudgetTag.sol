// contracts/BudgetTag.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BudgetTag {
    struct Budget {
        string project;
        uint256 amount;
        uint256 timestamp;
    }

    Budget[] public budgets;
    event BudgetTagged(string project, uint256 amount, uint256 timestamp);

    function tagBudget(string calldata project, uint256 amount) external {
        budgets.push(Budget(project, amount, block.timestamp));
        emit BudgetTagged(project, amount, block.timestamp);
    }

    function totalBudgets() external view returns (uint256) {
        return budgets.length;
    }
}
