// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivileges.sol";
import "../src/TakedownReportRegistry.sol";

contract TakedownReportRegistryTest is Test {
    OperatorPrivileges privileges;
    TakedownReportRegistry registry;

    address op1 = vm.addr(1);
    address op2 = vm.addr(2);
    address reporter = vm.addr(3);
    address stranger = vm.addr(4);

    bytes32 constant SUBJECT = keccak256("subject-executive-1");
    bytes32 constant TARGET = keccak256("target-cloned-profile");
    bytes32 constant CHANNEL = keccak256("telegram");
    bytes32 constant EVIDENCE = keccak256("evidence-screenshot");
    bytes32 constant RESOLUTION = keccak256("resolution-deletion-proof");
    bytes32 constant EXTERNAL_PARTY = keccak256("telegram-abuse-desk");
    bytes32 constant CASE_NUM = keccak256("TG-12345");

    function setUp() public {
        privileges = new OperatorPrivileges();
        registry = new TakedownReportRegistry(address(privileges));
        privileges.addOperator(op1);
        privileges.addOperator(op2);
    }

    function _file() internal returns (bytes32) {
        vm.prank(reporter);
        return registry.fileReport(SUBJECT, TARGET, CHANNEL, EVIDENCE);
    }

    function testAnyoneCanFile() public {
        bytes32 id = _file();
        TakedownReportRegistry.Report memory r = registry.getReport(id);
        assertEq(r.subjectHash, SUBJECT);
        assertEq(r.targetHash, TARGET);
        assertEq(r.reporter, reporter);
        assertEq(uint8(r.status), uint8(TakedownReportRegistry.Status.REPORTED));
    }

    function testCannotFileZeroSubject() public {
        vm.prank(reporter);
        vm.expectRevert("subjectHash=0");
        registry.fileReport(bytes32(0), TARGET, CHANNEL, EVIDENCE);
    }

    function testCannotFileZeroTarget() public {
        vm.prank(reporter);
        vm.expectRevert("targetHash=0");
        registry.fileReport(SUBJECT, bytes32(0), CHANNEL, EVIDENCE);
    }

    function testCannotFileZeroChannel() public {
        vm.prank(reporter);
        vm.expectRevert("channelHash=0");
        registry.fileReport(SUBJECT, TARGET, bytes32(0), EVIDENCE);
    }

    function testMarkInProgress() public {
        bytes32 id = _file();
        vm.prank(op1);
        registry.markInProgress(id);

        TakedownReportRegistry.Report memory r = registry.getReport(id);
        assertEq(uint8(r.status), uint8(TakedownReportRegistry.Status.IN_PROGRESS));
    }

    function testMarkAwaitingPlatform() public {
        bytes32 id = _file();
        vm.prank(op1);
        registry.markAwaitingPlatform(id);

        TakedownReportRegistry.Report memory r = registry.getReport(id);
        assertEq(uint8(r.status), uint8(TakedownReportRegistry.Status.AWAITING_PLATFORM));
    }

    function testRequestApproval() public {
        bytes32 id = _file();
        vm.prank(op1);
        registry.requestApproval(id);

        TakedownReportRegistry.Report memory r = registry.getReport(id);
        assertEq(uint8(r.status), uint8(TakedownReportRegistry.Status.AWAITING_APPROVAL));
        assertEq(r.handler, op1);
    }

    function testConfirmTakedown() public {
        bytes32 id = _file();
        vm.prank(op1);
        registry.requestApproval(id);

        vm.prank(op2);
        registry.confirmTakedown(id, RESOLUTION);

        TakedownReportRegistry.Report memory r = registry.getReport(id);
        assertEq(uint8(r.status), uint8(TakedownReportRegistry.Status.TAKEN_DOWN));
        assertEq(r.resolutionHash, RESOLUTION);
        assertEq(r.approver, op2);
    }

    function testApproverMustDifferFromHandler() public {
        bytes32 id = _file();
        vm.prank(op1);
        registry.requestApproval(id);

        vm.prank(op1);
        vm.expectRevert("Approver must differ from handler");
        registry.confirmTakedown(id, RESOLUTION);
    }

    function testCannotConfirmWithoutApprovalRequest() public {
        bytes32 id = _file();
        vm.prank(op2);
        vm.expectRevert("Not awaiting approval");
        registry.confirmTakedown(id, RESOLUTION);
    }

    function testCannotConfirmZeroResolution() public {
        bytes32 id = _file();
        vm.prank(op1);
        registry.requestApproval(id);

        vm.prank(op2);
        vm.expectRevert("resolutionHash=0");
        registry.confirmTakedown(id, bytes32(0));
    }

    function testRecordExternalFiling() public {
        bytes32 id = _file();
        uint256 deadline = block.timestamp + 7 days;

        vm.prank(op1);
        registry.recordExternalFiling(id, EXTERNAL_PARTY, CASE_NUM, deadline);

        TakedownReportRegistry.Report memory r = registry.getReport(id);
        assertEq(r.reportedToHash, EXTERNAL_PARTY);
        assertEq(r.caseNumberHash, CASE_NUM);
        assertEq(r.deadlineAt, deadline);
        assertGt(r.filedAt, 0);
    }

    function testCannotExternalFileAfterClosure() public {
        bytes32 id = _file();
        vm.prank(op1);
        registry.dismissReport(id, keccak256("reason"));

        vm.prank(op1);
        vm.expectRevert("Cannot file externally after closure");
        registry.recordExternalFiling(id, EXTERNAL_PARTY, CASE_NUM, block.timestamp + 7 days);
    }

    function testCannotExternalFileZeroParty() public {
        bytes32 id = _file();
        vm.prank(op1);
        vm.expectRevert("reportedToHash=0");
        registry.recordExternalFiling(id, bytes32(0), CASE_NUM, block.timestamp + 7 days);
    }

    function testGetExternalPartyReport() public {
        bytes32 id = _file();
        vm.prank(op1);
        registry.recordExternalFiling(id, EXTERNAL_PARTY, CASE_NUM, block.timestamp + 7 days);

        uint256[7] memory byStatus = registry.getExternalPartyReport(EXTERNAL_PARTY);
        assertEq(byStatus[uint8(TakedownReportRegistry.Status.REPORTED)], 1);
    }

    function testDismissReport() public {
        bytes32 id = _file();
        vm.prank(op1);
        registry.dismissReport(id, keccak256("reason-false-positive"));

        TakedownReportRegistry.Report memory r = registry.getReport(id);
        assertEq(uint8(r.status), uint8(TakedownReportRegistry.Status.DISMISSED));
    }

    function testCannotDismissAfterTakedown() public {
        bytes32 id = _file();
        vm.prank(op1);
        registry.requestApproval(id);
        vm.prank(op2);
        registry.confirmTakedown(id, RESOLUTION);

        vm.prank(op1);
        vm.expectRevert("Cannot dismiss from this state");
        registry.dismissReport(id, keccak256("late"));
    }

    function testWithdrawBeforeTriage() public {
        bytes32 id = _file();
        vm.prank(reporter);
        registry.withdrawReport(id);

        TakedownReportRegistry.Report memory r = registry.getReport(id);
        assertEq(uint8(r.status), uint8(TakedownReportRegistry.Status.DISMISSED));
    }

    function testCannotWithdrawAfterTriage() public {
        bytes32 id = _file();
        vm.prank(op1);
        registry.markInProgress(id);

        vm.prank(reporter);
        vm.expectRevert("Cannot withdraw after triage");
        registry.withdrawReport(id);
    }

    function testCannotWithdrawIfNotReporter() public {
        bytes32 id = _file();
        vm.prank(stranger);
        vm.expectRevert("Only reporter");
        registry.withdrawReport(id);
    }

    function testStrangerCannotTriage() public {
        bytes32 id = _file();
        vm.prank(stranger);
        vm.expectRevert("Not authorized operator");
        registry.markInProgress(id);
    }

    function testSubjectReportAggregates() public {
        _file();
        _file();
        bytes32 id3 = _file();
        vm.prank(op1);
        registry.markInProgress(id3);

        uint256[7] memory byStatus = registry.getSubjectReport(SUBJECT);
        assertEq(byStatus[uint8(TakedownReportRegistry.Status.REPORTED)], 2);
        assertEq(byStatus[uint8(TakedownReportRegistry.Status.IN_PROGRESS)], 1);
    }

    function testGlobalReportAggregates() public {
        bytes32 id = _file();
        vm.prank(op1);
        registry.requestApproval(id);
        vm.prank(op2);
        registry.confirmTakedown(id, RESOLUTION);

        uint256[7] memory byStatus = registry.getGlobalReport();
        assertEq(byStatus[uint8(TakedownReportRegistry.Status.TAKEN_DOWN)], 1);
        assertEq(byStatus[uint8(TakedownReportRegistry.Status.AWAITING_APPROVAL)], 0);
    }

    function testChannelReportAggregates() public {
        _file();
        _file();
        uint256[7] memory byStatus = registry.getChannelReport(CHANNEL);
        assertEq(byStatus[uint8(TakedownReportRegistry.Status.REPORTED)], 2);
    }

    function testMonthReportTracksTransitions() public {
        bytes32 id = _file();

        uint256 currentMonth = block.timestamp / 30 days;
        uint256[7] memory byStatus = registry.getMonthReport(currentMonth);
        assertEq(byStatus[uint8(TakedownReportRegistry.Status.REPORTED)], 1);

        vm.prank(op1);
        registry.markInProgress(id);
        byStatus = registry.getMonthReport(currentMonth);
        assertEq(byStatus[uint8(TakedownReportRegistry.Status.IN_PROGRESS)], 1);
    }

    function testReportCount() public {
        _file();
        _file();
        _file();
        assertEq(registry.getReportCount(), 3);
    }

    function testConstructorRejectsZero() public {
        vm.expectRevert("privileges=0");
        new TakedownReportRegistry(address(0));
    }
}
