// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/EnergyScheduler.sol";

contract EnergySchedulerTest is Test {
    EnergyScheduler scheduler;

    function setUp() public {
        scheduler = new EnergyScheduler();
    }

    function testAssignTask() public {
        scheduler.assignTask("Deploy contract", EnergyScheduler.EnergyType.Mental, address(this));
        assertEq(scheduler.totalTasks(), 1);
    }
}
