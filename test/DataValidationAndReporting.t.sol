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
    // ... rest of the tests
}
