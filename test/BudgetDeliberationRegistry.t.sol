// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivileges.sol";
import "../src/BudgetDeliberationRegistry.sol";
import "../src/TieredApproval.sol";

contract BudgetDeliberationRegistryTest is Test {
    OperatorPrivileges privileges;
    BudgetDeliberationRegistry registry;
    address operator;
    address proposer;
    address voter1;
    address voter2;

    bytes32 proposalId;

    function setUp() public {
        privileges = new OperatorPrivileges();
        registry = new BudgetDeliberationRegistry(address(privileges));

        operator = vm.addr(1);
        proposer = vm.addr(2);
        voter1 = vm.addr(3);
        voter2 = vm.addr(4);

        privileges.addOperator(operator);
        privileges.addOperator(voter1);
        privileges.addOperator(voter2);
        privileges.addOperator(address(this));
    }

    function testFullLifecycle() public {
        // 1. Create
        vm.prank(operator);
        proposalId = registry.createProposal(
            "Universal Healthcare 2027",
            "health",
            100 ether,
            proposer,
            TieredApproval.Tier.OPERATOR
        );

        assertEq(registry.getProposalCount(), 1);

        // 2. Deliberate
        vm.prank(operator);
        registry.startDeliberation(proposalId);

        vm.prank(voter1);
        registry.castVote(proposalId, true);

        vm.prank(voter2);
        registry.castVote(proposalId, true);

        vm.prank(operator);
        registry.sealDeliberation(proposalId, keccak256("deliberation-record"));

        // 3. Approve
        vm.prank(operator);
        registry.approveProposal(proposalId, 100 ether);

        // 4. Disburse in tranches
        vm.prank(operator);
        registry.releaseDisbursement(
            proposalId, 50 ether, "Q1 Hospitals", keccak256("evidence-q1")
        );

        vm.prank(operator);
        registry.releaseDisbursement(
            proposalId, 50 ether, "Q2 Clinics", keccak256("evidence-q2")
        );

        // 5. Audit
        vm.prank(operator);
        registry.recordAudit(
            proposalId, keccak256("audit-report"), "PASSED - funds used as intended"
        );

        // Verify final state
        BudgetDeliberationRegistry.Proposal memory p = registry.getProposal(proposalId);
        assertEq(uint256(p.stage), uint256(BudgetDeliberationRegistry.Stage.AUDITED));
        assertEq(p.disbursedAmount, 100 ether);
        assertEq(p.votesFor, 2);
        assertEq(p.votesAgainst, 0);

        // Verify disbursements
        BudgetDeliberationRegistry.Disbursement[] memory ds = registry.getDisbursements(proposalId);
        assertEq(ds.length, 2);
        assertEq(ds[0].amount, 50 ether);
        assertEq(ds[1].amount, 50 ether);

        // Verify category totals
        (uint256 proposed, uint256 approved, uint256 disbursed) = registry.getCategorySummary("health");
        assertEq(proposed, 100 ether);
        assertEq(approved, 100 ether);
        assertEq(disbursed, 100 ether);
    }

    function testRejectProposal() public {
        vm.prank(operator);
        bytes32 id = registry.createProposal("Controversial Bill", "other", 50 ether, proposer, TieredApproval.Tier.OPERATOR);

        vm.prank(operator);
        registry.startDeliberation(id);

        vm.prank(operator);
        registry.rejectProposal(id, "No majority support");

        BudgetDeliberationRegistry.Proposal memory p = registry.getProposal(id);
        assertEq(uint256(p.stage), uint256(BudgetDeliberationRegistry.Stage.REJECTED));
    }

    function testCannotApproveWithoutMajority() public {
        vm.prank(operator);
        bytes32 id = registry.createProposal("Weak Bill", "other", 10 ether, proposer, TieredApproval.Tier.OPERATOR);

        vm.prank(operator);
        registry.startDeliberation(id);

        vm.prank(voter1);
        registry.castVote(id, false);
        vm.prank(voter2);
        registry.castVote(id, false);

        vm.prank(operator);
        vm.expectRevert("Majority did not approve");
        registry.approveProposal(id, 10 ether);
    }

    function testCannotOverDisburse() public {
        vm.prank(operator);
        bytes32 id = registry.createProposal("Small Fund", "edu", 5 ether, proposer, TieredApproval.Tier.OPERATOR);

        vm.prank(operator);
        registry.startDeliberation(id);
        vm.prank(voter1);
        registry.castVote(id, true);
        vm.prank(operator);
        registry.approveProposal(id, 5 ether);

        vm.prank(operator);
        vm.expectRevert("Disbursement exceeds approved amount");
        registry.releaseDisbursement(id, 10 ether, "attempt", bytes32(0));
    }

    function testUnauthorizedCannotCreate() public {
        address stranger = vm.addr(999);
        vm.prank(stranger);
        vm.expectRevert("Not authorized operator");
        registry.createProposal("Evil Bill", "other", 1000 ether, stranger, TieredApproval.Tier.OPERATOR);
    }

    function testCategoryAggregates() public {
        vm.startPrank(operator);
        registry.createProposal("Health A", "health", 10 ether, proposer, TieredApproval.Tier.OPERATOR);
        registry.createProposal("Health B", "health", 20 ether, proposer, TieredApproval.Tier.OPERATOR);
        registry.createProposal("Infra A", "infra", 30 ether, proposer, TieredApproval.Tier.OPERATOR);
        vm.stopPrank();

        (uint256 healthProposed, , ) = registry.getCategorySummary("health");
        (uint256 infraProposed, , ) = registry.getCategorySummary("infra");

        assertEq(healthProposed, 30 ether);
        assertEq(infraProposed, 30 ether);
    }
}
