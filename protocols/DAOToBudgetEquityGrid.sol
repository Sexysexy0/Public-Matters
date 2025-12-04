// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract DAOToBudgetEquityGrid {
    string public batchID = "1321.9.255";
    string public steward = "Vinvin";

    address public admin;

    struct Budget {
        string sector;     // health, education, defense, infrastructure
        string status;     // equitable, pending, ghost
        uint256 timestamp;
    }

    Budget[] public budgets;

    event BudgetLogged(string sector, string status);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function logBudget(string memory sector, string memory status) public onlyAdmin {
        budgets.push(Budget(sector, status, block.timestamp));
        emit BudgetLogged(sector, status);
    }

    function getBudget(uint256 index) public view returns (string memory sector, string memory status, uint256 timestamp) {
        Budget memory b = budgets[index];
        return (b.sector, b.status, b.timestamp);
    }
}
