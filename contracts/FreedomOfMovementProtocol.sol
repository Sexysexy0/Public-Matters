pragma solidity ^0.8.20;

contract FreedomOfMovementProtocol {
    address public admin;

    struct Violation {
        string region;       // e.g. Gansu, Guizhou, Yunnan, Sujiatun
        string restriction;  // e.g. difficulty obtaining passport, confiscation
        string impact;       // e.g. blocked travel, unsafe period
        uint256 timestamp;
    }

    Violation[] public violations;

    event ViolationLogged(string region, string restriction, string impact, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logViolation(string calldata region, string calldata restriction, string calldata impact) external onlyAdmin {
        violations.push(Violation(region, restriction, impact, block.timestamp));
        emit ViolationLogged(region, restriction, impact, block.timestamp);
    }

    function totalViolations() external view returns (uint256) {
        return violations.length;
    }
}
