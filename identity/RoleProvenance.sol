// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract RoleProvenance {
    mapping(string => bool) public activeRoles;

    constructor() {
        activeRoles["DIRECTOR"] = true;
        activeRoles["GOVERNANCE_HEAD"] = true;
        activeRoles["BI_MANAGER"] = true;
    }

    // [Goal: Allow them to find the 'Work' but never the 'Person' unless intended]
    function verifyAuthority(string memory _role) external view returns (string memory) {
        require(activeRoles[_role], "ERROR: Unauthorized role.");
        return "CONFIRMED: This execution belongs to the Sovereign Architect.";
    }
}
