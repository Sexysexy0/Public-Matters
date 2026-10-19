// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivileges.sol";
import "../src/ImmigrationProcessingRegistry.sol";

contract ImmigrationProcessingRegistryTest is Test {
    OperatorPrivileges privileges;
    ImmigrationProcessingRegistry registry;

    address operator = vm.addr(1);
    address stranger = vm.addr(2);

    bytes32 constant OFFICE_A = keccak256("office-uk-01");
    bytes32 constant OFFICE_B = keccak256("office-uk-02");
    bytes32 constant CAT_WORK = keccak256("category-work");
    bytes32 constant CAT_FAMILY = keccak256("category-family");
    bytes32 constant APPLICANT = keccak256("applicant-hash-1");
    bytes32 constant POLICY = keccak256("policy-2027");

    function setUp() public {
        privileges = new OperatorPrivileges();
        registry = new ImmigrationProcessingRegistry(address(privileges));
        privileges.addOperator(operator);
    }

    function _file(bytes32 office, bytes32 category) internal returns (bytes32) {
        vm.prank(operator);
        return registry.fileApplication(office, category, APPLICANT, POLICY, keccak256("evidence"));
    }

    function testFileApplication() public {
        bytes32 id = _file(OFFICE_A, CAT_WORK);
        ImmigrationProcessingRegistry.Application memory a = registry.getApplication(id);
        assertEq(a.officeHash, OFFICE_A);
        assertEq(a.categoryHash, CAT_WORK);
        assertEq(uint8(a.outcome), uint8(ImmigrationProcessingRegistry.Outcome.FILED));
        assertEq(registry.totalFiled(), 1);
    }

    function testStrangerCannotFile() public {
        vm.prank(stranger);
        vm.expectRevert("Not authorized operator");
        registry.fileApplication(OFFICE_A, CAT_WORK, APPLICANT, POLICY, bytes32(0));
    }

    function testCannotFileZeroOffice() public {
        vm.prank(operator);
        vm.expectRevert("officeHash=0");
        registry.fileApplication(bytes32(0), CAT_WORK, APPLICANT, POLICY, bytes32(0));
    }

    function testCannotFileZeroCategory() public {
        vm.prank(operator);
        vm.expectRevert("categoryHash=0");
        registry.fileApplication(OFFICE_A, bytes32(0), APPLICANT, POLICY, bytes32(0));
    }

    function testCannotFileZeroApplicant() public {
        vm.prank(operator);
        vm.expectRevert("applicantHash=0");
        registry.fileApplication(OFFICE_A, CAT_WORK, bytes32(0), POLICY, bytes32(0));
    }

    function testApprove() public {
        bytes32 id = _file(OFFICE_A, CAT_WORK);
        vm.prank(operator);
        registry.recordDecision(id, ImmigrationProcessingRegistry.Outcome.APPROVED, keccak256("approval"));

        ImmigrationProcessingRegistry.Application memory a = registry.getApplication(id);
        assertEq(uint8(a.outcome), uint8(ImmigrationProcessingRegistry.Outcome.APPROVED));
        assertEq(registry.totalApproved(), 1);
    }

    function testDeny() public {
        bytes32 id = _file(OFFICE_A, CAT_WORK);
        vm.prank(operator);
        registry.recordDecision(id, ImmigrationProcessingRegistry.Outcome.DENIED, keccak256("denial"));

        assertEq(registry.totalDenied(), 1);
    }

    function testCannotDecideTwice() public {
        bytes32 id = _file(OFFICE_A, CAT_WORK);
        vm.prank(operator);
        registry.recordDecision(id, ImmigrationProcessingRegistry.Outcome.APPROVED, keccak256("a"));
        vm.prank(operator);
        vm.expectRevert("Already decided");
        registry.recordDecision(id, ImmigrationProcessingRegistry.Outcome.DENIED, keccak256("d"));
    }

    function testAppealGrantedOnAppeal() public {
        bytes32 id = _file(OFFICE_A, CAT_WORK);
        vm.prank(operator);
        registry.recordDecision(id, ImmigrationProcessingRegistry.Outcome.DENIED, keccak256("d"));

        vm.prank(operator);
        registry.recordAppeal(id, ImmigrationProcessingRegistry.Outcome.GRANTED_ON_APPEAL, keccak256("a"));

        assertEq(registry.totalAppealed(), 1);
        assertEq(registry.totalGrantedOnAppeal(), 1);
    }

    function testCannotAppealApproved() public {
        bytes32 id = _file(OFFICE_A, CAT_WORK);
        vm.prank(operator);
        registry.recordDecision(id, ImmigrationProcessingRegistry.Outcome.APPROVED, keccak256("a"));

        vm.prank(operator);
        vm.expectRevert("Only denied applications can be appealed");
        registry.recordAppeal(id, ImmigrationProcessingRegistry.Outcome.GRANTED_ON_APPEAL, keccak256("a"));
    }

    function testOfficeApprovalRate() public {
        // 3 filed, 2 approved, 1 denied -> 2/3 = 6666 bps
        bytes32 id1 = _file(OFFICE_A, CAT_WORK);
        bytes32 id2 = _file(OFFICE_A, CAT_WORK);
        bytes32 id3 = _file(OFFICE_A, CAT_FAMILY);

        vm.startPrank(operator);
        registry.recordDecision(id1, ImmigrationProcessingRegistry.Outcome.APPROVED, bytes32(0));
        registry.recordDecision(id2, ImmigrationProcessingRegistry.Outcome.APPROVED, bytes32(0));
        registry.recordDecision(id3, ImmigrationProcessingRegistry.Outcome.DENIED, bytes32(0));
        vm.stopPrank();

        assertEq(registry.getOfficeApprovalRate(OFFICE_A), 6666);
    }

    function testOfficeStats() public {
        bytes32 id = _file(OFFICE_A, CAT_WORK);
        vm.startPrank(operator);
        registry.recordDecision(id, ImmigrationProcessingRegistry.Outcome.APPROVED, bytes32(0));
        vm.stopPrank();

        (uint256 filed, uint256 approved, uint256 denied, uint256 appealed) = registry.getOfficeStats(OFFICE_A);
        assertEq(filed, 1);
        assertEq(approved, 1);
        assertEq(denied, 0);
        assertEq(appealed, 0);
    }

    function testCategoryCount() public {
        _file(OFFICE_A, CAT_WORK);
        _file(OFFICE_A, CAT_WORK);
        _file(OFFICE_A, CAT_FAMILY);

        assertEq(registry.getCategoryCount(OFFICE_A, CAT_WORK), 2);
        assertEq(registry.getCategoryCount(OFFICE_A, CAT_FAMILY), 1);
    }

    function testTotals() public {
        bytes32 id = _file(OFFICE_A, CAT_WORK);
        vm.startPrank(operator);
        registry.recordDecision(id, ImmigrationProcessingRegistry.Outcome.DENIED, bytes32(0));
        registry.recordAppeal(id, ImmigrationProcessingRegistry.Outcome.GRANTED_ON_APPEAL, bytes32(0));
        vm.stopPrank();

        (uint256 filed,, uint256 denied, uint256 appealed, uint256 granted) = registry.getTotals();
        assertEq(filed, 1);
        assertEq(denied, 1);
        assertEq(appealed, 1);
        assertEq(granted, 1);
    }
}
