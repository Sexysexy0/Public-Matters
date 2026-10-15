// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title AccessControlGovernance
 * @notice Manages multi-role access control for signers, executives, and administrators.
 */
contract AccessControlGovernance {
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant EXECUTIVE_ROLE = keccak256("EXECUTIVE_ROLE");
    bytes32 public constant SIGNER_ROLE = keccak256("SIGNER_ROLE");

    mapping(bytes32 => mapping(address => bool)) private roles;
    address public immutable rootGovernor;

    event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
    event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);

    modifier onlyRootGovernor() {
        require(msg.sender == rootGovernor, "Unauthorized: Only root governor");
        _;
    }

    modifier onlyAdmin() {
        require(roles[ADMIN_ROLE][msg.sender] || msg.sender == rootGovernor, "Unauthorized: Only admin");
        _;
    }

    constructor() {
        rootGovernor = msg.sender;
        roles[ADMIN_ROLE][msg.sender] = true;
        roles[EXECUTIVE_ROLE][msg.sender] = true;
        roles[SIGNER_ROLE][msg.sender] = true;
    }

    function grantRole(bytes32 role, address account) external onlyAdmin {
        roles[role][account] = true;
        emit RoleGranted(role, account, msg.sender);
    }

    function revokeRole(bytes32 role, address account) external onlyAdmin {
        roles[role][account] = false;
        emit RoleRevoked(role, account, msg.sender);
    }

    function hasRole(bytes32 role, address account) external view returns (bool) {
        return roles[role][account];
    }
}
