pragma solidity ^0.8.20;

contract CollectorWageProtocol {
    address public admin;

    struct Wage {
        string role;         // e.g. garbage collector
        uint256 amount;      // e.g. monthly wage
        string adjustment;   // e.g. increased, stagnant
        uint256 timestamp;
    }

    Wage[] public wages;

    event WageLogged(string role, uint256 amount, string adjustment, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logWage(string calldata role, uint256 amount, string calldata adjustment) external onlyAdmin {
        wages.push(Wage(role, amount, adjustment, block.timestamp));
        emit WageLogged(role, amount, adjustment, block.timestamp);
    }

    function totalWages() external view returns (uint256) {
        return wages.length;
    }
}
