// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title SovereigntyPolicyRegistry
 * @notice On-chain immutable registry for national policies, frameworks, and sovereign directives.
 */
contract SovereigntyPolicyRegistry {
    struct Policy {
        string title;
        string ipfsHashOrURI;
        uint256 timestamp;
        bool active;
    }

    mapping(bytes32 => Policy) public policies;
    address public immutable governor;

    event PolicyRegistered(bytes32 indexed policyId, string title, uint256 timestamp);
    event PolicyRevoked(bytes32 indexed policyId);

    modifier onlyGovernor() {
        require(msg.sender == governor, "Unauthorized: Only governor");
        _;
    }

    constructor() {
        governor = msg.sender;
    }

    function registerPolicy(
        bytes32 policyId,
        string calldata title,
        string calldata ipfsHashOrURI
    ) external onlyGovernor {
        policies[policyId] = Policy({
            title: title,
            ipfsHashOrURI: ipfsHashOrURI,
            timestamp: block.timestamp,
            active: true
        });
        emit PolicyRegistered(policyId, title, block.timestamp);
    }

    function revokePolicy(bytes32 policyId) external onlyGovernor {
        policies[policyId].active = false;
        emit PolicyRevoked(policyId);
    }

    function verifyPolicy(bytes32 policyId) external view returns (bool, string memory, string memory) {
        Policy memory p = policies[policyId];
        return (p.active, p.title, p.ipfsHashOrURI);
    }
}
