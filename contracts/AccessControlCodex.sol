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

    // Multi-sig overseer governance
    uint256 public requiredApprovals = 2;
    mapping(bytes32 => mapping(address => bool)) public approvals;
    mapping(bytes32 => uint256) public approvalCount;

    // Slashing conditions
    mapping(address => uint256) public validatorStake;
    event Slashed(address indexed validator, uint256 amount, string reason);

    constructor(address overseer) {
        _grantRole(DEFAULT_ADMIN_ROLE, overseer);
        _grantRole(OVERSEER_ROLE, overseer);
    }

    // Multi-sig approval for role grants
    function approveRoleGrant(bytes32 role, address account) external onlyRole(OVERSEER_ROLE) {
        require(!approvals[role][account], "Already approved");
        approvals[role][account] = true;
        approvalCount[role]++;
        if (approvalCount[role] >= requiredApprovals) {
            _grantRole(role, account);
        }
    }

    // Slashing mechanism
    function slashValidator(address validator, uint256 amount, string calldata reason) external onlyRole(OVERSEER_ROLE) {
        require(validatorStake[validator] >= amount, "Insufficient stake");
        validatorStake[validator] -= amount;
        emit Slashed(validator, amount, reason);
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
