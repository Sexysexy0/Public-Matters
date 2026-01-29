pragma solidity ^0.8.20;

contract HouseholdSpendingProtocol {
    address public admin;

    struct Spending {
        string category;     // e.g. Food, Utilities, Education
        string pressure;     // e.g. Inflation, Stagnant wages
        uint256 timestamp;
    }

    Spending[] public spendings;

    event SpendingLogged(string category, string pressure, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logSpending(string calldata category, string calldata pressure) external onlyAdmin {
        spendings.push(Spending(category, pressure, block.timestamp));
        emit SpendingLogged(category, pressure, block.timestamp);
    }

    function totalSpendings() external view returns (uint256) {
        return spendings.length;
    }
}
