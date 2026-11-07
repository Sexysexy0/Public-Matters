// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivileges.sol";
import "../src/AgentTelemetryRegistry.sol";

contract AgentTelemetryRegistryTest is Test {
    OperatorPrivileges privileges;
    AgentTelemetryRegistry registry;
    address op = vm.addr(1);
    address stranger = vm.addr(2);
    bytes32 constant AGENT = keccak256("machiavelli-agent");

    function setUp() public {
        privileges = new OperatorPrivileges();
        registry = new AgentTelemetryRegistry(address(privileges));
        privileges.addOperator(op);
    }

    function testRecordTelemetry() public {
        vm.prank(op);
        uint256 id = registry.recordTelemetry(AGENT, "success", keccak256("metrics123"));

        assertEq(id, 1);
        assertEq(registry.totalRecords(), 1);

        (uint256 recId, bytes32 agentHash, string memory status, bytes32 metricsHash,,) = registry.records(1);
        assertEq(recId, 1);
        assertEq(agentHash, AGENT);
        assertEq(status, "success");
        assertEq(metricsHash, keccak256("metrics123"));
    }

    function testGetAgentRecords() public {
        vm.startPrank(op);
        registry.recordTelemetry(AGENT, "success", keccak256("metrics1"));
        registry.recordTelemetry(AGENT, "success", keccak256("metrics2"));
        vm.stopPrank();

        uint256[] memory ids = registry.getAgentRecords(AGENT);
        assertEq(ids.length, 2);
        assertEq(ids[0], 1);
        assertEq(ids[1], 2);
    }

    function testStrangerCannotRecord() public {
        vm.prank(stranger);
        vm.expectRevert("Not authorized operator");
        registry.recordTelemetry(AGENT, "hacked", keccak256("bad"));
    }
}
