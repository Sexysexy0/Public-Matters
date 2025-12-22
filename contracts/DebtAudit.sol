// contracts/DebtAudit.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title DebtAudit
 * @notice Communal audit of debt levels and repayment protocols.
 */
contract DebtAudit {
    address public admin;

    struct Debt {
        string entity;
        uint256 amount;
        string status;   // "Active", "Settled", "Default"
        uint256 timestamp;
    }

    Debt[] public debts;

    event DebtLogged(string entity, uint256 amount, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logDebt(string calldata entity, uint256 amount, string calldata status) external onlyAdmin {
        debts.push(Debt(entity, amount, status, block.timestamp));
        emit DebtLogged(entity, amount, status, block.timestamp);
    }

    function totalDebts() external view returns (uint256) { return debts.length; }

    function getDebt(uint256 id) external view returns (Debt memory) {
        require(id < debts.length, "Invalid id");
        return debts[id];
    }
}
