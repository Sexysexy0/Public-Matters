// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/SimpleTimelock.sol";

contract SimpleTimelockTest is Test {
    SimpleTimelock timelock;
    uint256 delay = 2 hours;
    address target = address(0xBEEF);

    function setUp() public {
        timelock = new SimpleTimelock(delay);
        vm.deal(address(timelock), 1 ether);
    }

    function testQueueAndExecuteAfterDelay() public {
        bytes memory data = "";
        uint256 salt = 123;
        bytes32 h = timelock.queue(target, 0.01 ether, data, salt);
        // cannot execute immediately
        vm.expectRevert();
        timelock.execute(target, 0.01 ether, data, salt);
        // fast forward time
        vm.warp(block.timestamp + delay + 1);
        timelock.execute(target, 0.01 ether, data, salt);
        // event emission validated by not reverting
    }

    function testCancelBeforeExecute() public {
        bytes memory data = "";
        uint256 salt = 456;
        timelock.queue(target, 0, data, salt);
        timelock.cancel(target, 0, data, salt);
        vm.expectRevert();
        timelock.execute(target, 0, data, salt);
    }
}
