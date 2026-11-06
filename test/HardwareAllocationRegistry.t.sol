// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivileges.sol";
import "../src/HardwareAllocationRegistry.sol";

contract HardwareAllocationRegistryTest is Test {
    OperatorPrivileges privileges;
    HardwareAllocationRegistry registry;
    address op = vm.addr(1);

    function setUp() public {
        privileges = new OperatorPrivileges();
        registry = new HardwareAllocationRegistry(address(privileges));
        privileges.addOperator(op);
    }

    function testRegisterAndDistribute() public {
        bytes32 batchId = keccak256("batch-2027");
        vm.startPrank(op);
        registry.registerBatch(batchId, keccak256("switch-cart"), 1000000, keccak256("global"));
        registry.distributeBatch(batchId, 500000, keccak256("north-america"));
        vm.stopPrank();

        (,, uint256 man, uint256 dist,,) = registry.batches(batchId);
        assertEq(man, 1000000);
        assertEq(dist, 500000);
    }
}
