pragma solidity ^0.8.20;

contract StablecoinPolicyProtocol {
    address public admin;

    struct Policy {
        string issuer;       // e.g. Coinbase, Circle
        string restriction;  // e.g. no interest, no rewards
        string consequence;  // e.g. protect banks, limit innovation
        uint256 timestamp;
    }

    Policy[] public policies;

    event PolicyLogged(string issuer, string restriction, string consequence, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logPolicy(string calldata issuer, string calldata restriction, string calldata consequence) external onlyAdmin {
        policies.push(Policy(issuer, restriction, consequence, block.timestamp));
        emit PolicyLogged(issuer, restriction, consequence, block.timestamp);
    }

    function totalPolicies() external view returns (uint256) {
        return policies.length;
    }
}
