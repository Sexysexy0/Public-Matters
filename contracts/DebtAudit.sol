// contracts/DebtAudit.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title DebtAudit
 * @notice Tracks communal debt levels and fairness in repayment systems.
 */
contract DebtAudit {
    address public admin;

    struct Debt {
        string debtor;      // "Household", "Business"
        uint256 amount;
        string verdict;     // "Manageable", "Critical"
        uint256 timestamp;
    }

    Debt[] public debts;

    event DebtLogged(string debtor, uint256 amount, string verdict, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logDebt(string calldata debtor, uint256 amount, string calldata verdict) external onlyAdmin {
        debts.push(Debt(debtor, amount, verdict, block.timestamp));
        emit DebtLogged(debtor, amount, verdict, block.timestamp);
    }

    function totalDebts() external view returns (uint256) { return debts.length; }

    function getDebt(uint256 id) external view returns (Debt memory) {
        require(id < debts.length, "Invalid id");
        return debts[id];
    }
}
