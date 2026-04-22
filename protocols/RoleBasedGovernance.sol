// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract RoleBasedGovernance is AccessControl {
    bytes32 public constant ENGINEER_ROLE = keccak256("ENGINEER_ROLE");

    constructor() {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender); // Vin is the Admin
        _grantRole(ENGINEER_ROLE, msg.sender);      // Vin is the Engineer
    }
}
