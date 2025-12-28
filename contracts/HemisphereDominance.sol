// contracts/ChinaRecalibration.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title ChinaRecalibration
 * @notice Logs recalibration of US strategy toward China.
 */
contract ChinaRecalibration {
    address public admin;

    struct Policy {
        string goal;        // "EconomicFuture", "AvoidConfrontation", "FairTrade"
        string description;
        uint256 timestamp;
    }

    Policy[] public policies;

    event PolicyLogged(string goal, string description, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logPolicy(string calldata goal, string calldata description) external onlyAdmin {
        policies.push(Policy(goal, description, block.timestamp));
        emit PolicyLogged(goal, description, block.timestamp);
    }

    function totalPolicies() external view returns (uint256) { return policies.length; }

    function getPolicy(uint256 id) external view returns (Policy memory) {
        require(id < policies.length, "Invalid id");
        return policies[id];
    }
}
