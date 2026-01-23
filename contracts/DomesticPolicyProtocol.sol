pragma solidity ^0.8.20;

contract DomesticPolicyProtocol {
    address public admin;

    struct Policy {
        string administration; // e.g. Biden era
        string focus;          // e.g. domestic hiring, internal security
        string impact;         // e.g. reduced mission-specific talent
        uint256 timestamp;
    }

    Policy[] public policies;

    event PolicyLogged(string administration, string focus, string impact, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logPolicy(string calldata administration, string calldata focus, string calldata impact) external onlyAdmin {
        policies.push(Policy(administration, focus, impact, block.timestamp));
        emit PolicyLogged(administration, focus, impact, block.timestamp);
    }

    function totalPolicies() external view returns (uint256) {
        return policies.length;
    }
}
