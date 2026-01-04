pragma solidity ^0.8.20;

contract EnvironmentalJusticeProtocol {
    address public admin;

    struct Case {
        string project;      // e.g. mining, deforestation, pollution
        string impact;       // e.g. violated, mitigated, pending
        uint256 timestamp;
    }

    Case[] public cases;

    event CaseLogged(string project, string impact, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logCase(string calldata project, string calldata impact) external onlyAdmin {
        cases.push(Case(project, impact, block.timestamp));
        emit CaseLogged(project, impact, block.timestamp);
    }

    function totalCases() external view returns (uint256) {
        return cases.length;
    }
}
