// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title AI Workflow Identity Registry
/// @notice Provides a registry of roles and actors in AI workflow governance.
/// @dev Complements AIWorkflowEnhancement, AIWorkflowLedger, AIWorkflowCouncil, and AIWorkflowDashboard.

contract AIWorkflowIdentity {
    address public guardian;
    uint256 public identityCount;

    enum RoleType {
        Guardian,
        Council,
        Justice,
        Innovator,
        PublicServant,
        Oversight,
        Citizen,
        FutureEntity
    }

    struct Identity {
        uint256 id;
        address account;
        RoleType role;
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => Identity) public identities;
    mapping(address => RoleType) public roles;

    event IdentityRegistered(uint256 indexed id, address indexed account, RoleType role);
    event RoleUpdated(address indexed account, RoleType role);

    constructor() {
        guardian = msg.sender;
        identityCount = 0;
    }

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Guardian only");
        _;
    }

    function registerIdentity(address account, RoleType role, string calldata description) external onlyGuardian {
        identityCount++;
        identities[identityCount] = Identity(
            identityCount,
            account,
            role,
            description,
            block.timestamp
        );
        roles[account] = role;
        emit IdentityRegistered(identityCount, account, role);
    }

    function updateRole(address account, RoleType role) external onlyGuardian {
        roles[account] = role;
        emit RoleUpdated(account, role);
    }

    function getIdentity(uint256 id) external view returns (Identity memory) {
        return identities[id];
    }
}
