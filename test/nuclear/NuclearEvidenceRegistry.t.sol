// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {NuclearEvidenceRegistry} from "../../src/NuclearEvidenceRegistry.sol";

contract NuclearEvidenceRegistryTest is Test {
    NuclearEvidenceRegistry registry;
    address reviewer = address(0xBEEF);
    address submitter = address(0xCAFE);

    bytes32 constant SUBJECT = keccak256("BNPP seismic assessment");
    bytes32 constant EVIDENCE_ID = keccak256("evidence-1");
    bytes32 constant CORRECTION_ID = keccak256("correction-1");
    bytes32 constant SOURCE_HASH = keccak256("source-1");
    bytes32 constant CORRECTION_HASH = keccak256("source-2");

    function setUp() public {
        registry = new NuclearEvidenceRegistry();
        registry.setReviewer(reviewer, true);
    }

    function testRegisterEvidence() public {
        vm.prank(submitter);
        registry.registerEvidence(EVIDENCE_ID, SUBJECT, SOURCE_HASH);

        NuclearEvidenceRegistry.Evidence memory record = registry.getEvidence(EVIDENCE_ID);

        assertEq(record.subject, SUBJECT);
        assertEq(record.sourceHash, SOURCE_HASH);
        assertEq(record.submittedBy, submitter);
        assertEq(uint8(record.status), uint8(NuclearEvidenceRegistry.Status.Submitted));
    }

    function testReviewerCanAcceptEvidence() public {
        vm.prank(submitter);
        registry.registerEvidence(EVIDENCE_ID, SUBJECT, SOURCE_HASH);

        vm.prank(reviewer);
        registry.reviewEvidence(EVIDENCE_ID, NuclearEvidenceRegistry.Status.Accepted);

        assertTrue(registry.isUsable(EVIDENCE_ID));
    }

    function testUnauthorizedReviewerCannotAccept() public {
        vm.prank(submitter);
        registry.registerEvidence(EVIDENCE_ID, SUBJECT, SOURCE_HASH);

        vm.expectRevert(NuclearEvidenceRegistry.InvalidReviewer.selector);
        vm.prank(address(0x1234));
        registry.reviewEvidence(EVIDENCE_ID, NuclearEvidenceRegistry.Status.Accepted);
    }

    function testCorrectionPreservesOriginal() public {
        vm.prank(submitter);
        registry.registerEvidence(EVIDENCE_ID, SUBJECT, SOURCE_HASH);

        vm.prank(reviewer);
        registry.reviewEvidence(EVIDENCE_ID, NuclearEvidenceRegistry.Status.CorrectionRequested);

        vm.prank(submitter);
        registry.submitCorrection(CORRECTION_ID, EVIDENCE_ID, CORRECTION_HASH);

        NuclearEvidenceRegistry.Evidence memory original = registry.getEvidence(EVIDENCE_ID);
        NuclearEvidenceRegistry.Evidence memory correction = registry.getEvidence(CORRECTION_ID);

        assertEq(original.sourceHash, SOURCE_HASH);
        assertEq(correction.sourceHash, CORRECTION_HASH);
        assertEq(correction.supersedes, EVIDENCE_ID);
    }

    function testRejectedEvidenceIsNotUsable() public {
        vm.prank(submitter);
        registry.registerEvidence(EVIDENCE_ID, SUBJECT, SOURCE_HASH);

        vm.prank(reviewer);
        registry.reviewEvidence(EVIDENCE_ID, NuclearEvidenceRegistry.Status.Rejected);

        assertFalse(registry.isUsable(EVIDENCE_ID));
    }

    function testFrozenEvidenceCannotBeReviewed() public {
        vm.prank(submitter);
        registry.registerEvidence(EVIDENCE_ID, SUBJECT, SOURCE_HASH);

        registry.freezeEvidence(EVIDENCE_ID);

        vm.expectRevert(NuclearEvidenceRegistry.FrozenRecord.selector);
        registry.reviewEvidence(EVIDENCE_ID, NuclearEvidenceRegistry.Status.Accepted);
    }
}
