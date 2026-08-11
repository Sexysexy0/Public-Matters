// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/DataValidationAndReporting.sol";

contract DataValidationAndReportingTest is Test {
    DataValidationAndReporting public target;

    address admin = address(1);
    address operator = address(2);
    address auditor = address(3);

    function setUp() public {
        vm.prank(admin);
        target = new DataValidationAndReporting();

        vm.startPrank(admin);
        target.assignRole(operator, DataValidationAndReporting.Role.FieldOperator);
        target.assignRole(auditor, DataValidationAndReporting.Role.Auditor);
        vm.stopPrank();
    }

    function test_RegisterParticipantAndRecordMetric() public {
        vm.startPrank(operator);
        
        bytes32 pId = target.registerParticipant(keccak256("raw_data_sample"), "ipfs://bafybeicik...");
        
        bytes32 proofHash = keccak256("verification_proof");
        target.recordMetric(pId, 1, 100, proofHash);
        
        vm.stopPrank();

        DataValidationAndReporting.OutcomeMetric[] memory metrics = target.getParticipantMetrics(pId);
        assertEq(metrics.length, 1);
        assertEq(metrics[0].value, 100);
        assertEq(metrics[0].proofHash, proofHash);
    }

    function test_RevertWhen_UnauthorizedRegistration() public {
        vm.prank(address(99)); // Unauthorized user
        vm.expectRevert("Unauthorized: Insufficient role");
        target.registerParticipant(keccak256("unauthorized"), "ipfs://invalid");
    }
}
