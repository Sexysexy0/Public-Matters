// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivileges.sol";
import "../src/WorkerDeploymentRegistry.sol";

contract WorkerDeploymentRegistryTest is Test {
    OperatorPrivileges privileges;
    WorkerDeploymentRegistry registry;
    address op = vm.addr(1);
    bytes32 W1 = keccak256("worker1");
    bytes32 F1 = keccak256("facility1");

    function setUp() public {
        privileges = new OperatorPrivileges();
        registry = new WorkerDeploymentRegistry(address(privileges));
        privileges.addOperator(op);
    }

    function testRegisterAndAssign() public {
        vm.startPrank(op);
        registry.registerWorker(W1, keccak256("data"));
        registry.assignToFacility(W1, F1);
        vm.stopPrank();

        assertEq(registry.activeWorkerCount(F1), 1);
    }

    function testUnassignDoesNotDelete() public {
        vm.startPrank(op);
        registry.registerWorker(W1, keccak256("data"));
        registry.assignToFacility(W1, F1);
        registry.unassignWorker(W1, keccak256("optimized-out"));
        vm.stopPrank();

        // Still exists on-chain
        (,,, , WorkerDeploymentRegistry.WorkerStatus status,) = registry.workers(W1);
        assertEq(uint8(status), uint8(WorkerDeploymentRegistry.WorkerStatus.UNASSIGNED));
        assertEq(registry.activeWorkerCount(F1), 0);
    }
}
