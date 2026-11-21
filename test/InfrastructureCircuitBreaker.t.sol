// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "forge-std/Test.sol";
import "../src/OperatorPrivileges.sol";
import "../contracts/InfrastructureCircuitBreaker.sol";

contract InfrastructureCircuitBreakerTest is Test {
    OperatorPrivileges privileges;
    InfrastructureCircuitBreaker breaker;

    address op = vm.addr(1);
    address stranger = vm.addr(2);
    bytes32 constant NODE_ID = keccak256("Node-Manila-01");

    function setUp() public {
        privileges = new OperatorPrivileges();
        privileges.addOperator(op);
        breaker = new InfrastructureCircuitBreaker(address(privileges));
    }

    function testEmergencyHalt() public {
        vm.prank(op);
        breaker.triggerEmergencyHalt("Grid Failure");
        assertTrue(breaker.systemHalted());
    }

    function testResumeSystem() public {
        vm.startPrank(op);
        breaker.triggerEmergencyHalt("Maintenance");
        breaker.resumeSystem();
        vm.stopPrank();
        assertFalse(breaker.systemHalted());
    }

    function testUnauthorizedCannotHalt() public {
        vm.prank(stranger);
        vm.expectRevert("Not authorized operator");
        breaker.triggerEmergencyHalt("Malicious Halt");
    }

    function testUpdateNodeHealth() public {
        vm.prank(op);
        breaker.updateNodeHealth(NODE_ID, true);
        assertTrue(breaker.nodeHealthStatus(NODE_ID));
    }
}
