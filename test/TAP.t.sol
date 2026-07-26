// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/TAP.sol";

contract TAPTest is Test {
    TAPToken token;
    TAP tap;
    address alice = address(0x1);
    address bob = address(0x2);

    function setUp() public {
        // deploy governance token with this contract as owner
        token = new TAPToken(address(this));

        // deploy TAP contract with token + owner
        tap = new TAP(address(token), address(this));

        // transfer ownership of token to TAP for mint/burn
        vm.startPrank(address(this));
        token.transferOwnership(address(tap));
        vm.stopPrank();

        // mint governance tokens (TAP is now the owner of token)
        vm.startPrank(address(tap));
        token.mint(alice, 100 ether);
        token.mint(bob, 50 ether);
        vm.stopPrank();
    }

    function testLogDisclosure() public {
        vm.startPrank(alice);
        tap.logDisclosure("Lobbying disclosure by Alice");
        vm.stopPrank();

        TAP.Disclosure[] memory logs = tap.getDisclosures();
        assertEq(logs.length, 1);
        assertEq(logs[0].submitter, alice);
    }

    function testCreateAndVoteProposal() public {
        vm.startPrank(alice);
        tap.createProposal("Proposal 1: Transparency Policy", 1 days);
        vm.stopPrank();

        TAP.Proposal[] memory props = tap.getProposals();
        assertEq(props.length, 1);

        vm.startPrank(alice);
        tap.vote(1, true);
        vm.stopPrank();

        vm.startPrank(bob);
        tap.vote(1, false);
        vm.stopPrank();

        vm.warp(block.timestamp + 2 days);
        tap.executeProposal(1);

        props = tap.getProposals();
        assertTrue(props[0].executed);
    }

    function testPenaltyAndReward() public {
        uint256 aliceBalanceBefore = token.balanceOf(alice);

        vm.startPrank(address(this));
        tap.applyPenalty(alice, 10 ether);
        vm.stopPrank();

        uint256 aliceBalanceAfterPenalty = token.balanceOf(alice);
        assertEq(aliceBalanceAfterPenalty, aliceBalanceBefore - 10 ether);

        vm.startPrank(address(this));
        tap.issueReward(bob, 20 ether);
        vm.stopPrank();

        uint256 bobBalance = token.balanceOf(bob);
        assertEq(bobBalance, 70 ether);
    }

    // --- Negative Cases using custom error ---
    function test_RevertWhenNonOwnerMints() public {
        vm.startPrank(alice);
        vm.expectRevert(
            abi.encodeWithSelector(Ownable.OwnableUnauthorizedAccount.selector, alice)
        );
        token.mint(alice, 10 ether);
        vm.stopPrank();
    }

    function test_RevertWhenNonOwnerBurns() public {
        vm.startPrank(bob);
        vm.expectRevert(
            abi.encodeWithSelector(Ownable.OwnableUnauthorizedAccount.selector, bob)
        );
        token.burn(alice, 5 ether);
        vm.stopPrank();
    }

    function test_RevertWhenNonOwnerAppliesPenalty() public {
        vm.startPrank(alice);
        vm.expectRevert(
            abi.encodeWithSelector(Ownable.OwnableUnauthorizedAccount.selector, alice)
        );
        tap.applyPenalty(bob, 5 ether);
        vm.stopPrank();
    }

    function test_RevertWhenNonOwnerIssuesReward() public {
        vm.startPrank(bob);
        vm.expectRevert(
            abi.encodeWithSelector(Ownable.OwnableUnauthorizedAccount.selector, bob)
        );
        tap.issueReward(alice, 5 ether);
        vm.stopPrank();
    }
}
