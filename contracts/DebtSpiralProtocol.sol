pragma solidity ^0.8.20;

contract DebtSpiralProtocol {
    address public admin;

    struct Debt {
        string driver;       // e.g. fiscal deficit, bond issuance
        string consequence;  // e.g. inflation, rising interest payments
        string scale;        // e.g. $1 trillion every 100 days
        uint256 timestamp;
    }

    Debt[] public debts;

    event DebtLogged(string driver, string consequence, string scale, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logDebt(string calldata driver, string calldata consequence, string calldata scale) external onlyAdmin {
        debts.push(Debt(driver, consequence, scale, block.timestamp));
        emit DebtLogged(driver, consequence, scale, block.timestamp);
    }

    function totalDebts() external view returns (uint256) {
        return debts.length;
    }
}
