// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/DataValidationAndReporting.sol";

contract DataValidationAndReportingTest is Test {
    DataValidationAndReporting public registry;

    address admin = address(1);
    address operator = address(2);

    function setUp() public {
        vm.prank(admin);
        registry = new DataValidationAndReporting();

        vm.prank(admin);
        registry.assignRole(operator, DataValidationAndReporting.Role.FieldOperator);
    }

    function test_RegisterParticipantAndRecordMetric() public {
        vm.prank(operator);
        bytes32 pId = registry.registerParticipant(keccak256("raw_input"), "metadata");

        vm.prank(operator);
        registry.recordMetric(pId, 100, 500, keccak256("proof"));

        DataValidationAndReporting.OutcomeMetric[] memory metrics = registry.getParticipantMetrics(pId);
        assertEq(metrics.length, 1);
        assertEq(metrics[0].value, 500);
    }

    function test_RevertWhen_UnauthorizedRegistration() public {
        vm.prank(address(99));
        vm.expectRevert("Unauthorized: Insufficient role");
        registry.registerParticipant(keccak256("raw_input"), "metadata");
    }
}
