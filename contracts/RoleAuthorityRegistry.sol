// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title RoleAuthorityRegistry
 * @dev System Structure Mapping Engine for explicit role authorization checkpoints.
 */
contract RoleAuthorityRegistry {
    
    // Cryptographic role identifiers
    bytes32 public constant OVERSEER_ROLE  = keccak256("OVERSEER_ROLE");
    bytes32 public constant STEWARD_ROLE   = keccak256("STEWARD_ROLE");
    bytes32 public constant SENTINEL_ROLE  = keccak256("SENTINEL_ROLE");
    bytes32 public constant VINVIN_ROLE    = keccak256("VINVIN_ROLE");
    bytes32 public constant ADMIN_ROLE     = keccak256("ADMIN_ROLE");

    // Mapping tracking: Role => Account => Authorization Status
    mapping(bytes32 => mapping(address => bool)) private _roles;

    // Custom system error signatures for gas optimization
    error UnauthorizedAccess(address caller, bytes32 requiredRole);

    // Event notifications for security telemetry auditing
    event RoleGranted(bytes32 indexed role, address indexed account, address indexed operator);
    event RoleRevoked(bytes32 indexed role, address indexed account, address indexed operator);

    modifier onlyRole(bytes32 role) {
        if (!_roles[role][msg.sender]) {
            revert UnauthorizedAccess(msg.sender, role);
        }
        _;
    }

    constructor(address initialAdmin) {
        // Bootstrap the registry by granting the initial deployer setup rights
        _roles[ADMIN_ROLE][initialAdmin] = true;
        emit RoleGranted(ADMIN_ROLE, initialAdmin, msg.sender);
    }

    /**
     * @notice Grants an operational security role authority node to an address.
     */
    function grantRole(bytes32 role, address account) external onlyRole(ADMIN_ROLE) {
        _roles[role][account] = true;
        emit RoleGranted(role, account, msg.sender);
    }

    /**
     * @notice Revokes an operational security role authority node from an address.
     */
    function revokeRole(bytes32 role, address account) external onlyRole(ADMIN_ROLE) {
        _roles[role][account] = false;
        emit RoleRevoked(role, account, msg.sender);
    }

    /**
     * @notice Verification gate to query if an account holds a specific system authority.
     */
    function hasRole(bytes32 role, address account) external view returns (bool) {
        return _roles[role][account];
    }
}
