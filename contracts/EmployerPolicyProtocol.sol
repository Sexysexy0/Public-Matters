pragma solidity ^0.8.20;

contract EmployerPolicyProtocol {
    address public admin;

    struct Policy {
        string company;      // e.g. Manila-based employer
        string rule;         // e.g. uniform wage scale
        string effect;       // e.g. equal pay across regions
        uint256 timestamp;
    }

    Policy[] public policies;

    event PolicyLogged(string company, string rule, string effect, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logPolicy(string calldata company, string calldata rule, string calldata effect) external onlyAdmin {
        policies.push(Policy(company, rule, effect, block.timestamp));
        emit PolicyLogged(company, rule, effect, block.timestamp);
    }

    function totalPolicies() external view returns (uint256) {
        return policies.length;
    }
}
