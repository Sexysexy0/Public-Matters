// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivileges.sol";
import "../src/AIDecisionAudit.sol";
import "../src/BudgetDeliberationRegistry.sol";
import "../src/BudgetAuditIntegrator.sol";
import "../src/TieredApproval.sol";

contract BudgetAuditIntegratorTest is Test {
    OperatorPrivileges privileges;
    AIDecisionAudit audit;
    BudgetDeliberationRegistry budget;
    BudgetAuditIntegrator integrator;

    address op1 = vm.addr(1);
    address op2 = vm.addr(2);
    address proposer = vm.addr(10);

    function setUp() public {
        privileges = new OperatorPrivileges();
        audit = new AIDecisionAudit(address(privileges));
        budget = new BudgetDeliberationRegistry(address(privileges));

        privileges.addOperator(op1);
        privileges.addOperator(op2);

        integrator = new BudgetAuditIntegrator(address(privileges), address(audit), address(budget));
        privileges.addOperator(address(integrator));

        assertTrue(privileges.isOperator(address(integrator)), "integrator not registered");
    }

    function testAuditBudgetEvent() public {
        vm.prank(op1);
        bytes32 pid = budget.createProposal("Health 2027", "health", 100 ether, proposer, TieredApproval.Tier.OPERATOR);

        vm.prank(op1);
        budget.startDeliberation(pid);

        vm.prank(op1);
        budget.castVote(pid, true);
        vm.prank(op2);
        budget.castVote(pid, true);

        vm.prank(op1);
        budget.sealDeliberation(pid, keccak256("deliberation"));

        vm.prank(op1);
        budget.approveProposal(pid, 100 ether);

        vm.prank(op2);
        bytes32 decisionId = integrator.auditBudgetEvent(pid, "APPROVED", 100);

        AIDecisionAudit.Decision memory d = audit.getDecision(decisionId);
        assertEq(d.confidence, 100);
        assertEq(integrator.totalAudited(), 1);
    }

    function testAnyOperatorCanAudit() public {
        vm.prank(op1);
        bytes32 pid = budget.createProposal("Any op", "other", 1 ether, proposer, TieredApproval.Tier.OPERATOR);

        vm.prank(op1);
        integrator.auditBudgetEvent(pid, "PROPOSED", 0);

        vm.prank(op2);
        integrator.auditBudgetEvent(pid, "PROPOSED", 0);

        assertEq(integrator.getBudgetAuditCount(), 2);
    }

    function testAuditFullLifecycleConfidence() public {
        address voter3 = vm.addr(3);
        privileges.addOperator(voter3);

        vm.prank(op1);
        bytes32 pid = budget.createProposal("Infra 2027", "infra", 500 ether, proposer, TieredApproval.Tier.OPERATOR);

        vm.prank(op1);
        budget.startDeliberation(pid);

        vm.prank(op1);
        budget.castVote(pid, true);
        vm.prank(op2);
        budget.castVote(pid, false);
        vm.prank(voter3);
        budget.castVote(pid, true);

        vm.prank(op1);
        budget.sealDeliberation(pid, keccak256("deliberated"));

        vm.prank(op1);
        budget.approveProposal(pid, 500 ether);

        vm.prank(op1);
        bytes32 decisionId = integrator.auditFullLifecycle(pid);

        AIDecisionAudit.Decision memory d = audit.getDecision(decisionId);
        assertEq(d.confidence, 66);
    }

    function testStrangerCannotAudit() public {
        vm.prank(op1);
        bytes32 pid = budget.createProposal("Test", "other", 1 ether, proposer, TieredApproval.Tier.OPERATOR);

        address stranger = vm.addr(999);
        vm.prank(stranger);
        vm.expectRevert("Not an operator");
        integrator.auditBudgetEvent(pid, "PROPOSED", 50);
    }

    function testAuditTrailAccumulates() public {
        vm.prank(op1);
        bytes32 pid = budget.createProposal("Multi-stage", "edu", 50 ether, proposer, TieredApproval.Tier.OPERATOR);

        vm.prank(op1);
        integrator.auditBudgetEvent(pid, "PROPOSED", 0);

        vm.prank(op2);
        budget.startDeliberation(pid);

        vm.prank(op2);
        integrator.auditBudgetEvent(pid, "DELIBERATING", 0);

        vm.prank(op1);
        integrator.auditBudgetEvent(pid, "DELIBERATING", 0);

        assertEq(integrator.getBudgetAuditCount(), 3);
        bytes32[] memory trail = integrator.getBudgetAuditTrail();
        assertEq(trail.length, 3);
    }
}
