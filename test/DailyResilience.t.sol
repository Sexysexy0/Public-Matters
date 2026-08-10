// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/DailyResilience.sol";

contract DailyResilienceTest is Test {
    DailyResilience public daily;
    address public emperor = address(this);

    function setUp() public {
        daily = new DailyResilience("Sovereign Initialization");
    }

    function test_DailyMessageFlow() public {
        vm.prank(emperor);
        daily.setMessage("Keep going. You are not alone.");

        (string memory todaysMessage, uint256 updatedTime) = daily.getTodaysMessage();
        assertEq(todaysMessage, "Keep going. You are not alone.");
        assertEq(updatedTime, block.timestamp);
    }
}
