// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/EzioProtocol.sol";

contract EzioProtocolTest is Test {
    EzioProtocol ezio;
    address student = address(0x2026);

    function setUp() public {
        ezio = new EzioProtocol();
    }

    function test_MentorApprentice() public {
        ezio.mentor(student);
        assertTrue(ezio.apprentices(student));
        assertEq(ezio.wisdomTokens(student), 50);
    }

    function test_RevertWhenNonMentorCalls() public {
        vm.prank(student);
        vm.expectRevert("Unauthorized: Only the Master Mentor can call this.");
        ezio.mentor(student);
    }
}
