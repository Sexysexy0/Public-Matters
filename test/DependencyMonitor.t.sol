// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/DependencyMonitor.sol";

contract DependencyMonitorTest is Test {
    DependencyMonitor public monitor;

    address public emperor = address(this);

    function setUp() public {
        monitor = new DependencyMonitor(bytes32(0));
    }

    function test_UpdateHash() public {
        bytes32 newHash = keccak256(abi.encodePacked("v1.0.0"));
        monitor.updateHash(newHash);
        assertEq(monitor.currentDependencyHash(), newHash);
    }

    function test_OnlyEmperorCanCall() public {
        vm.prank(makeAddr("attacker"));
        vm.expectRevert("Only the emperor");
        monitor.updateHash(bytes32(0));

        vm.prank(makeAddr("attacker"));
        vm.expectRevert("Only the emperor");
        monitor.reportCriticalDependency("hack");
    }
}
