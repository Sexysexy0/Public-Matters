// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/ConnorProtocol.sol";

contract ConnorProtocolTest is Test {
    ConnorProtocol connor;
    address payable zone = payable(address(0x3030));

    function setUp() public {
        connor = new ConnorProtocol{value: 1 ether}();
    }

    function test_FreedomStrike() public {
        uint256 balanceBefore = zone.balance;
        connor.freedomStrike(zone, 0.5 ether);
        
        assertTrue(connor.liberatedZones(zone));
        assertEq(zone.balance, balanceBefore + 0.5 ether);
        assertEq(connor.redistributedPool(), 0.5 ether);
    }

    function test_RevertWhenExceedsPool() public {
        vm.expectRevert("Insufficient pool for freedom strike.");
        connor.freedomStrike(zone, 2 ether);
    }
}
