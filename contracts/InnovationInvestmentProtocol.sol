pragma solidity ^0.8.20;

contract InnovationInvestmentProtocol {
    address public admin;

    struct Investment {
        string project;      // e.g. technology, product, research
        uint256 amount;      // investment value
        uint256 timestamp;
    }

    Investment[] public investments;

    event InvestmentLogged(string project, uint256 amount, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logInvestment(string calldata project, uint256 amount) external onlyAdmin {
        investments.push(Investment(project, amount, block.timestamp));
        emit InvestmentLogged(project, amount, block.timestamp);
    }

    function totalInvestments() external view returns (uint256) {
        return investments.length;
    }
}
