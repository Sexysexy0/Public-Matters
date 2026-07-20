// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract AccessControlCodex is AccessControl {
    // Roles
    bytes32 public constant OVERSEER_ROLE = keccak256("OVERSEER_ROLE");
    bytes32 public constant RESERVE_UPDATER_ROLE = keccak256("RESERVE_UPDATER_ROLE");
    bytes32 public constant APR_UPDATER_ROLE = keccak256("APR_UPDATER_ROLE");
    bytes32 public constant DAMAY_TRIGGER_ROLE = keccak256("DAMAY_TRIGGER_ROLE");
    bytes32 public constant AUDITOR_ROLE = keccak256("AUDITOR_ROLE");

    // Events
    event RoleGranted(address indexed account, bytes32 role, address indexed granter);
    event RoleRevoked(address indexed account, bytes32 role, address indexed revoker);

    constructor(address overseer) {
        _grantRole(DEFAULT_ADMIN_ROLE, overseer);
        _grantRole(OVERSEER_ROLE, overseer);
    }

    // Governance: only overseer can assign roles
    function grantCodexRole(bytes32 role, address account) external onlyRole(OVERSEER_ROLE) {
        _grantRole(role, account);
        emit RoleGranted(account, role, msg.sender);
    }

    function revokeCodexRole(bytes32 role, address account) external onlyRole(OVERSEER_ROLE) {
        _revokeRole(role, account);
        emit RoleRevoked(account, role, msg.sender);
    }

    // Example protected functions
    function updateReserves(address exchange, uint256 assets, uint256 liabilities)
        external
        onlyRole(RESERVE_UPDATER_ROLE)
    {
        // logic to update reserves
    }

    function updateAPR(uint256 newAPR) external onlyRole(APR_UPDATER_ROLE) {
        // logic to update APR
    }

    function triggerDamay(address exchange) external onlyRole(DAMAY_TRIGGER_ROLE) {
        // logic to trigger damay state machine
    }

    function auditReport(string calldata findings) external onlyRole(AUDITOR_ROLE) {
        // auditors can log findings
    }
}
