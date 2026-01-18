pragma solidity ^0.8.20;

contract DeficitValueAddProtocol {
    address public admin;

    struct Spending {
        string project;      // e.g. petrochemical plant, nickel processing
        string outcome;      // e.g. export growth, domestic industry, multiplicative value
        uint256 timestamp;
    }

    Spending[] public spendings;

    event SpendingLogged(string project, string outcome, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logSpending(string calldata project, string calldata outcome) external onlyAdmin {
        spendings.push(Spending(project, outcome, block.timestamp));
        emit SpendingLogged(project, outcome, block.timestamp);
    }

    function totalSpendings() external view returns (uint256) {
        return spendings.length;
    }
}
