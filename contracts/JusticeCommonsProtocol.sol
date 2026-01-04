pragma solidity ^0.8.20;

contract JusticeCommonsProtocol {
    address public admin;

    struct Case {
        string defendant;
        string charge;
        string status;       // e.g. pending, acquitted, convicted
        uint256 timestamp;
    }

    Case[] public cases;

    event CaseLogged(string defendant, string charge, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logCase(string calldata defendant, string calldata charge, string calldata status) external onlyAdmin {
        cases.push(Case(defendant, charge, status, block.timestamp));
        emit CaseLogged(defendant, charge, status, block.timestamp);
    }

    function totalCases() external view returns (uint256) {
        return cases.length;
    }
}
