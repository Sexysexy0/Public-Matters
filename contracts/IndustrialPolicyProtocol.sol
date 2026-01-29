pragma solidity ^0.8.20;

contract IndustrialPolicyProtocol {
    address public admin;

    struct Policy {
        string sector;       // e.g. Manufacturing, Energy
        string measure;      // e.g. Tariff, Subsidy, Import control
        uint256 timestamp;
    }

    Policy[] public policies;

    event PolicyLogged(string sector, string measure, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logPolicy(string calldata sector, string calldata measure) external onlyAdmin {
        policies.push(Policy(sector, measure, block.timestamp));
        emit PolicyLogged(sector, measure, block.timestamp);
    }

    function totalPolicies() external view returns (uint256) {
        return policies.length;
    }
}
