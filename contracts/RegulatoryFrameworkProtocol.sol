pragma solidity ^0.8.20;

contract RegulatoryFrameworkProtocol {
    address public admin;

    struct Framework {
        string authority;    // e.g. BSP, legislative body
        string rule;         // e.g. 10% cap on APR
        string implication;  // e.g. requires policy change, impacts issuers
        uint256 timestamp;
    }

    Framework[] public frameworks;

    event FrameworkLogged(string authority, string rule, string implication, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logFramework(string calldata authority, string calldata rule, string calldata implication) external onlyAdmin {
        frameworks.push(Framework(authority, rule, implication, block.timestamp));
        emit FrameworkLogged(authority, rule, implication, block.timestamp);
    }

    function totalFrameworks() external view returns (uint256) {
        return frameworks.length;
    }
}
