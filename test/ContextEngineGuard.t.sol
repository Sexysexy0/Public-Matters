// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/GuardedResourcePool.sol";

contract ContextEngineGuardTest is Test {
    GuardedResourcePool pool;
    bytes32 constant VALID_CONTEXT = keccak256("CORE_PROTOCOL_V1");
    bytes32 constant INVALID_CONTEXT = keccak256("ROGUE_CONTEXT");

    function setUp() public {
        pool = new GuardedResourcePool(VALID_CONTEXT);
    }

    function test_ValidAllocation() public {
        pool.allocate(VALID_CONTEXT, 100 ether, msg.sender);
        assertEq(pool.totalAllocated(), 100 ether);
    }

    function test_RevertWhenInvalidContext() public {
        vm.expectRevert();
        pool.allocate(INVALID_CONTEXT, 100 ether, msg.sender);
    }

    function test_RevertWhenBaselineExceeded() public {
        vm.expectRevert();
        pool.allocate(VALID_CONTEXT, 1500 ether, msg.sender);
    }
}
