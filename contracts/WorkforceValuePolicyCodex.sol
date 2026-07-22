// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title WorkforceValuePolicyCodex
/// @notice Covenant contract encoding leadership principle: Problem-Solution Flip
/// @dev Ensures roles are designed for value, not just performance
contract WorkforceValuePolicyCodex {
    address public sovereignContractor;

    struct Policy {
        uint256 id;
        string dimension;    // e.g. "Practical", "Emotional", "Social"
        string requirement;  // policy requirement
        string dimension;
        string requirement;
        bool enforced;
    }

    mapping(uint256 => Policy) public policies;
    uint256 public totalPolicies;

    event PolicyLogged(uint256 indexed id, string dimension, string requirement, bool enforced);

    modifier onlyContractor() {
        require(msg.sender == sovereignContractor, "Error: Only Sovereign Contractor access.");
        _;
    }

    constructor() {
        sovereignContractor = msg.sender;
    }

    /// @notice Register a new workforce value policy
    function registerPolicy(string memory _dimension, string memory _requirement) public onlyContractor returns (uint256) {
        totalPolicies++;
        policies[totalPolicies] = Policy({
            id: totalPolicies,
            dimension: _dimension,
            requirement: _requirement,
            enforced: true
        });

    function registerPolicy(string memory _dimension, string memory _requirement) public onlyContractor returns (uint256) {
        totalPolicies++;
        policies[totalPolicies] = Policy(totalPolicies, _dimension, _requirement, true);
        emit PolicyLogged(totalPolicies, _dimension, _requirement, true);
        return totalPolicies;
    }

    /// @notice Fetch policy details
    function getPolicy(uint256 id) public view returns (Policy memory) {
        return policies[id];
    }
}
