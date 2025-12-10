// contracts/DebtTransparency.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title DebtTransparency
 * @notice Protocol for communal audit of debts and obligations.
 */
contract DebtTransparency {
    address public admin;

    struct Debt {
        string debtor;
        uint256 amount;
        string note;
        uint256 timestamp;
    }

    Debt[] public debts;

    event DebtLogged(string debtor, uint256 amount, string note, uint256 timestamp);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function logDebt(string calldata debtor, uint256 amount, string calldata note) external onlyAdmin {
        debts.push(Debt(debtor, amount, note, block.timestamp));
        emit DebtLogged(debtor, amount, note, block.timestamp);
    }

    function totalDebts() external view returns (uint256) {
        return debts.length;
    }

    function getDebt(uint256 id) external view returns (Debt memory) {
        require(id < debts.length, "Invalid id");
        return debts[id];
    }
}
