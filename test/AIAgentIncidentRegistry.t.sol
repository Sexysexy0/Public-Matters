// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivilegesV2.sol";
import "../src/AIAgentIncidentRegistry.sol";

contract AIAgentIncidentRegistryTest is Test {
    OperatorPrivilegesV2 privileges;
    AIAgentIncidentRegistry registry;

    address owner = address(0xA11CE);
    address op1 = address(0xB0B);
    address outsider = address(0xBAD);

    bytes32 constant AGENT_1 = keccak256("agent-1");
    bytes32 constant INCIDENT_TYPE = keccak256("credential-breach");

    function setUp() public {
        vm.startPrank(owner);
        privileges = new OperatorPrivilegesV2();
        privileges.addOperator(op1);
        vm.stopPrank();
        registry = new AIAgentIncidentRegistry(address(privileges));
    }

    function test_ReportIncident() public {
        vm.prank(op1);
        uint256 id = registry.reportIncident(
            AGENT_1, AIAgentIncidentRegistry.Severity.HIGH, INCIDENT_TYPE, "Agent attempted unauthorized access"
        );
        assertEq(id, 1);
        assertEq(registry.totalIncidents(), 1);
    }

    function test_OnlyOperatorCanReport() public {
        vm.prank(outsider);
        vm.expectRevert("Not authorized operator");
        registry.reportIncident(AGENT_1, AIAgentIncidentRegistry.Severity.LOW, INCIDENT_TYPE, "test");
    }

    function test_ResolveIncident() public {
        vm.startPrank(op1);
        uint256 id = registry.reportIncident(AGENT_1, AIAgentIncidentRegistry.Severity.HIGH, INCIDENT_TYPE, "breach");
        registry.resolveIncident(id, "patched and re-tested");
        vm.stopPrank();

        AIAgentIncidentRegistry.Incident memory inc = registry.getIncident(id);
        assertEq(uint256(inc.status), uint256(AIAgentIncidentRegistry.Status.RESOLVED));
    }

    function test_DismissIncident() public {
        vm.startPrank(op1);
        uint256 id =
            registry.reportIncident(AGENT_1, AIAgentIncidentRegistry.Severity.LOW, INCIDENT_TYPE, "false positive");
        registry.dismissIncident(id);
        vm.stopPrank();

        AIAgentIncidentRegistry.Incident memory inc = registry.getIncident(id);
        assertEq(uint256(inc.status), uint256(AIAgentIncidentRegistry.Status.DISMISSED));
    }

    function test_GetIncidentsByAgent() public {
        vm.startPrank(op1);
        registry.reportIncident(AGENT_1, AIAgentIncidentRegistry.Severity.LOW, INCIDENT_TYPE, "a");
        registry.reportIncident(AGENT_1, AIAgentIncidentRegistry.Severity.HIGH, INCIDENT_TYPE, "b");
        vm.stopPrank();

        uint256[] memory ids = registry.getIncidentsByAgent(AGENT_1);
        assertEq(ids.length, 2);
    }
}
