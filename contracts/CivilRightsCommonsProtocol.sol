pragma solidity ^0.8.20;

contract CivilRightsCommonsProtocol {
    address public admin;

    struct Case {
        string right;        // e.g. free speech, equal protection
        string status;       // e.g. upheld, violated, pending
        uint256 timestamp;
    }

    Case[] public cases;

    event CaseLogged(string right, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logCase(string calldata right, string calldata status) external onlyAdmin {
        cases.push(Case(right, status, block.timestamp));
        emit CaseLogged(right, status, block.timestamp);
    }

    function totalCases() external view returns (uint256) {
        return cases.length;
    }
}
