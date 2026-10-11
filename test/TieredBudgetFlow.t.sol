// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivileges.sol";
import "../src/BudgetDeliberationRegistry.sol";
import "../src/TieredApproval.sol";

contract TieredBudgetFlowTest is Test {
    OperatorPrivileges privileges;
    BudgetDeliberationRegistry registry;

    address op1 = vm.addr(1);   // board member
    address op2 = vm.addr(2);   // board member
    address op3 = vm.addr(3);   // board member
    address op4 = vm.addr(4);   // stockholder only
    address proposer = vm.addr(10);

    function setUp() public {
        privileges = new OperatorPrivileges();
        registry = new BudgetDeliberationRegistry(address(privileges));

        privileges.addOperator(op1);
        privileges.addOperator(op2);
        privileges.addOperator(op3);
        privileges.addOperator(op4);

        // 3 board seats, 10000 bps (100%) of stockholder weight
        vm.prank(op1);
        registry.setComposition(3, 10000);
    }

    function testOperatorTierAlwaysPasses() public {
        vm.prank(op1);
        bytes32 id = registry.createProposal(
            "Small Bill", "other", 10 ether, proposer, TieredApproval.Tier.OPERATOR
        );

        vm.prank(op1);
        registry.startDeliberation(id);

        vm.prank(op1);
        registry.castVote(id, true);

        vm.prank(op1);
        registry.approveProposal(id, 10 ether);

        BudgetDeliberationRegistry.Proposal memory p = registry.getProposal(id);
        assertEq(uint8(p.stage), uint8(BudgetDeliberationRegistry.Stage.APPROVED));
        assertEq(uint8(p.requiredTier), uint8(TieredApproval.Tier.OPERATOR));
    }

    function testMajorityRequiresBoardAndStockholders() public {
        vm.prank(op1);
        bytes32 id = registry.createProposal(
            "Majority Bill", "other", 20 ether, proposer, TieredApproval.Tier.MAJORITY
        );

        vm.prank(op1);
        registry.startDeliberation(id);

        // 2 of 3 board
        vm.prank(op1); registry.castBoardVote(id, true);
        vm.prank(op2); registry.castBoardVote(id, true);

        // 6000 bps of stockholders (>50%)
        vm.prank(op4); registry.castStockholderVote(id, 6000, true);

        vm.prank(op1);
        registry.approveProposal(id, 20 ether);

        BudgetDeliberationRegistry.Proposal memory p = registry.getProposal(id);
        assertEq(uint8(p.stage), uint8(BudgetDeliberationRegistry.Stage.APPROVED));
    }

    function testRevertsWhenBoardThresholdNotMet() public {
        vm.prank(op1);
        bytes32 id = registry.createProposal(
            "Board short", "other", 20 ether, proposer, TieredApproval.Tier.MAJORITY
        );
        vm.prank(op1); registry.startDeliberation(id);

        // Only 1 of 3 board
        vm.prank(op1); registry.castBoardVote(id, true);

        // But plenty of stockholder weight
        vm.prank(op4); registry.castStockholderVote(id, 9000, true);

        vm.prank(op1);
        vm.expectRevert("Tier not achieved");
        registry.approveProposal(id, 20 ether);
    }

    function testRevertsWhenStockholderThresholdNotMet() public {
        vm.prank(op1);
        bytes32 id = registry.createProposal(
            "Stock short", "other", 20 ether, proposer, TieredApproval.Tier.MAJORITY
        );
        vm.prank(op1); registry.startDeliberation(id);

        // All 3 board vote yes
        vm.prank(op1); registry.castBoardVote(id, true);
        vm.prank(op2); registry.castBoardVote(id, true);
        vm.prank(op3); registry.castBoardVote(id, true);

        // Only 3000 bps of stockholders
        vm.prank(op4); registry.castStockholderVote(id, 3000, true);

        vm.prank(op1);
        vm.expectRevert("Tier not achieved");
        registry.approveProposal(id, 20 ether);
    }

    function testSupermajorityExactTwoThirds() public {
        vm.prank(op1);
        bytes32 id = registry.createProposal(
            "Super Bill", "other", 100 ether, proposer, TieredApproval.Tier.SUPERMAJORITY
        );
        vm.prank(op1); registry.startDeliberation(id);

        // 2 of 3 board (2/3 exactly)
        vm.prank(op1); registry.castBoardVote(id, true);
        vm.prank(op2); registry.castBoardVote(id, true);

        // 6667 bps (>= 2/3)
        vm.prank(op4); registry.castStockholderVote(id, 6667, true);

        vm.prank(op1);
        registry.approveProposal(id, 100 ether);

        BudgetDeliberationRegistry.Proposal memory p = registry.getProposal(id);
        assertEq(uint8(p.stage), uint8(BudgetDeliberationRegistry.Stage.APPROVED));
    }

    function testSupermajorityFailsAtHalfBoard() public {
        vm.prank(op1);
        bytes32 id = registry.createProposal(
            "Super half", "other", 100 ether, proposer, TieredApproval.Tier.SUPERMAJORITY
        );
        vm.prank(op1); registry.startDeliberation(id);

        // Only 1 of 3 board
        vm.prank(op1); registry.castBoardVote(id, true);

        // All stockholder weight
        vm.prank(op4); registry.castStockholderVote(id, 10000, true);

        vm.prank(op1);
        vm.expectRevert("Tier not achieved");
        registry.approveProposal(id, 100 ether);
    }

    function testSoleActorFlaggedWhenOneAddressHoldsBoth() public {
        // Give op1 sole 2/3 board AND 2/3 stockholder authority
        vm.prank(op1);
        registry.setComposition(3, 10000);

        vm.prank(op1);
        bytes32 id = registry.createProposal(
            "Solo super", "other", 100 ether, proposer, TieredApproval.Tier.SUPERMAJORITY
        );
        vm.prank(op1); registry.startDeliberation(id);

        // op1 casts both board votes (for 2 seats) and stockholder votes
        vm.prank(op1); registry.castBoardVote(id, true);
        vm.prank(op1); registry.castBoardVote(id, true);
        vm.prank(op1); registry.castStockholderVote(id, 9000, true);

        vm.prank(op1);
        registry.approveProposal(id, 100 ether);

        // soleActor should be flagged on the resolved action
        TieredApproval.Action memory a = registry.getAction(id);
        assertEq(a.soleActor, op1, "sole actor should be flagged");
        assertEq(uint8(a.required), uint8(TieredApproval.Tier.SUPERMAJORITY));
    }

    function testCoalitionNotFlaggedAsSole() public {
        vm.prank(op1);
        bytes32 id = registry.createProposal(
            "Coalition", "other", 100 ether, proposer, TieredApproval.Tier.SUPERMAJORITY
        );
        vm.prank(op1); registry.startDeliberation(id);

        // op1 one board vote, op2 one board vote -> 2/3
        vm.prank(op1); registry.castBoardVote(id, true);
        vm.prank(op2); registry.castBoardVote(id, true);

        // Only op4 stockholder vote
        vm.prank(op4); registry.castStockholderVote(id, 7000, true);

        vm.prank(op1);
        registry.approveProposal(id, 100 ether);

        TieredApproval.Action memory a = registry.getAction(id);
        assertEq(a.soleActor, address(0), "coalition should not be flagged");
    }

    function testCannotCreateWithNoneTier() public {
        vm.prank(op1);
        vm.expectRevert("requiredTier=NONE");
        registry.createProposal("Bad", "other", 1 ether, proposer, TieredApproval.Tier.NONE);
    }

    function testCannotApproveWithoutLegacyMajority() public {
        vm.prank(op1);
        bytes32 id = registry.createProposal(
            "Rejected", "other", 10 ether, proposer, TieredApproval.Tier.OPERATOR
        );
        vm.prank(op1); registry.startDeliberation(id);

        vm.prank(op1); registry.castVote(id, false);
        vm.prank(op2); registry.castVote(id, false);

        vm.prank(op1);
        vm.expectRevert("Majority did not approve");
        registry.approveProposal(id, 10 ether);
    }

    function testIsTierSatisfied() public {
        vm.prank(op1);
        bytes32 id = registry.createProposal(
            "View test", "other", 10 ether, proposer, TieredApproval.Tier.MAJORITY
        );
        vm.prank(op1); registry.startDeliberation(id);

        assertFalse(registry.isTierSatisfied(id));

        vm.prank(op1); registry.castBoardVote(id, true);
        vm.prank(op2); registry.castBoardVote(id, true);
        vm.prank(op4); registry.castStockholderVote(id, 6000, true);

        assertTrue(registry.isTierSatisfied(id));
    }
}
