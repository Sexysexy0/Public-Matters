// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/ArcadeGovernance.sol";

contract ArcadeGovernanceTest is Test {
    ArcadeGovernance public arcade;

    function setUp() public {
        arcade = new ArcadeGovernance();
    }

    function testCreateAndVoteProposal() public {
        arcade.createProposal("Build the Wall Arcade");
        arcade.vote(0, true);

        address voter2 = address(0x2);
        vm.prank(voter2);
        arcade.vote(0, true);

        (,, uint256 votesFor, uint256 votesAgainst,) = arcade.proposals(0);
        assertEq(votesFor, 2, "Should have 2 votes for");
        assertEq(votesAgainst, 0, "Should have 0 votes against");
    }

    function testCannotVoteTwice() public {
        arcade.createProposal("No Double Voting");
        arcade.vote(0, true);

        vm.expectRevert("Already voted");
        arcade.vote(0, true);
    }

    function testExecuteProposal() public {
        arcade.createProposal("Execute This");

        // Vote 1: true (test address)
        arcade.vote(0, true);

        // Vote 2: false (address 0x2)
        address voter2 = address(0x2);
        vm.prank(voter2);
        arcade.vote(0, false);

        // Vote 3: true (address 0x3) - tiebreaker!
        address voter3 = address(0x3);
        vm.prank(voter3);
        arcade.vote(0, true);

        // Now: votesFor = 2, votesAgainst = 1 -> execute!
        arcade.execute(0);

        (,,,, bool executed) = arcade.proposals(0);
        assertTrue(executed, "Should be executed");
    }
}
