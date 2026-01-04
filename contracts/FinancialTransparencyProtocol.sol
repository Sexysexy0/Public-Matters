pragma solidity ^0.8.20;

contract FinancialTransparencyProtocol {
    address public admin;

    struct Transaction {
        string project;      // e.g. infrastructure, healthcare, education
        uint256 amount;
        string status;       // e.g. allocated, spent, audited
        uint256 timestamp;
    }

    Transaction[] public transactions;

    event TransactionLogged(string project, uint256 amount, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logTransaction(string calldata project, uint256 amount, string calldata status) external onlyAdmin {
        transactions.push(Transaction(project, amount, status, block.timestamp));
        emit TransactionLogged(project, amount, status, block.timestamp);
    }

    function totalTransactions() external view returns (uint256) {
        return transactions.length;
    }
}
