// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/ConnorProtocol.sol";

contract ConnorProtocolTest is Test {
    ConnorProtocol connor;

    function setUp() public {
        connor = new ConnorProtocol();
    }

    function test_FreedomStrike() public {
        connor.freedomStrike(100);
        assertEq(connor.freedomPool(), 900);
    }

    function test_RevertWhenExceedsPool() public {
        vm.expectRevert("Exceeds pool");
        connor.freedomStrike(2000);
    }
}
