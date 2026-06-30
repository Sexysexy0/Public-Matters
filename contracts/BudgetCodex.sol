// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BudgetCodex {
    address public overseer;
    uint256 public budgetCount;

    struct BudgetRule {
        uint256 id;
        string principle; // Resource Allocation, Anti-Waste, Financial Integrity, Sustainability
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => BudgetRule) public budgets;

    event BudgetLogged(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logBudget(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        budgetCount++;
        budgets[budgetCount] = BudgetRule({
            id: budgetCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit BudgetLogged(budgetCount, principle, description);
    }

    function viewBudget(uint256 id) external view returns (BudgetRule memory) {
        return budgets[id];
    }
}
