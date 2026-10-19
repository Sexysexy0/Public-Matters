// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivileges.sol";
import "../contracts/CorporateUBOControl.sol";

contract CorporateUBOControlTest is Test {
    OperatorPrivileges privileges;
    CorporateUBOControl ubo;

    address op1 = vm.addr(1);
    address op2 = vm.addr(2);
    address beneficiaryA = vm.addr(3);
    address beneficiaryB = vm.addr(4);
    address beneficiaryC = vm.addr(5);

    bytes32 constant ENTITY = keccak256("entity-acme-corp");

    function setUp() public {
        privileges = new OperatorPrivileges();
        ubo = new CorporateUBOControl(address(privileges));
        privileges.addOperator(op1);
        privileges.addOperator(op2);
    }

    function testRecordSingleUBO() public {
        vm.prank(op1);
        uint256 index = ubo.recordUBO(ENTITY, beneficiaryA, 4000, "Acme Corp");

        assertEq(index, 0);
        assertEq(ubo.getUBOCount(ENTITY), 1);
        assertEq(ubo.totalPercentage(ENTITY), 4000);
    }

    function testMultipleUBOsPerEntity() public {
        vm.prank(op1);
        ubo.recordUBO(ENTITY, beneficiaryA, 3000, "Acme Corp");
        vm.prank(op1);
        ubo.recordUBO(ENTITY, beneficiaryB, 2500, "Acme Corp");
        vm.prank(op1);
        ubo.recordUBO(ENTITY, beneficiaryC, 2000, "Acme Corp");

        (uint256 count, uint256 total) = ubo.getEntitySummary(ENTITY);
        assertEq(count, 3);
        assertEq(total, 7500);
    }

    function testAggregateCannotExceed100Percent() public {
        vm.prank(op1);
        ubo.recordUBO(ENTITY, beneficiaryA, 6000, "Acme Corp");

        vm.prank(op1);
        vm.expectRevert("aggregate exceeds 10000 bps");
        ubo.recordUBO(ENTITY, beneficiaryB, 5000, "Acme Corp");
    }

    function testAggregateAllowsExact100() public {
        vm.prank(op1);
        ubo.recordUBO(ENTITY, beneficiaryA, 5000, "Acme Corp");
        vm.prank(op1);
        ubo.recordUBO(ENTITY, beneficiaryB, 5000, "Acme Corp");

        (, uint256 total) = ubo.getEntitySummary(ENTITY);
        assertEq(total, 10000);
    }

    function testCannotRecordZeroPercentage() public {
        vm.prank(op1);
        vm.expectRevert("percentage out of range");
        ubo.recordUBO(ENTITY, beneficiaryA, 0, "Acme Corp");
    }

    function testCannotRecordZeroBeneficiary() public {
        vm.prank(op1);
        vm.expectRevert("beneficiary=0");
        ubo.recordUBO(ENTITY, address(0), 3000, "Acme Corp");
    }

    function testStrangerCannotRecord() public {
        vm.prank(beneficiaryA);
        vm.expectRevert("Not authorized operator");
        ubo.recordUBO(ENTITY, beneficiaryA, 3000, "Acme Corp");
    }

    function testRecorderCannotVerifyOwn() public {
        vm.prank(op1);
        ubo.recordUBO(ENTITY, beneficiaryA, 4000, "Acme Corp");

        vm.prank(op1);
        vm.expectRevert("Verifier must differ from recorder");
        ubo.verifyUBO(ENTITY, 0, true);
    }

    function testIndependentOperatorCanVerify() public {
        vm.prank(op1);
        ubo.recordUBO(ENTITY, beneficiaryA, 4000, "Acme Corp");

        vm.prank(op2);
        ubo.verifyUBO(ENTITY, 0, true);

        CorporateUBOControl.UBORecord memory r = ubo.getUBO(ENTITY, 0);
        assertTrue(r.verified);
        assertEq(r.verifier, op2);
    }

    function testCannotVerifyMissingUBO() public {
        vm.prank(op2);
        vm.expectRevert("UBO not found");
        ubo.verifyUBO(ENTITY, 0, true);
    }

    function testConstructorRejectsZero() public {
        vm.expectRevert("privileges=0");
        new CorporateUBOControl(address(0));
    }
}
