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
        // deploy governance token
        token = new TAPToken();
        // deploy TAP contract
        tap = new TAP(address(token));
        // transfer ownership of token to TAP for mint/burn
        token.transferOwnership(address(tap));

        // mint governance tokens
        token.mint(alice, 100 ether);
        token.mint(bob, 50 ether);
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
        assertEq(props[0].description, "Proposal 1: Transparency Policy");

        vm.startPrank(alice);
        tap.vote(1, true);
        vm.stopPrank();

        vm.startPrank(bob);
        tap.vote(1, false);
        vm.stopPrank();

        // fast forward time
        vm.warp(block.timestamp + 2 days);

        tap.executeProposal(1);
        props = tap.getProposals();
        assertTrue(props[0].executed);
    }

    function testPenaltyAndReward() public {
        uint256 aliceBalanceBefore = token.balanceOf(alice);

        // apply penalty
        tap.applyPenalty(alice, 10 ether);
        uint256 aliceBalanceAfterPenalty = token.balanceOf(alice);
        assertEq(aliceBalanceAfterPenalty, aliceBalanceBefore - 10 ether);

        // issue reward
        tap.issueReward(bob, 20 ether);
        uint256 bobBalance = token.balanceOf(bob);
        assertEq(bobBalance, 70 ether);
    }
}
