// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivileges.sol";
import "../src/PrivacyPreservingKYCRegistryV2.sol";

contract PrivacyPreservingKYCRegistryV2Test is Test {
    OperatorPrivileges privileges;
    PrivacyPreservingKYCRegistryV2 kyc;

    address op = vm.addr(1);
    address nonOp = vm.addr(2);
    bytes32 subjectHash = keccak256(abi.encodePacked("salt", "nationalID"));
    bytes32 zkProofHash = keccak256("zkProof");
    bytes32 reasonHash = keccak256("initial-review");

    function setUp() public {
        privileges = new OperatorPrivileges();
        privileges.addOperator(op);
        kyc = new PrivacyPreservingKYCRegistryV2(address(privileges));
    }

    function testRecordAttestation_OnlyOperator() public {
        vm.prank(nonOp);
        vm.expectRevert("Not authorized operator");
        kyc.recordAttestation(subjectHash, zkProofHash, PrivacyPreservingKYCRegistryV2.Status.Cleared, reasonHash);
    }

    function testRecordAttestation_AppendsVersion() public {
        vm.startPrank(op);
        kyc.recordAttestation(subjectHash, zkProofHash, PrivacyPreservingKYCRegistryV2.Status.Pending, reasonHash);
        kyc.recordAttestation(subjectHash, zkProofHash, PrivacyPreservingKYCRegistryV2.Status.Cleared, reasonHash);
        vm.stopPrank();

        assertEq(kyc.attestationCount(subjectHash), 2);

        PrivacyPreservingKYCRegistryV2.Attestation memory first = kyc.getAttestationVersion(subjectHash, 1);
        PrivacyPreservingKYCRegistryV2.Attestation memory second = kyc.getAttestationVersion(subjectHash, 2);

        assertEq(uint256(first.status), uint256(PrivacyPreservingKYCRegistryV2.Status.Pending));
        assertEq(uint256(second.status), uint256(PrivacyPreservingKYCRegistryV2.Status.Cleared));
    }

    function testAppeal_Permissionless() public {
        vm.prank(op);
        kyc.recordAttestation(subjectHash, zkProofHash, PrivacyPreservingKYCRegistryV2.Status.Cleared, reasonHash);

        vm.prank(nonOp);
        kyc.appeal(subjectHash);

        assertEq(kyc.getOpenAppealId(subjectHash), 1);
    }

    function testAppeal_PreventsDuplicateOpenAppeals() public {
        vm.prank(op);
        kyc.recordAttestation(subjectHash, zkProofHash, PrivacyPreservingKYCRegistryV2.Status.Cleared, reasonHash);

        vm.prank(nonOp);
        kyc.appeal(subjectHash);

        vm.prank(nonOp);
        vm.expectRevert("Open appeal exists");
        kyc.appeal(subjectHash);
    }

    function testResolveAppeal_OnlyOperator() public {
        vm.prank(op);
        kyc.recordAttestation(subjectHash, zkProofHash, PrivacyPreservingKYCRegistryV2.Status.Cleared, reasonHash);

        vm.prank(nonOp);
        kyc.appeal(subjectHash);

        vm.prank(nonOp);
        vm.expectRevert("Not authorized operator");
        kyc.resolveAppeal(1, PrivacyPreservingKYCRegistryV2.Status.Revoked, reasonHash);
    }

    function testResolveAppeal_RequiresOpenAppeal() public {
        vm.prank(op);
        kyc.recordAttestation(subjectHash, zkProofHash, PrivacyPreservingKYCRegistryV2.Status.Cleared, reasonHash);

        vm.prank(op);
        vm.expectRevert("Appeal not open");
        kyc.resolveAppeal(1, PrivacyPreservingKYCRegistryV2.Status.Revoked, reasonHash);
    }

    function testResolveAppeal_ClosesAppeal() public {
        vm.prank(op);
        kyc.recordAttestation(subjectHash, zkProofHash, PrivacyPreservingKYCRegistryV2.Status.Cleared, reasonHash);

        vm.prank(nonOp);
        kyc.appeal(subjectHash);

        vm.prank(op);
        kyc.resolveAppeal(1, PrivacyPreservingKYCRegistryV2.Status.Revoked, reasonHash);

        assertEq(kyc.getOpenAppealId(subjectHash), 0);
    }

    function testResolveAppeal_AllowsNewAppeal() public {
        vm.prank(op);
        kyc.recordAttestation(subjectHash, zkProofHash, PrivacyPreservingKYCRegistryV2.Status.Cleared, reasonHash);

        vm.prank(nonOp);
        kyc.appeal(subjectHash);

        vm.prank(op);
        kyc.resolveAppeal(1, PrivacyPreservingKYCRegistryV2.Status.Revoked, reasonHash);

        vm.prank(nonOp);
        kyc.appeal(subjectHash);

        assertEq(kyc.getOpenAppealId(subjectHash), 2);
    }
}
