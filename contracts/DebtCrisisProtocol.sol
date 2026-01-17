pragma solidity ^0.8.20;

contract DebtCrisisProtocol {
    address public admin;

    struct DebtEvent {
        uint256 amount;      // e.g. 38500000000000
        string issue;        // e.g. refinancing, deficit, maturity risk
        uint256 timestamp;
    }

    DebtEvent[] public debts;

    event DebtLogged(uint256 amount, string issue, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logDebt(uint256 amount, string calldata issue) external onlyAdmin {
        debts.push(DebtEvent(amount, issue, block.timestamp));
        emit DebtLogged(amount, issue, block.timestamp);
    }

    function totalDebts() external view returns (uint256) {
        return debts.length;
    }
}
