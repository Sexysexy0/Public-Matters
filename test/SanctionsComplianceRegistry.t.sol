// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivileges.sol";
import "../src/SanctionsComplianceRegistry.sol";

contract SanctionsComplianceRegistryTest is Test {
    OperatorPrivileges privileges;
    SanctionsComplianceRegistry registry;

    address op = vm.addr(1);
    address badActor = vm.addr(2);
    bytes32 constant REASON = keccak256("FinCEN-Suspected-Illicit-Flows");

    function setUp() public {
        privileges = new OperatorPrivileges();
        privileges.addOperator(op);
        registry = new SanctionsComplianceRegistry(address(privileges));
    }

    function testFlagAddress() public {
        vm.prank(op);
        registry.flagAddress(badActor, REASON);

        assertTrue(registry.isAddressFlagged(badActor));
        assertEq(registry.totalFlagged(), 1);
    }

    function testClearAddress() public {
        vm.startPrank(op);
        registry.flagAddress(badActor, REASON);
        registry.clearAddress(badActor);
        vm.stopPrank();

        assertFalse(registry.isAddressFlagged(badActor));
    }

    function testOnlyOperatorCanFlag() public {
        vm.prank(badActor);
        vm.expectRevert("Not authorized operator");
        registry.flagAddress(badActor, REASON);
    }
}
