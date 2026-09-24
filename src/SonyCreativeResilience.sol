// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

contract SonyCreativeResilience {
    address public boardExecutive;
    uint256 public budgetCap;

    event BudgetCapUpdated(uint256 newCap);

    constructor(address _boardExecutive, uint256 _initialBudgetCap) {
        require(_boardExecutive != address(0), "Board executive cannot be zero address");
        boardExecutive = _boardExecutive;
        budgetCap = _initialBudgetCap;
    }
}
