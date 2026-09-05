// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/InspirationIntimidation.sol";

contract InspirationIntimidationTest is Test {
    InspirationIntimidation ii;

    function setUp() public {
        ii = new InspirationIntimidation();
    }

    function testFileProposalAndBalanceCheck() public {
        ii.fileProposal("Balanced proposal", 60, 40);
        assertTrue(ii.balanceCheck(0));
    }

    function testRevertWhenNoScores() public {
        vm.expectRevert(bytes("Scores required"));
        ii.fileProposal("Invalid", 0, 0);
    }
}
