pragma solidity ^0.8.20;

contract HouseholdBudgetProtocol {
    address public admin;

    struct Budget {
        string group;        // e.g. minimum wage earners
        string relief;       // e.g. cheaper goods, lower fares
        string impact;       // e.g. more disposable income
        uint256 timestamp;
    }

    Budget[] public budgets;

    event BudgetLogged(string group, string relief, string impact, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logBudget(string calldata group, string calldata relief, string calldata impact) external onlyAdmin {
        budgets.push(Budget(group, relief, impact, block.timestamp));
        emit BudgetLogged(group, relief, impact, block.timestamp);
    }

    function totalBudgets() external view returns (uint256) {
        return budgets.length;
    }
}
