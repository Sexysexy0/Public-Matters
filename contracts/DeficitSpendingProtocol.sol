pragma solidity ^0.8.20;

contract DeficitSpendingProtocol {
    address public admin;

    struct Spending {
        string government;   // e.g. US, EU
        string method;       // e.g. deficit financing, stimulus packages
        string impact;       // e.g. inflation, currency debasement
        uint256 timestamp;
    }

    Spending[] public spendings;

    event SpendingLogged(string government, string method, string impact, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logSpending(string calldata government, string calldata method, string calldata impact) external onlyAdmin {
        spendings.push(Spending(government, method, impact, block.timestamp));
        emit SpendingLogged(government, method, impact, block.timestamp);
    }

    function totalSpendings() external view returns (uint256) {
        return spendings.length;
    }
}
