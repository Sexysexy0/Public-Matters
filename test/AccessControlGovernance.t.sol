// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivileges.sol";
import "../contracts/AccessControlGovernance.sol";

contract AccessControlGovernanceTest is Test {
    OperatorPrivileges privileges;
    AccessControlGovernance gov;

    address op1 = vm.addr(1);
    address op2 = vm.addr(2);
    address target = vm.addr(3);
    address stranger = vm.addr(4);

    function setUp() public {
        privileges = new OperatorPrivileges();
        gov = new AccessControlGovernance(address(privileges));
        privileges.addOperator(op1);
        privileges.addOperator(op2);
    }

    function testGrantRoleByOperator() public {
        vm.prank(op1);
        gov.grantRole(gov.ADMIN_ROLE(), target);
        assertTrue(gov.hasRole(gov.ADMIN_ROLE(), target));
    }

    function testRevokeRoleByOperator() public {
        vm.prank(op1);
        gov.grantRole(gov.SIGNER_ROLE(), target);
        vm.prank(op2);
        gov.revokeRole(gov.SIGNER_ROLE(), target);
        assertFalse(gov.hasRole(gov.SIGNER_ROLE(), target));
    }

    function testStrangerCannotGrant() public {
        bytes32 role = gov.ADMIN_ROLE();
        vm.prank(stranger);
        vm.expectRevert("Not authorized operator");
        gov.grantRole(role, stranger);
    }

    function testStrangerCannotRevoke() public {
        bytes32 role = gov.ADMIN_ROLE();
        vm.prank(op1);
        gov.grantRole(role, target);
        vm.prank(stranger);
        vm.expectRevert("Not authorized operator");
        gov.revokeRole(role, target);
    }

    function testCannotGrantZeroAddress() public {
        bytes32 role = gov.ADMIN_ROLE();
        vm.prank(op1);
        vm.expectRevert("account=0");
        gov.grantRole(role, address(0));
    }

    function testRolesAreIndependent() public {
        vm.prank(op1);
        gov.grantRole(gov.ADMIN_ROLE(), target);
        assertTrue(gov.hasRole(gov.ADMIN_ROLE(), target));
        assertFalse(gov.hasRole(gov.EXECUTIVE_ROLE(), target));
        assertFalse(gov.hasRole(gov.SIGNER_ROLE(), target));
    }

    function testConstructorRejectsZero() public {
        vm.expectRevert("privileges=0");
        new AccessControlGovernance(address(0));
    }
}
