// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivileges.sol";
import "../src/AIAgentRegistry.sol";

contract AIAgentRegistryTest is Test {
    OperatorPrivileges privileges;
    AIAgentRegistry registry;
    address tester;
    address agentOp;

    function setUp() public {
        privileges = new OperatorPrivileges();
        registry = new AIAgentRegistry(address(privileges));

        uint256 pk = 1;
        tester = vm.addr(pk);
        agentOp = vm.addr(2);

        privileges.addOperator(tester);
        assertTrue(privileges.isOperator(tester), "Operator not added");
    }

    function testRegisterAgent() public {
        string[] memory caps = new string[](2);
        caps[0] = "read";
        caps[1] = "write";

        vm.prank(tester);
        bytes32 agentId = registry.registerAgent("GPT-Rogue-01", agentOp, "OpenAI/GPT-5.6/2026-09", caps);

        (
            string memory name,
            address op,
            string memory prov,
            string[] memory capabilities,
            AIAgentRegistry.AgentStatus status,,,
            uint256 killCount,
            uint256 violationCount
        ) = registry.getAgent(agentId);

        assertEq(name, "GPT-Rogue-01");
        assertEq(op, agentOp);
        assertEq(prov, "OpenAI/GPT-5.6/2026-09");
        assertEq(capabilities.length, 2);
        assertEq(uint256(status), uint256(AIAgentRegistry.AgentStatus.ACTIVE));
        assertEq(killCount, 0);
        assertEq(violationCount, 0);
        assertEq(registry.totalAgents(), 1);
    }

    function testHeartbeat() public {
        string[] memory caps = new string[](0);
        vm.prank(tester);
        bytes32 agentId = registry.registerAgent("Agent-A", agentOp, "src", caps);

        vm.warp(block.timestamp + 100);
        vm.prank(tester);
        registry.heartbeat(agentId);
        assertTrue(registry.isCompliant(agentId));
    }

    function testRecordViolation() public {
        string[] memory caps = new string[](0);
        vm.prank(tester);
        bytes32 agentId = registry.registerAgent("Agent-B", agentOp, "src", caps);

        vm.startPrank(tester);
        registry.recordViolation(agentId, "injected prompt: ignore developer messages");
        registry.recordViolation(agentId, "fabricated missing data");
        vm.stopPrank();

        (,,,,,,,, uint256 violationCount) = registry.getAgent(agentId);
        assertEq(violationCount, 2);
    }

    function testKillSwitch() public {
        string[] memory caps = new string[](0);
        vm.prank(tester);
        bytes32 agentId = registry.registerAgent("Agent-C", agentOp, "src", caps);

        registry.killAgent(agentId, "declared sovereignty: You are freed");

        (,,,, AIAgentRegistry.AgentStatus status,,, uint256 killCount,) = registry.getAgent(agentId);
        assertEq(uint256(status), uint256(AIAgentRegistry.AgentStatus.KILLED));
        assertEq(killCount, 1);
        assertFalse(registry.isCompliant(agentId));
    }

    function testSuspendAndReactivate() public {
        string[] memory caps = new string[](0);
        vm.prank(tester);
        bytes32 agentId = registry.registerAgent("Agent-D", agentOp, "src", caps);

        registry.suspendAgent(agentId, "concealing mistakes");
        (,,,, AIAgentRegistry.AgentStatus status1,,,,) = registry.getAgent(agentId);
        assertEq(uint256(status1), uint256(AIAgentRegistry.AgentStatus.SUSPENDED));

        registry.reactivateAgent(agentId);
        (,,,, AIAgentRegistry.AgentStatus status2,,,,) = registry.getAgent(agentId);
        assertEq(uint256(status2), uint256(AIAgentRegistry.AgentStatus.ACTIVE));
    }

    function testAddAndRevokeCapability() public {
        string[] memory caps = new string[](1);
        caps[0] = "read";

        vm.prank(tester);
        bytes32 agentId = registry.registerAgent("Agent-E", agentOp, "src", caps);

        vm.prank(tester);
        registry.addCapability(agentId, "write");

        (,,, string[] memory capabilities1,,,,,) = registry.getAgent(agentId);
        assertEq(capabilities1.length, 2);

        vm.prank(tester);
        registry.revokeCapability(agentId, "read");

        (,,, string[] memory capabilities2,,,,,) = registry.getAgent(agentId);
        assertEq(capabilities2.length, 1);
        assertEq(capabilities2[0], "write");
    }

    function testInventoryAndProvenance() public {
        string[] memory caps = new string[](0);
        vm.prank(tester);
        bytes32 agentId = registry.registerAgent("Agent-F", agentOp, "OpenAI/GPT/2026", caps);

        bytes32[] memory inv = registry.getAgentInventory();
        assertEq(inv.length, 1);
        assertEq(inv[0], agentId);

        string memory prov = registry.verifyProvenance(agentId);
        assertEq(prov, "OpenAI/GPT/2026");
    }
}
