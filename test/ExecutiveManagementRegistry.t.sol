// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {ExecutiveManagementRegistry} from "../contracts/ExecutiveManagementRegistry.sol";

contract MockOperatorPrivileges {
    mapping(address => bool) public ops;
    function setOperator(address a, bool v) external { ops[a] = v; }
    function isOperator(address a) external view returns (bool) { return ops[a]; }
}

contract ExecutiveManagementRegistryTest is Test {
    ExecutiveManagementRegistry registry;
    MockOperatorPrivileges opv;
    address operator = address(0xB0b);
    address responsible = address(0xC1c);

    function setUp() public {
        opv = new MockOperatorPrivileges();
        registry = new ExecutiveManagementRegistry(address(opv));
        opv.setOperator(operator, true);
    }

    function test_ProposeApproveExecute() public {
        vm.prank(operator);
        uint256 did = registry.proposeDecision("Hire 5 devs", "Scale team", keccak256("evidence"), responsible);
        vm.prank(operator);
        registry.approveDecision(did);
        vm.prank(operator);
        registry.executeDecision(did);
        (, , , , , , , ExecutiveManagementRegistry.DecisionStatus status) = registry.decisions(did);
        assertEq(uint256(status), 2); // Executed
    }

    function test_FlagDecision() public {
        vm.prank(operator);
        uint256 did = registry.proposeDecision("Bad hire", "Wrong fit", keccak256("evidence"), responsible);
        vm.prank(operator);
        registry.flagDecision(did, "Overspend");
        (, , , , , , , ExecutiveManagementRegistry.DecisionStatus status) = registry.decisions(did);
        assertEq(uint256(status), 3); // Flagged
        assertEq(registry.flagCount(), 1);
    }

    function test_AddAndUpdateKpi() public {
        vm.prank(operator);
        uint256 kid = registry.addKpi("Revenue", 100 ether);
        vm.prank(operator);
        registry.updateKpi(kid, 120 ether);
        (, , uint256 actual, bool met) = registry.kpis(kid);
        assertEq(actual, 120 ether);
        assertTrue(met);
    }

    function test_LinkKpiToDecision() public {
        vm.prank(operator);
        uint256 did = registry.proposeDecision("Scale team", "Growth", keccak256("evidence"), responsible);
        vm.prank(operator);
        uint256 kid = registry.addKpi("Headcount", 10);
        vm.prank(operator);
        registry.linkKpiToDecision(did, kid);
        assertEq(registry.decisionKpiCount(did), 1);
    }

    function test_NonOperatorReverts() public {
        vm.prank(responsible);
        vm.expectRevert();
        registry.proposeDecision("Test", "Test", keccak256("evidence"), responsible);
    }

    function test_CloseDecision() public {
        vm.prank(operator);
        uint256 did = registry.proposeDecision("Test", "Test", keccak256("evidence"), responsible);
        vm.prank(operator);
        registry.closeDecision(did);
        (, , , , , , , ExecutiveManagementRegistry.DecisionStatus status) = registry.decisions(did);
        assertEq(uint256(status), 4); // Closed
    }
}
