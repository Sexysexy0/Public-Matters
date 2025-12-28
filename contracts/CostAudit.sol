// contracts/CostAudit.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title CostAudit
 * @notice Tracks healthcare costs and communal affordability audits.
 */
contract CostAudit {
    address public admin;

    struct Expense {
        string category;    // "Medicine", "Hospital", "InsurancePremium"
        uint256 amount;     // in local currency
        string status;      // "High", "Moderate", "Low"
        uint256 timestamp;
    }

    Expense[] public expenses;

    event ExpenseLogged(string category, uint256 amount, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logExpense(string calldata category, uint256 amount, string calldata status) external onlyAdmin {
        expenses.push(Expense(category, amount, status, block.timestamp));
        emit ExpenseLogged(category, amount, status, block.timestamp);
    }

    function totalExpenses() external view returns (uint256) { return expenses.length; }

    function getExpense(uint256 id) external view returns (Expense memory) {
        require(id < expenses.length, "Invalid id");
        return expenses[id];
    }
}
