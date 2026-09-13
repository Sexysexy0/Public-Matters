// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {NuclearEvidenceRegistry} from "../../src/NuclearEvidenceRegistry.sol";
import {NuclearConflictRegistry} from "../../src/NuclearConflictRegistry.sol";
import {NuclearDecisionGates} from "../../src/NuclearDecisionGates.sol";
import {NuclearPublicAudit} from "../../src/NuclearPublicAudit.sol";

contract NuclearGovernanceIntegrationTest is Test {
    NuclearEvidenceRegistry evidence;
    NuclearConflictRegistry conflicts;
    NuclearDecisionGates gates;
    NuclearPublicAudit audit;

    address reviewer1 = address(0xBEEF);
    address reviewer2 = address(0xCAFE);

    bytes32 constant SUBJECT = keccak256("G0 integrated decision");
    bytes32 constant EVIDENCE_ID = keccak256("integrated-evidence");
    bytes32 constant GATE_ID = keccak256("integrated-gate");
    bytes32 constant AUDIT_ID = keccak256("integrated-audit");

    function setUp() public {
        evidence = new NuclearEvidenceRegistry();
        conflicts = new NuclearConflictRegistry();
        gates = new NuclearDecisionGates(address(evidence), address(conflicts));
        audit = new NuclearPublicAudit();

        evidence.setReviewer(reviewer1, true);
        evidence.setReviewer(reviewer2, true);
        gates.setReviewer(reviewer1, true);
        gates.setReviewer(reviewer2, true);
    }

    function testFullGovernanceChain() public {
        vm.prank(reviewer1);
        evidence.registerEvidence(EVIDENCE_ID, SUBJECT, keccak256("source"));

        vm.prank(reviewer1);
        evidence.reviewEvidence(EVIDENCE_ID, NuclearEvidenceRegistry.Status.Accepted);

        gates.createGate(GATE_ID, SUBJECT, 2);
        gates.attachEvidence(GATE_ID, EVIDENCE_ID);

        vm.prank(reviewer1);
        uint256 conflictId = conflicts.declareConflict(SUBJECT, keccak256("disclosure"), 0);

        vm.expectRevert(NuclearDecisionGates.ConflictedReviewer.selector);
        vm.prank(reviewer1);
        gates.approveGate(GATE_ID);

        conflicts.revokeConflict(conflictId);

        vm.prank(reviewer1);
        gates.approveGate(GATE_ID);

        vm.prank(reviewer2);
        gates.approveGate(GATE_ID);

        assertTrue(gates.isPassed(GATE_ID));

        audit.logEntry(AUDIT_ID, SUBJECT, keccak256("gate-passed"), keccak256("decision-payload"));

        assertTrue(audit.entryExists(AUDIT_ID));
    }

    function testRejectedEvidenceCannotEnterGate() public {
        bytes32 rejectedId = keccak256("rejected-evidence");

        evidence.registerEvidence(rejectedId, SUBJECT, keccak256("bad-source"));

        evidence.reviewEvidence(rejectedId, NuclearEvidenceRegistry.Status.Rejected);

        gates.createGate(GATE_ID, SUBJECT, 1);

        vm.expectRevert(NuclearDecisionGates.EvidenceNotUsable.selector);
        gates.attachEvidence(GATE_ID, rejectedId);
    }

    function testAuditSupersessionPreservesChain() public {
        bytes32 first = keccak256("audit-first");
        bytes32 second = keccak256("audit-second");

        audit.logEntry(first, SUBJECT, keccak256("initial"), keccak256("payload-one"));

        audit.supersedeEntry(first, second, keccak256("corrected"), keccak256("payload-two"));

        assertEq(audit.latestEntryBySubject(SUBJECT), second);
        assertTrue(audit.entryExists(first));
        assertTrue(audit.entryExists(second));
    }
}
