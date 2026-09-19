// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivilegesV2.sol";
import "../src/InvestigatorShield.sol";

contract InvestigatorShieldTest is Test {
    OperatorPrivilegesV2 privileges;
    InvestigatorShield shield;

    address owner = address(0xA11CE);
    address op1 = address(0xB0B);
    address investigator = address(0x1111);
    address outsider = address(0xBAD);

    bytes32 constant PUBKEY = keccak256("investigator-pubkey");
    bytes32 constant EVIDENCE = keccak256("evidence-hash-1");
    bytes32 constant TARGET = keccak256("california-hsr-authority");
    bytes32 constant LAW = keccak256("AB2624");

    function setUp() public {
        vm.startPrank(owner);
        privileges = new OperatorPrivilegesV2();
        privileges.addOperator(op1);
        vm.stopPrank();
        shield = new InvestigatorShield(address(privileges));
    }

    function test_RegisterInvestigator() public {
        vm.prank(op1);
        shield.registerInvestigator(investigator, PUBKEY, "California");

        InvestigatorShield.Investigator memory inv = shield.getInvestigator(investigator);
        assertTrue(shield.isInvestigatorActive(investigator));
        assertEq(inv.jurisdiction, "California");
    }

    function test_OnlyOperatorCanRegister() public {
        vm.prank(outsider);
        vm.expectRevert("Not authorized operator");
        shield.registerInvestigator(investigator, PUBKEY, "CA");
    }

    function test_DeregisterInvestigator() public {
        vm.startPrank(op1);
        shield.registerInvestigator(investigator, PUBKEY, "CA");
        shield.deregisterInvestigator(investigator, keccak256("retired"));
        vm.stopPrank();

        InvestigatorShield.Investigator memory inv = shield.getInvestigator(investigator);
        assertFalse(inv.active);
    }

    function test_SubmitEvidence() public {
        vm.prank(op1);
        shield.registerInvestigator(investigator, PUBKEY, "CA");

        vm.prank(investigator);
        uint256 id = shield.submitEvidence(EVIDENCE, TARGET, "government-fraud");
        assertEq(id, 1);

        InvestigatorShield.EvidenceSubmission memory e = shield.getEvidence(id);
        assertEq(e.investigator, investigator);
        assertEq(e.evidenceHash, EVIDENCE);
    }

    function test_CannotSubmitIfNotRegistered() public {
        vm.prank(investigator);
        vm.expectRevert("Investigator not registered");
        shield.submitEvidence(EVIDENCE, TARGET, "fraud");
    }

    function test_VerifyEvidence() public {
        vm.prank(op1);
        shield.registerInvestigator(investigator, PUBKEY, "CA");

        vm.prank(investigator);
        uint256 id = shield.submitEvidence(EVIDENCE, TARGET, "fraud");

        vm.prank(op1);
        shield.verifyEvidence(id);

        InvestigatorShield.EvidenceSubmission memory e = shield.getEvidence(id);
        assertTrue(e.verified);
    }

    function test_RecordSuppressionLaw() public {
        vm.prank(op1);
        uint256 id = shield.recordSuppressionLaw(LAW, "California", "Limits recording at immigration facilities");

        InvestigatorShield.SuppressionLaw memory s = shield.getSuppressionLaw(id);
        assertEq(s.lawId, LAW);
        assertEq(s.jurisdiction, "California");
    }

    function test_EvidenceByInvestigator() public {
        vm.prank(op1);
        shield.registerInvestigator(investigator, PUBKEY, "CA");

        vm.startPrank(investigator);
        shield.submitEvidence(EVIDENCE, TARGET, "fraud");
        shield.submitEvidence(keccak256("evidence-2"), TARGET, "fraud");
        vm.stopPrank();

        uint256[] memory ids = shield.getEvidenceByInvestigator(investigator);
        assertEq(ids.length, 2);
    }

    function test_TotalCounts() public {
        vm.startPrank(op1);
        shield.registerInvestigator(investigator, PUBKEY, "CA");
        shield.recordSuppressionLaw(LAW, "CA", "Test");
        vm.stopPrank();

        assertEq(shield.investigatorCount(), 1);
        assertEq(shield.suppressionLawCount(), 1);
    }
}
