pragma solidity ^0.8.20;

contract DiversificationPolicyProtocol {
    address public admin;

    struct Policy {
        string strategy;     // e.g. Hedge, Diversify
        string assetClass;   // e.g. Equities, Debt, Bitcoin
        uint256 timestamp;
    }

    Policy[] public policies;

    event PolicyLogged(string strategy, string assetClass, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logPolicy(string calldata strategy, string calldata assetClass) external onlyAdmin {
        policies.push(Policy(strategy, assetClass, block.timestamp));
        emit PolicyLogged(strategy, assetClass, block.timestamp);
    }

    function totalPolicies() external view returns (uint256) {
        return policies.length;
    }
}
