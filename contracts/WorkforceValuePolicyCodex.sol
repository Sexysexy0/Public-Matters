// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title WorkforceValuePolicyCodex
/// @notice Covenant contract encoding leadership principle: Problem-Solution Flip
contract WorkforceValuePolicyCodex {
    address public sovereignContractor;

    struct Policy {
        uint256 id;
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

    function registerPolicy(string memory _dimension, string memory _requirement) public onlyContractor returns (uint256) {
        totalPolicies++;
        policies[totalPolicies] = Policy(totalPolicies, _dimension, _requirement, true);
        emit PolicyLogged(totalPolicies, _dimension, _requirement, true);
        return totalPolicies;
    }

    function getPolicy(uint256 id) public view returns (Policy memory) {
        return policies[id];
    }
}
