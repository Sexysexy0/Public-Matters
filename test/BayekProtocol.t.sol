// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/BayekProtocol.sol";

contract BayekProtocolTest is Test {
    BayekProtocol bayek;

    function setUp() public {
        bayek = new BayekProtocol("Nothing is true, everything is permitted.");
    }

    function test_FoundCreed() public {
        bayek.foundCreed("We work in the dark to serve the light.");
        assertEq(bayek.creedCore(), "We work in the dark to serve the light.");
        assertTrue(bayek.creedLocked());
    }

    function test_RevertWhenAlreadyLocked() public {
        bayek.foundCreed("First founding.");
        vm.expectRevert("Creed is already locked permanently.");
        bayek.foundCreed("Second founding.");
    }
}
