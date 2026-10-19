// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../src/OperatorPrivileges.sol";

/**
 * @title SovereigntyPolicyRegistry
 * @notice Append-only registry for policies, frameworks, and sovereign
 *         directives. Policies are never deleted. A policy can be
 *         superseded by another, which marks the original inactive and
 *         records the successor. Revocation (without a successor) is
 *         also supported but preserves the record.
 */
contract SovereigntyPolicyRegistry {
    struct Policy {
        string  title;
        string  ipfsHashOrURI;
        uint256 timestamp;
        bool    active;
        bytes32 supersededBy;   // bytes32(0) if not superseded
        address registrar;
    }

    OperatorPrivileges public immutable privileges;

    mapping(bytes32 => Policy) public policies;

    event PolicyRegistered(
        bytes32 indexed policyId,
        string  title,
        address indexed registrar,
        uint256 timestamp
    );
    event PolicySuperseded(
        bytes32 indexed oldPolicyId,
        bytes32 indexed newPolicyId,
        address indexed registrar
    );
    event PolicyRevoked(
        bytes32 indexed policyId,
        address indexed registrar
    );

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    constructor(address _privileges) {
        require(_privileges != address(0), "privileges=0");
        privileges = OperatorPrivileges(_privileges);
    }

    function registerPolicy(
        bytes32 policyId,
        string calldata title,
        string calldata ipfsHashOrURI
    ) external onlyOperator {
        require(policyId != bytes32(0), "policyId=0");
        require(policies[policyId].timestamp == 0, "Policy exists");

        policies[policyId] = Policy({
            title: title,
            ipfsHashOrURI: ipfsHashOrURI,
            timestamp: block.timestamp,
            active: true,
            supersededBy: bytes32(0),
            registrar: msg.sender
        });

        emit PolicyRegistered(policyId, title, msg.sender, block.timestamp);
    }

    function supersedePolicy(bytes32 oldPolicyId, bytes32 newPolicyId) external onlyOperator {
        require(oldPolicyId != newPolicyId, "Cannot supersede self");
        Policy storage oldP = policies[oldPolicyId];
        Policy storage newP = policies[newPolicyId];

        require(oldP.timestamp != 0, "Old policy not found");
        require(newP.timestamp != 0, "New policy not found");
        require(oldP.active, "Old policy inactive");
        require(newP.active, "New policy inactive");

        oldP.active = false;
        oldP.supersededBy = newPolicyId;

        emit PolicySuperseded(oldPolicyId, newPolicyId, msg.sender);
    }

    function revokePolicy(bytes32 policyId) external onlyOperator {
        Policy storage p = policies[policyId];
        require(p.timestamp != 0, "Policy not found");
        require(p.active, "Already inactive");
        p.active = false;
        emit PolicyRevoked(policyId, msg.sender);
    }

    function verifyPolicy(bytes32 policyId) external view returns (bool, string memory, string memory) {
        Policy memory p = policies[policyId];
        return (p.active, p.title, p.ipfsHashOrURI);
    }

    function getPolicy(bytes32 policyId) external view returns (Policy memory) {
        return policies[policyId];
    }
}
