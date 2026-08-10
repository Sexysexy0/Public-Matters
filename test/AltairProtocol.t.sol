// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/AltairProtocol.sol";

contract AltairProtocolTest is Test {
    AltairProtocol altair;
    address master = address(this);

    function setUp() public {
        altair = new AltairProtocol();
    }

    function test_DisciplineAndLock() public {
        altair.discipline();
        assertTrue(altair.locked());
    }

    function test_RevertWhenLocked() public {
        altair.discipline();
        vm.expectRevert("Already locked");
        altair.discipline();
    }
}
