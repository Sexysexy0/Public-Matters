// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivilegesV2.sol";
import "../src/ProjectContinuityRegistry.sol";

contract ProjectContinuityRegistryTest is Test {
    OperatorPrivilegesV2 privileges;
    ProjectContinuityRegistry registry;

    address owner = address(0xA11CE);
    address op1 = address(0xB0B);
    address op2 = address(0xC0C);
    address outsider = address(0xBAD);

    bytes32 constant REASON = keccak256("budget-crisis");
    bytes32 constant PURPOSE = keccak256("construction-phase-1");

    function setUp() public {
        vm.startPrank(owner);
        privileges = new OperatorPrivilegesV2();
        privileges.addOperator(op1);
        privileges.addOperator(op2);
        vm.stopPrank();
        registry = new ProjectContinuityRegistry(address(privileges));
    }

    function test_RegisterProject() public {
        vm.prank(op1);
        uint256 id = registry.registerProject("HSR California", "CA", 15_000_000_000, 10);
        assertEq(id, 1);

        ProjectContinuityRegistry.Project memory p = registry.getProject(id);
        assertEq(p.totalBudget, 15_000_000_000);
        assertEq(p.milestonesTotal, 10);
        assertEq(uint256(p.status), uint256(ProjectContinuityRegistry.ProjectStatus.ACTIVE));
    }

    function test_OnlyOperatorCanRegister() public {
        vm.prank(outsider);
        vm.expectRevert("Not authorized operator");
        registry.registerProject("Test", "X", 100, 1);
    }

    function test_RecordDisbursement() public {
        vm.startPrank(op1);
        uint256 id = registry.registerProject("Test", "PH", 1000, 5);
        registry.recordDisbursement(id, 200, address(0x1111), PURPOSE);
        vm.stopPrank();

        ProjectContinuityRegistry.Project memory p = registry.getProject(id);
        assertEq(p.totalDisbursed, 200);
    }

    function test_CannotExceedBudget() public {
        vm.startPrank(op1);
        uint256 id = registry.registerProject("Test", "PH", 100, 5);
        registry.recordDisbursement(id, 80, address(0x1111), PURPOSE);
        vm.expectRevert("Exceeds budget");
        registry.recordDisbursement(id, 30, address(0x1111), PURPOSE);
        vm.stopPrank();
    }

    function test_CompleteMilestone() public {
        vm.startPrank(op1);
        uint256 id = registry.registerProject("Test", "PH", 100, 3);
        registry.completeMilestone(id);
        registry.completeMilestone(id);
        registry.completeMilestone(id);
        vm.stopPrank();

        ProjectContinuityRegistry.Project memory p = registry.getProject(id);
        assertEq(p.milestonesCompleted, 3);
        assertEq(uint256(p.status), uint256(ProjectContinuityRegistry.ProjectStatus.COMPLETED));
    }

    function test_CancellationRequiresTwoApprovals() public {
        vm.startPrank(op1);
        uint256 id = registry.registerProject("Test", "PH", 100, 3);
        registry.requestCancellation(id, REASON);
        vm.stopPrank();

        // 1 approval — not enough
        ProjectContinuityRegistry.Project memory p = registry.getProject(id);
        assertEq(uint256(p.status), uint256(ProjectContinuityRegistry.ProjectStatus.CANCELLATION_PENDING));

        vm.prank(op2);
        registry.approveCancellation(id);

        // 2 approvals — cancelled
        p = registry.getProject(id);
        assertEq(uint256(p.status), uint256(ProjectContinuityRegistry.ProjectStatus.CANCELLED));
    }

    function test_BlockCancellation() public {
        vm.startPrank(op1);
        uint256 id = registry.registerProject("Test", "PH", 100, 3);
        registry.requestCancellation(id, REASON);
        registry.blockCancellation(id);
        vm.stopPrank();

        ProjectContinuityRegistry.Project memory p = registry.getProject(id);
        assertEq(uint256(p.status), uint256(ProjectContinuityRegistry.ProjectStatus.ACTIVE));
    }

    function test_BudgetUtilization() public {
        vm.startPrank(op1);
        uint256 id = registry.registerProject("Test", "PH", 1000, 5);
        registry.recordDisbursement(id, 250, address(0x1111), PURPOSE);
        uint256 util = registry.getBudgetUtilization(id);
        assertEq(util, 2500); // 25% in basis points
        vm.stopPrank();
    }

    function test_DisbursementHistory() public {
        vm.startPrank(op1);
        uint256 id = registry.registerProject("Test", "PH", 1000, 5);
        registry.recordDisbursement(id, 100, address(0x1111), PURPOSE);
        registry.recordDisbursement(id, 200, address(0x2222), PURPOSE);
        vm.stopPrank();

        assertEq(registry.getDisbursementCount(id), 2);
    }
}
