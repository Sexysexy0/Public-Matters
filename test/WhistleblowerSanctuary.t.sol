// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import "../contracts/WhistleblowerSanctuary.sol";

contract WhistleblowerSanctuaryTest is Test {
    WhistleblowerSanctuary public sanctuary;
    address public guardianWallet = address(0x1111);
    address public whistleblower = address(0x2222);
    address public badInstitution = address(0x3333);
    bytes32 public sampleReportHash = keccak256(abi.encodePacked("CONFIDENTIAL_INTEL_DATA"));

    function setUp() public {
        vm.prank(guardianWallet);
        sanctuary = new WhistleblowerSanctuary();
    }

    function test_AnonymousIntelSubmission() public {
        vm.prank(whistleblower);
        uint256 reportId = sanctuary.submitIntel(sampleReportHash, badInstitution);
        assertEq(reportId, 1);

        (bytes32 hash, address target, WhistleblowerSanctuary.ReportStatus status,, bytes32 log) =
            sanctuary.getReportMetrics(1);
        assertEq(hash, sampleReportHash);
        assertEq(target, badInstitution);
        assertTrue(status == WhistleblowerSanctuary.ReportStatus.Submitted);
        assertEq(log, "STATUS_LOG_SUBMITTED");
    }

    function test_GuardianValidationAuthority() public {
        vm.prank(whistleblower);
        uint256 reportId = sanctuary.submitIntel(sampleReportHash, badInstitution);

        vm.prank(guardianWallet);
        sanctuary.updateReportStatus(reportId, WhistleblowerSanctuary.ReportStatus.Validated, "INTEL_VERIFIED_AIRTIGHT");

        (,, WhistleblowerSanctuary.ReportStatus status,, bytes32 log) = sanctuary.getReportMetrics(reportId);
        assertTrue(status == WhistleblowerSanctuary.ReportStatus.Validated);
        assertEq(log, "INTEL_VERIFIED_AIRTIGHT");
    }
}
