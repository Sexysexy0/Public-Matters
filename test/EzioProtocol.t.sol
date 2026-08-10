// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/EzioProtocol.sol";

contract EzioProtocolTest is Test {
    EzioProtocol ezio;
    address apprentice = address(0x1234);

    function setUp() public {
        ezio = new EzioProtocol();
    }

    function test_MentorApprentice() public {
        ezio.mentorApprentice(apprentice);
        assertTrue(ezio.apprentices(apprentice));
    }

    function test_RevertWhenNonMentorCalls() public {
        vm.prank(apprentice);
        vm.expectRevert("Only mentor");
        ezio.mentorApprentice(apprentice);
    }
}
