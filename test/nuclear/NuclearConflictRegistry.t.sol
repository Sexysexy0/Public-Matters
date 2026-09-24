// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

import {Test, console} from "forge-std/Test.sol";
import {NuclearConflictRegistry} from "../../src/NuclearConflictRegistry.sol";

contract NuclearConflictRegistryTest is Test {
    NuclearConflictRegistry public registry;
    address public steward = address(0x1111111111111111111111111111111111111111);

    function setUp() public {
        vm.startPrank(steward);
        registry = new NuclearConflictRegistry();
        vm.stopPrank();
    }

    function testDeclareAndVerifyIncident() public {
        bytes32 subjectId = keccak256("incident-genesis-01");
        
        vm.startPrank(steward);
        // Step 1: Capture the assigned incremental unit256 identifier returned by the registry
        uint256 assignedId = registry.declareIncident(subjectId);
        vm.stopPrank();

        // Step 2: Unpack the complete 4-component property layout using the assigned integer key
        (uint64 declaredAt, bool structuralStatus, bytes32 verificationProof, bytes32 trackedSubject) = registry.incidents(assignedId);

        // forge-lint: disable-next-line(block-timestamp)
        assertEq(declaredAt, uint64(block.timestamp));
        assertTrue(structuralStatus);
        assertEq(verificationProof, bytes32(0));
        assertEq(trackedSubject, subjectId);
        console.log("Nuclear registry structural tuple unpacking validated successfully.");
    }
}
