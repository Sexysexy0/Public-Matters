// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/health/SovereignEHRVault.sol";
import "../src/health/PatientConsentEngine.sol";

contract SovereignEHRSuiteTest is Test {
    SovereignEHRVault public vault;
    PatientConsentEngine public consentEngine;

    address public patient = address(0x1111);
    address public doctor = address(0x2222);

    bytes32 sampleIpfsHash = keccak256(abi.encodePacked("ENCRYPTED_IPFS_CID_QM123"));
    bytes32 sampleKeyHash = keccak256(abi.encodePacked("AES_256_KEY_HASH"));

    function setUp() external {
        vault = new SovereignEHRVault();
        consentEngine = new PatientConsentEngine();

        // Register Patient
        vm.prank(patient);
        vault.registerPatient(patient);
    }

    function test_PatientRecordLifecycleAndAudit() external {
        // Patient adds encrypted record
        vm.prank(patient);
        vault.addRecord(patient, sampleIpfsHash, sampleKeyHash);

        // Destructure tuple from public mapping getter
        (, uint256 recordCount) = vault.patients(patient);
        assertEq(recordCount, 1);

        // Fetch record and verify audit trail emission
        vm.prank(patient);
        (bytes32 ipfs, bytes32 key, ) = vault.getRecord(patient, 0);

        assertEq(ipfs, sampleIpfsHash);
        assertEq(key, sampleKeyHash);
    }

    function test_ConsentGrantAndRevocation() external {
        // Grant 1-hour consent to doctor
        vm.prank(patient);
        consentEngine.grantConsent(doctor, 3600);

        assertTrue(consentEngine.hasActiveConsent(patient, doctor));

        // Revoke consent
        vm.prank(patient);
        consentEngine.revokeConsent(doctor);

        assertFalse(consentEngine.hasActiveConsent(patient, doctor));
    }
}
