// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivileges.sol";
import "../src/PrivacyPreservingKYCRegistry.sol";

contract PrivacyPreservingKYCRegistryTest is Test {
    OperatorPrivileges privileges;
    PrivacyPreservingKYCRegistry kyc;

    address op = vm.addr(1);
    address nonOp = vm.addr(2);
    bytes32 subjectHash = keccak256(abi.encodePacked("salt", "nationalID"));
    bytes32 zkProofHash = keccak256("zkProof");

    function setUp() public {
        privileges = new OperatorPrivileges();
        privileges.addOperator(op);
        kyc = new PrivacyPreservingKYCRegistry(address(privileges));
    }

    function testRecordAttestation_OnlyOperator() public {
        vm.prank(nonOp);
        vm.expectRevert("Not authorized operator");
        kyc.recordAttestation(subjectHash, zkProofHash, PrivacyPreservingKYCRegistry.Status.Cleared, "test");
    }

    function testRecordAttestation_StoresHash() public {
        vm.prank(op);
        kyc.recordAttestation(subjectHash, zkProofHash, PrivacyPreservingKYCRegistry.Status.Cleared, "test");

        PrivacyPreservingKYCRegistry.Attestation memory att = kyc.getAttestation(subjectHash);
        assertEq(att.subjectHash, subjectHash);
        assertEq(att.zkProofHash, zkProofHash);
        assertEq(uint256(att.status), uint256(PrivacyPreservingKYCRegistry.Status.Cleared));
    }

    function testAppeal_Permissionless() public {
        vm.prank(op);
        kyc.recordAttestation(subjectHash, zkProofHash, PrivacyPreservingKYCRegistry.Status.Cleared, "test");

        vm.prank(nonOp);
        kyc.appeal(subjectHash);
        assertEq(kyc.getAppealCount(subjectHash), 1);
    }

    function testResolveAppeal_OnlyOperator() public {
        vm.prank(op);
        kyc.recordAttestation(subjectHash, zkProofHash, PrivacyPreservingKYCRegistry.Status.Cleared, "test");

        vm.prank(nonOp);
        vm.expectRevert("Not authorized operator");
        kyc.resolveAppeal(subjectHash, PrivacyPreservingKYCRegistry.Status.Revoked, "test");
    }

    function testResolveAppeal_UpdatesStatus() public {
        vm.prank(op);
        kyc.recordAttestation(subjectHash, zkProofHash, PrivacyPreservingKYCRegistry.Status.Cleared, "test");

        vm.prank(op);
        kyc.resolveAppeal(subjectHash, PrivacyPreservingKYCRegistry.Status.Revoked, "revoked");

        PrivacyPreservingKYCRegistry.Attestation memory att = kyc.getAttestation(subjectHash);
        assertEq(uint256(att.status), uint256(PrivacyPreservingKYCRegistry.Status.Revoked));
    }

    function testImmutableHistory() public {
        vm.prank(op);
        kyc.recordAttestation(subjectHash, zkProofHash, PrivacyPreservingKYCRegistry.Status.Cleared, "test");

        vm.prank(op);
        kyc.resolveAppeal(subjectHash, PrivacyPreservingKYCRegistry.Status.Revoked, "revoked");

        PrivacyPreservingKYCRegistry.Attestation memory att = kyc.getAttestation(subjectHash);
        assertEq(att.attestedBy, op);
        assertEq(att.reason, "revoked");
    }
}
