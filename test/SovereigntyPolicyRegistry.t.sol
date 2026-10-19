// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivileges.sol";
import "../contracts/SovereigntyPolicyRegistry.sol";

contract SovereigntyPolicyRegistryTest is Test {
    OperatorPrivileges privileges;
    SovereigntyPolicyRegistry registry;

    address op1 = vm.addr(1);
    address op2 = vm.addr(2);
    address stranger = vm.addr(3);

    bytes32 constant POLICY_A = keccak256("policy-2025-tax");
    bytes32 constant POLICY_B = keccak256("policy-2026-tax");

    function setUp() public {
        privileges = new OperatorPrivileges();
        registry = new SovereigntyPolicyRegistry(address(privileges));
        privileges.addOperator(op1);
        privileges.addOperator(op2);
    }

    function testRegisterPolicy() public {
        vm.prank(op1);
        registry.registerPolicy(POLICY_A, "Tax Reform 2025", "ipfs://aaa");

        (bool active, string memory title, string memory uri) = registry.verifyPolicy(POLICY_A);
        assertTrue(active);
        assertEq(title, "Tax Reform 2025");
        assertEq(uri, "ipfs://aaa");
    }

    function testCannotRegisterDuplicate() public {
        vm.prank(op1);
        registry.registerPolicy(POLICY_A, "Tax Reform 2025", "ipfs://aaa");

        vm.prank(op1);
        vm.expectRevert("Policy exists");
        registry.registerPolicy(POLICY_A, "Dup", "ipfs://dup");
    }

    function testCannotRegisterZero() public {
        vm.prank(op1);
        vm.expectRevert("policyId=0");
        registry.registerPolicy(bytes32(0), "Zero", "ipfs://z");
    }

    function testStrangerCannotRegister() public {
        vm.prank(stranger);
        vm.expectRevert("Not authorized operator");
        registry.registerPolicy(POLICY_A, "Tax", "ipfs://a");
    }

    function testSupersedePolicy() public {
        vm.prank(op1);
        registry.registerPolicy(POLICY_A, "Tax 2025", "ipfs://a");
        vm.prank(op1);
        registry.registerPolicy(POLICY_B, "Tax 2026", "ipfs://b");

        vm.prank(op2);
        registry.supersedePolicy(POLICY_A, POLICY_B);

        SovereigntyPolicyRegistry.Policy memory oldP = registry.getPolicy(POLICY_A);
        assertFalse(oldP.active);
        assertEq(oldP.supersededBy, POLICY_B);

        SovereigntyPolicyRegistry.Policy memory newP = registry.getPolicy(POLICY_B);
        assertTrue(newP.active);
    }

    function testCannotSupersedeSelf() public {
        vm.prank(op1);
        registry.registerPolicy(POLICY_A, "Tax", "ipfs://a");

        vm.prank(op1);
        vm.expectRevert("Cannot supersede self");
        registry.supersedePolicy(POLICY_A, POLICY_A);
    }

    function testCannotSupersedeInactive() public {
        vm.prank(op1);
        registry.registerPolicy(POLICY_A, "Tax 2025", "ipfs://a");
        vm.prank(op1);
        registry.registerPolicy(POLICY_B, "Tax 2026", "ipfs://b");
        vm.prank(op1);
        registry.revokePolicy(POLICY_A);

        vm.prank(op1);
        vm.expectRevert("Old policy inactive");
        registry.supersedePolicy(POLICY_A, POLICY_B);
    }

    function testCannotSupersedeMissing() public {
        vm.prank(op1);
        registry.registerPolicy(POLICY_A, "Tax", "ipfs://a");

        vm.prank(op1);
        vm.expectRevert("New policy not found");
        registry.supersedePolicy(POLICY_A, POLICY_B);
    }

    function testRevokePolicy() public {
        vm.prank(op1);
        registry.registerPolicy(POLICY_A, "Tax", "ipfs://a");

        vm.prank(op1);
        registry.revokePolicy(POLICY_A);

        (bool active,,) = registry.verifyPolicy(POLICY_A);
        assertFalse(active);
    }

    function testCannotRevokeTwice() public {
        vm.prank(op1);
        registry.registerPolicy(POLICY_A, "Tax", "ipfs://a");
        vm.prank(op1);
        registry.revokePolicy(POLICY_A);

        vm.prank(op1);
        vm.expectRevert("Already inactive");
        registry.revokePolicy(POLICY_A);
    }

    function testRegistrarRecorded() public {
        vm.prank(op1);
        registry.registerPolicy(POLICY_A, "Tax", "ipfs://a");

        SovereigntyPolicyRegistry.Policy memory p = registry.getPolicy(POLICY_A);
        assertEq(p.registrar, op1);
    }

    function testConstructorRejectsZero() public {
        vm.expectRevert("privileges=0");
        new SovereigntyPolicyRegistry(address(0));
    }
}
