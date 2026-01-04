pragma solidity ^0.8.20;

contract AntiMonopolyCommonsProtocol {
    address public admin;

    struct Case {
        string company;      // e.g. tech giant, energy firm
        string violation;    // e.g. price fixing, market dominance
        uint256 timestamp;
    }

    Case[] public cases;

    event CaseLogged(string company, string violation, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logCase(string calldata company, string calldata violation) external onlyAdmin {
        cases.push(Case(company, violation, block.timestamp));
        emit CaseLogged(company, violation, block.timestamp);
    }

    function totalCases() external view returns (uint256) {
        return cases.length;
    }
}
