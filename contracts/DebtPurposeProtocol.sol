pragma solidity ^0.8.20;

contract DebtPurposeProtocol {
    address public admin;

    struct Debt {
        string typeOf;       // e.g. productive, unproductive, security
        string project;      // e.g. infrastructure, defense, subsidies
        string viability;    // e.g. financeable, challenging
        uint256 timestamp;
    }

    Debt[] public debts;

    event DebtLogged(string typeOf, string project, string viability, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logDebt(string calldata typeOf, string calldata project, string calldata viability) external onlyAdmin {
        debts.push(Debt(typeOf, project, viability, block.timestamp));
        emit DebtLogged(typeOf, project, viability, block.timestamp);
    }

    function totalDebts() external view returns (uint256) {
        return debts.length;
    }
}
