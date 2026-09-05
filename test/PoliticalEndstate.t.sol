// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/PoliticalEndstate.sol";

contract PoliticalEndstateTest is Test {
    PoliticalEndstate endstate;

    function setUp() public {
        endstate = new PoliticalEndstate();
    }

    function testFileProposalWithEndstate() public {
        endstate.fileProposal("Deploy governance module", "Ensure accountability");
        (string memory desc, string memory goal, address proposer) = endstate.proposals(0);
        assertEq(desc, "Deploy governance module");
        assertEq(goal, "Ensure accountability");
        assertEq(proposer, address(this));
    }

    function testRevertWhenEndstateMissing() public {
        vm.expectRevert(bytes("Endstate required"));
        endstate.fileProposal("Invalid proposal", "");
    }
}
