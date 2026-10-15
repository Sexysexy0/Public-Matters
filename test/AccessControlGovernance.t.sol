// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/AccessControlGovernance.sol";

contract AccessControlGovernanceTest is Test {
    AccessControlGovernance accessControl;
    address rootGovernor = address(this);
    address admin = address(0x111);
    address user = address(0x222);

    function setUp() public {
        accessControl = new AccessControlGovernance();
    }

    function testInitialRoles() public {
        assertTrue(accessControl.hasRole(accessControl.ADMIN_ROLE(), rootGovernor));
        assertTrue(accessControl.hasRole(accessControl.EXECUTIVE_ROLE(), rootGovernor));
        assertTrue(accessControl.hasRole(accessControl.SIGNER_ROLE(), rootGovernor));
    }

    function testGrantAndRevokeRole() public {
        bytes32 signerRole = accessControl.SIGNER_ROLE();

        // Grant role
        accessControl.grantRole(signerRole, user);
        assertTrue(accessControl.hasRole(signerRole, user));

        // Revoke role
        accessControl.revokeRole(signerRole, user);
        assertFalse(accessControl.hasRole(signerRole, user));
    }

    function test_RevertWhen_UnauthorizedGrantRole() public {
        bytes32 adminRole = accessControl.ADMIN_ROLE();
        vm.prank(user);
        vm.expectRevert("Unauthorized: Only admin");
        accessControl.grantRole(adminRole, admin);
    }
}
