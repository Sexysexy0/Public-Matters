// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title FailedPolicyRegistry
/// @notice Covenant contract to record failed policies before reforms are applied
contract FailedPolicyRegistry {
    address public overseer;
    uint256 public policyCount;

    struct PolicyEntry {
        uint256 id;
        string policyName;
        string failureReason;
        string impactNotes;
        uint256 timestamp;
    }

    mapping(uint256 => PolicyEntry) public policies;

    event PolicyFailed(uint256 indexed id, string policyName, string failureReason, string impactNotes);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logFailedPolicy(
        string calldata policyName,
        string calldata failureReason,
        string calldata impactNotes
    ) external onlyOverseer {
        policyCount++;
        policies[policyCount] = PolicyEntry({
            id: policyCount,
            policyName: policyName,
            failureReason: failureReason,
            impactNotes: impactNotes,
            timestamp: block.timestamp
        });
        emit PolicyFailed(policyCount, policyName, failureReason, impactNotes);
    }

    function viewFailedPolicy(uint256 id) external view returns (PolicyEntry memory) {
        return policies[id];
    }
}
