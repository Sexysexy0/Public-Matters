// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/ArcadeGovernance.sol";

contract ArcadeGovernanceTest is Test {
    ArcadeGovernance gov;

    function setUp() public {
        gov = new ArcadeGovernance();
    }

    function testCreateAndVoteProposal() public {
        gov.createProposal("Build the Wall Arcade");
        gov.vote(0, true);
        gov.vote(0, true);
        gov.vote(0, false);

        (uint256 id, string memory desc, uint256 votesFor, uint256 votesAgainst, bool executed) = gov.proposals(0);
        assertEq(id, 0);
        assertEq(desc, "Build the Wall Arcade");
        assertEq(votesFor, 2);
        assertEq(votesAgainst, 1);
        assertEq(executed, false);
    }

    function testExecuteProposal() public {
        gov.createProposal("Save the Children Fund");
        gov.vote(0, true);
        gov.execute(0);

        (, , , , bool executed) = gov.proposals(0);
        assertTrue(executed);
    }
}
