pragma solidity ^0.8.20;

contract FinancialLiteracyProtocol {
    address public admin;

    struct Literacy {
        string topic;        // e.g. budgeting, saving, investing
        string method;       // e.g. workshop, online course, community training
        string outcome;      // e.g. debt reduction, wealth building
        uint256 timestamp;
    }

    Literacy[] public literacies;

    event LiteracyLogged(string topic, string method, string outcome, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logLiteracy(string calldata topic, string calldata method, string calldata outcome) external onlyAdmin {
        literacies.push(Literacy(topic, method, outcome, block.timestamp));
        emit LiteracyLogged(topic, method, outcome, block.timestamp);
    }

    function totalLiteracies() external view returns (uint256) {
        return literacies.length;
    }
}
