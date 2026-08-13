// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/ExecutivePipeline.sol";

contract ExecutivePipelineTest is Test {
    ExecutivePipeline pipeline;

    function setUp() public {
        pipeline = new ExecutivePipeline();
    }

    function testAssignRoleAndExpiry() public {
        bytes32 roleId = keccak256("Manager");
        pipeline.assignRole(roleId, address(this), 5);
        vm.roll(block.number + 10);
        pipeline.checkExpiry(roleId);
    }
}
