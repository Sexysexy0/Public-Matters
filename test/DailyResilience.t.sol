// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/DailyResilience.sol";

contract DailyResilienceTest is Test {
    DailyResilience public daily;

    address public emperor = address(this);
    address public randomUser = makeAddr("randomUser");

    function setUp() public {
        daily = new DailyResilience("Keep going. You are not alone.");
    }

    function test_ReadAndUpdateMessage() public {
        (string memory msg,) = daily.getTodaysMessage();
        assertEq(msg, "Keep going. You are not alone.");

        daily.setMessage("You have survived 100% of your worst days.");
        (msg,) = daily.getTodaysMessage();
        assertEq(msg, "You have survived 100% of your worst days.");
    }

    function test_OnlyEmperorCanUpdate() public {
        vm.prank(randomUser);
        vm.expectRevert("Only the Emperor can update the message");
        daily.setMessage("Hack attempt!");
    }
}
