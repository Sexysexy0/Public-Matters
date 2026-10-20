// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {CivicAccountabilityRegistry} from "../../src/civic-accountability/CivicAccountabilityRegistry.sol";

contract CivicAccountabilityRegistryTest is Test {
    CivicAccountabilityRegistry registry;

    address governor = makeAddr("governor");
    address auditor = makeAddr("auditor");
    address journalist = makeAddr("journalist");
    address stranger = makeAddr("stranger");

    bytes32 recordId = keccak256("press-access-incident-1");
    bytes32 subjectHash = keccak256("agency-or-official");
    bytes32 evidenceHash = keccak256("email-recording-or-photo");

    event RecordFiled(
        bytes32 indexed id,
        CivicAccountabilityRegistry.RecordType recordType,
        bytes32 indexed subjectHash,
        bytes32 evidenceHash,
        address indexed filer
    );

    event RecordUpdated(bytes32 indexed id, CivicAccountabilityRegistry.RecordStatus status, string response);

    function setUp() public {
        vm.prank(governor);
        registry = new CivicAccountabilityRegistry(auditor);
    }

    function testConstructorRejectsZeroAuditor() public {
        vm.prank(governor);
        vm.expectRevert(CivicAccountabilityRegistry.ZeroAddress.selector);
        new CivicAccountabilityRegistry(address(0));
    }

    function testGovernorCanSetAuditor() public {
        address newAuditor = makeAddr("newAuditor");

        vm.prank(governor);
        registry.setAuditor(newAuditor);

        assertEq(registry.auditor(), newAuditor);
    }

    function testOnlyGovernorCanSetAuditor() public {
        vm.prank(stranger);
        vm.expectRevert(CivicAccountabilityRegistry.Unauthorized.selector);
        registry.setAuditor(stranger);
    }

    function testJournalistCanFilePressAccessIncident() public {
        vm.expectEmit(true, true, true, true);
        emit RecordFiled(
            recordId,
            CivicAccountabilityRegistry.RecordType.PRESS_ACCESS_INCIDENT,
            subjectHash,
            evidenceHash,
            journalist
        );

        vm.prank(journalist);
        bool filed = registry.fileRecord(
            recordId,
            CivicAccountabilityRegistry.RecordType.PRESS_ACCESS_INCIDENT,
            subjectHash,
            evidenceHash,
            "Access restriction during public briefing",
            "Reporter was denied entry despite valid accreditation."
        );

        assertTrue(filed);

        CivicAccountabilityRegistry.Record memory record = registry.getRecord(recordId);

        assertEq(record.id, recordId);
        assertEq(uint256(record.recordType), uint256(CivicAccountabilityRegistry.RecordType.PRESS_ACCESS_INCIDENT));
        assertEq(uint256(record.status), uint256(CivicAccountabilityRegistry.RecordStatus.FILED));
        assertEq(record.subjectHash, subjectHash);
        assertEq(record.evidenceHash, evidenceHash);
        assertEq(record.filer, journalist);
        assertEq(record.response, "");
        assertEq(registry.totalRecords(), 1);
    }

    function testCannotFileDuplicateRecord() public {
        vm.startPrank(journalist);
        registry.fileRecord(
            recordId,
            CivicAccountabilityRegistry.RecordType.PRESS_ACCESS_INCIDENT,
            subjectHash,
            evidenceHash,
            "Access restriction",
            "First filing"
        );

        vm.expectRevert(CivicAccountabilityRegistry.RecordAlreadyFiled.selector);
        registry.fileRecord(
            recordId,
            CivicAccountabilityRegistry.RecordType.PRESS_ACCESS_INCIDENT,
            subjectHash,
            evidenceHash,
            "Access restriction",
            "Duplicate filing"
        );
        vm.stopPrank();
    }

    function testCanFileOtherRecordTypes() public {
        bytes32 mandateId = keccak256("citizen-mandate-1");
        bytes32 renewalId = keccak256("leadership-renewal-1");
        bytes32 narrativeId = keccak256("policy-narrative-1");

        vm.startPrank(journalist);

        assertTrue(
            registry.fileRecord(
                mandateId,
                CivicAccountabilityRegistry.RecordType.CITIZEN_MANDATE,
                subjectHash,
                evidenceHash,
                "Housing mandate",
                "Community petition for transparent housing allocation."
            )
        );

        assertTrue(
            registry.fileRecord(
                renewalId,
                CivicAccountabilityRegistry.RecordType.LEADERSHIP_RENEWAL,
                subjectHash,
                evidenceHash,
                "Leadership renewal commitment",
                "Public commitment to succession planning and youth participation."
            )
        );

        assertTrue(
            registry.fileRecord(
                narrativeId,
                CivicAccountabilityRegistry.RecordType.POLICY_NARRATIVE,
                subjectHash,
                evidenceHash,
                "Climate policy narrative",
                "Policy linked to public values, beneficiaries, and tradeoffs."
            )
        );

        vm.stopPrank();

        assertEq(registry.totalRecords(), 3);
    }

    function testOnlyAuditorCanUpdateRecord() public {
        vm.prank(journalist);
        registry.fileRecord(
            recordId,
            CivicAccountabilityRegistry.RecordType.PRESS_ACCESS_INCIDENT,
            subjectHash,
            evidenceHash,
            "Access restriction",
            "Reporter was denied entry."
        );

        vm.prank(journalist);
        vm.expectRevert(CivicAccountabilityRegistry.Unauthorized.selector);
        registry.updateRecord(recordId, CivicAccountabilityRegistry.RecordStatus.ACKNOWLEDGED, "Self-update blocked");

        vm.prank(stranger);
        vm.expectRevert(CivicAccountabilityRegistry.Unauthorized.selector);
        registry.updateRecord(recordId, CivicAccountabilityRegistry.RecordStatus.ACKNOWLEDGED, "Unauthorized update");
    }

    function testAuditorCanAcknowledgeRecord() public {
        vm.prank(journalist);
        registry.fileRecord(
            recordId,
            CivicAccountabilityRegistry.RecordType.PRESS_ACCESS_INCIDENT,
            subjectHash,
            evidenceHash,
            "Access restriction",
            "Reporter was denied entry."
        );

        vm.expectEmit(true, false, false, true);
        emit RecordUpdated(
            recordId, CivicAccountabilityRegistry.RecordStatus.ACKNOWLEDGED, "Received and assigned for review"
        );

        vm.prank(auditor);
        registry.updateRecord(
            recordId, CivicAccountabilityRegistry.RecordStatus.ACKNOWLEDGED, "Received and assigned for review"
        );

        CivicAccountabilityRegistry.Record memory record = registry.getRecord(recordId);

        assertEq(uint256(record.status), uint256(CivicAccountabilityRegistry.RecordStatus.ACKNOWLEDGED));
        assertEq(record.response, "Received and assigned for review");
    }

    function testAuditorCanResolveRecord() public {
        vm.prank(journalist);
        registry.fileRecord(
            recordId,
            CivicAccountabilityRegistry.RecordType.PRESS_ACCESS_INCIDENT,
            subjectHash,
            evidenceHash,
            "Access restriction",
            "Reporter was denied entry."
        );

        vm.startPrank(auditor);
        registry.updateRecord(recordId, CivicAccountabilityRegistry.RecordStatus.UNDER_REVIEW, "Reviewing evidence");
        registry.updateRecord(
            recordId,
            CivicAccountabilityRegistry.RecordStatus.RESOLVED,
            "Access restored and corrective guidance issued"
        );
        vm.stopPrank();

        CivicAccountabilityRegistry.Record memory record = registry.getRecord(recordId);

        assertEq(uint256(record.status), uint256(CivicAccountabilityRegistry.RecordStatus.RESOLVED));
        assertEq(record.response, "Access restored and corrective guidance issued");
    }

    function testGovernorCanAlsoUpdateRecord() public {
        vm.prank(journalist);
        registry.fileRecord(
            recordId,
            CivicAccountabilityRegistry.RecordType.PRESS_ACCESS_INCIDENT,
            subjectHash,
            evidenceHash,
            "Access restriction",
            "Reporter was denied entry."
        );

        vm.prank(governor);
        registry.updateRecord(
            recordId, CivicAccountabilityRegistry.RecordStatus.DISMISSED, "Insufficient evidence after review"
        );

        CivicAccountabilityRegistry.Record memory record = registry.getRecord(recordId);

        assertEq(uint256(record.status), uint256(CivicAccountabilityRegistry.RecordStatus.DISMISSED));
    }

    function testCannotUpdateNonexistentRecord() public {
        vm.prank(auditor);
        vm.expectRevert(CivicAccountabilityRegistry.RecordNotFound.selector);
        registry.updateRecord(keccak256("missing"), CivicAccountabilityRegistry.RecordStatus.ACKNOWLEDGED, "No record");
    }

    function testCannotGetNonexistentRecord() public {
        vm.expectRevert(CivicAccountabilityRegistry.RecordNotFound.selector);
        registry.getRecord(keccak256("missing"));
    }

    function testGetAllRecordIds() public {
        bytes32 secondId = keccak256("press-access-incident-2");

        vm.startPrank(journalist);
        registry.fileRecord(
            recordId,
            CivicAccountabilityRegistry.RecordType.PRESS_ACCESS_INCIDENT,
            subjectHash,
            evidenceHash,
            "First incident",
            "First filing"
        );
        registry.fileRecord(
            secondId,
            CivicAccountabilityRegistry.RecordType.PRESS_ACCESS_INCIDENT,
            subjectHash,
            evidenceHash,
            "Second incident",
            "Second filing"
        );
        vm.stopPrank();

        bytes32[] memory ids = registry.getAllRecordIds();

        assertEq(ids.length, 2);
        assertEq(ids[0], recordId);
        assertEq(ids[1], secondId);
    }
}
