// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/BayekProtocol.sol";

contract BayekProtocolTest is Test {
    BayekProtocol bayek;

    function setUp() public {
        bayek = new BayekProtocol();
    }

    function test_FoundCreed() public {
        bayek.foundCreed();
        assertTrue(bayek.creedLocked());
    }

    function test_RevertWhenAlreadyLocked() public {
        bayek.foundCreed();
        vm.expectRevert("Already locked");
        bayek.foundCreed();
    }
}
