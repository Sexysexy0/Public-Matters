// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivilegesV2.sol";
import "../src/AIAgentRegistryV2.sol";

contract AIAgentRegistryV2Test is Test {
    OperatorPrivilegesV2 privileges;
    AIAgentRegistryV2 registry;

    address owner = address(0xA11CE);
    address op1 = address(0xB0B);
    address outsider = address(0xBAD);

    function setUp() public {
        vm.startPrank(owner);
        privileges = new OperatorPrivilegesV2();
        privileges.addOperator(op1);
        vm.stopPrank();

        registry = new AIAgentRegistryV2(address(privileges));
    }

    function test_RegisterAgent() public {
        vm.prank(op1);
        bytes32 agentId = registry.registerAgent("Test-Agent", op1, "gpt-5.6", new string[](0));

        (string memory name,,,, AIAgentRegistryV2.AgentStatus status,,,,) = registry.getAgent(agentId);
        assertEq(name, "Test-Agent");
        assertEq(uint256(status), uint256(AIAgentRegistryV2.AgentStatus.ACTIVE));
    }

    function test_NoSeparateAdmin_OperatorCanAuthorizeKillSwitch() public {
        // In V1, this required admin. In V2, only operator.
        vm.prank(op1);
        registry.authorizeKillSwitch(outsider);
        assertTrue(registry.killSwitchAuthorized(outsider));
    }

    function test_OperatorCanChangeHeartbeatTolerance() public {
        vm.prank(op1);
        registry.setHeartbeatTolerance(7200);
        assertEq(registry.heartbeatTolerance(), 7200);
    }

    function test_KillSwitchByOperator() public {
        vm.prank(op1);
        bytes32 agentId = registry.registerAgent("Rogue", op1, "gpt", new string[](0));

        vm.prank(op1);
        registry.killAgent(agentId, "rogue behavior");

        (,,,, AIAgentRegistryV2.AgentStatus status,,,,) = registry.getAgent(agentId);
        assertEq(uint256(status), uint256(AIAgentRegistryV2.AgentStatus.KILLED));
    }

    function test_OutsiderCannotRegister() public {
        vm.prank(outsider);
        vm.expectRevert("Not authorized operator");
        registry.registerAgent("Bad", outsider, "x", new string[](0));
    }

    function test_OutsiderCannotAuthorizeKillSwitch() public {
        vm.prank(outsider);
        vm.expectRevert("Not authorized operator");
        registry.authorizeKillSwitch(outsider);
    }

    function test_HeartbeatAndCompliance() public {
        vm.startPrank(op1);
        bytes32 agentId = registry.registerAgent("Live", op1, "gpt", new string[](0));

        assertTrue(registry.isCompliant(agentId));

        vm.warp(block.timestamp + 7200);
        assertFalse(registry.isCompliant(agentId));

        registry.heartbeat(agentId);
        assertTrue(registry.isCompliant(agentId));
        vm.stopPrank();
    }

    function test_SuspendAndReactivate() public {
        vm.startPrank(op1);
        bytes32 agentId = registry.registerAgent("Toggle", op1, "gpt", new string[](0));

        registry.suspendAgent(agentId, "pause");
        (,,,, AIAgentRegistryV2.AgentStatus s1,,,,) = registry.getAgent(agentId);
        assertEq(uint256(s1), uint256(AIAgentRegistryV2.AgentStatus.SUSPENDED));

        registry.reactivateAgent(agentId);
        (,,,, AIAgentRegistryV2.AgentStatus s2,,,,) = registry.getAgent(agentId);
        assertEq(uint256(s2), uint256(AIAgentRegistryV2.AgentStatus.ACTIVE));
        vm.stopPrank();
    }
}
