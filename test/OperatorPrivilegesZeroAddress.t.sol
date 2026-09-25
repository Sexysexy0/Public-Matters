// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivileges.sol";
import "../src/OperatorPrivilegesV2.sol";

contract OperatorPrivilegesZeroAddressTest is Test {
    OperatorPrivileges private v1;
    OperatorPrivilegesV2 private v2;

    address private owner = address(0xA11CE);
    address private op1 = address(0x51);
    address private op2 = address(0x52);

    function setUp() public {
        vm.startPrank(owner);
        v1 = new OperatorPrivileges();
        v2 = new OperatorPrivilegesV2();
        vm.stopPrank();
    }

    function test_V1AddOperatorRejectsZeroAddress() public {
        vm.prank(owner);
        vm.expectRevert("Invalid operator");
        v1.addOperator(address(0));
    }

    function test_V1AddOperatorBatchRejectsZeroAddressAtomically() public {
        address[] memory operators = new address[](2);
        operators[0] = op1;
        operators[1] = address(0);

        vm.prank(owner);
        vm.expectRevert("Invalid operator");
        v1.addOperatorBatch(operators);

        assertFalse(v1.isOperator(op1));
        assertFalse(v1.isOperator(address(0)));
    }

    function test_V1AddOperatorBatchAddsValidOperators() public {
        address[] memory operators = new address[](2);
        operators[0] = op1;
        operators[1] = op2;

        vm.prank(owner);
        v1.addOperatorBatch(operators);

        assertTrue(v1.isOperator(op1));
        assertTrue(v1.isOperator(op2));
    }

    function test_V2AddOperatorRejectsZeroAddress() public {
        vm.prank(owner);
        vm.expectRevert("Invalid operator");
        v2.addOperator(address(0));
    }

    function test_V2AddOperatorBatchRejectsZeroAddressAtomically() public {
        address[] memory operators = new address[](2);
        operators[0] = op1;
        operators[1] = address(0);

        vm.prank(owner);
        vm.expectRevert("Invalid operator");
        v2.addOperatorBatch(operators);

        assertFalse(v2.isOperator(op1));
        assertFalse(v2.isOperator(address(0)));
    }

    function test_V2AddOperatorBatchAddsValidOperators() public {
        address[] memory operators = new address[](2);
        operators[0] = op1;
        operators[1] = op2;

        vm.prank(owner);
        v2.addOperatorBatch(operators);

        assertTrue(v2.isOperator(op1));
        assertTrue(v2.isOperator(op2));
    }
}
