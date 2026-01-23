pragma solidity ^0.8.20;

contract ConsumerRightsProtocol {
    address public admin;

    struct Case {
        string company;      // e.g. Google, publisher
        string issue;        // e.g. revoked access, changed terms
        string documentation; // e.g. wiki entry, media coverage
        uint256 timestamp;
    }

    Case[] public cases;

    event CaseLogged(string company, string issue, string documentation, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logCase(string calldata company, string calldata issue, string calldata documentation) external onlyAdmin {
        cases.push(Case(company, issue, documentation, block.timestamp));
        emit CaseLogged(company, issue, documentation, block.timestamp);
    }

    function totalCases() external view returns (uint256) {
        return cases.length;
    }
}
