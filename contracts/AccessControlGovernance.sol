// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../src/OperatorPrivileges.sol";

/**
 * @title AccessControlGovernance
 * @notice Role registry for signers, executives, and administrators.
 *         Authority lives in OperatorPrivileges. Roles are labels that
 *         operators assign to addresses; operators themselves cannot be
 *         granted or revoked here (that happens on OperatorPrivileges).
 */
contract AccessControlGovernance {
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant EXECUTIVE_ROLE = keccak256("EXECUTIVE_ROLE");
    bytes32 public constant SIGNER_ROLE = keccak256("SIGNER_ROLE");

    OperatorPrivileges public immutable privileges;

    mapping(bytes32 => mapping(address => bool)) private roles;

    event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
    event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    constructor(address _privileges) {
        require(_privileges != address(0), "privileges=0");
        privileges = OperatorPrivileges(_privileges);
    }

    function grantRole(bytes32 role, address account) external onlyOperator {
        require(account != address(0), "account=0");
        roles[role][account] = true;
        emit RoleGranted(role, account, msg.sender);
    }

    function revokeRole(bytes32 role, address account) external onlyOperator {
        roles[role][account] = false;
        emit RoleRevoked(role, account, msg.sender);
    }

    function hasRole(bytes32 role, address account) external view returns (bool) {
        return roles[role][account];
    }
}
