// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "forge-std/Test.sol";
import "../contracts/WhistleblowerSanctuary.sol";
contract WhistleblowerSanctuaryTest is Test {
    WhistleblowerSanctuary public sanctuary;
    address public guardianWallet = address(0x1111);
    address public whistleblower = address(0x2222);
    address public badInstitution = address(0x3333);
    function setUp() public {
        vm.prank(guardianWallet);
        sanctuary = new WhistleblowerSanctuary();
    }
    function test_AnonymousIntelSubmission() public {
        vm.prank(whistleblower);
        bytes32 dummyIntelHash = keccak256(abi.encodePacked("EVIDENCE_LOG_ALPHA"));
        uint256 reportId = sanctuary.submitIntel(dummyIntelHash, badInstitution);
        assertEq(reportId, 1);
        (bytes32 hash, address target, WhistleblowerSanctuary.ReportStatus status, , ) = sanctuary.getReportMetrics(1);
        assertEq(hash, dummyIntelHash);
        assertEq(target, badInstitution);
        assertTrue(status == WhistleblowerSanctuary.ReportStatus.Submitted);
    }
    function test_GuardianValidationAuthority() public {
        vm.prank(whistleblower);
        bytes32 dummyIntelHash = keccak256(abi.encodePacked("EVIDENCE_LOG_BETA"));
        uint256 reportId = sanctuary.submitIntel(dummyIntelHash, badInstitution);
        vm.prank(badInstitution);
        vm.expectRevert("Error: Sanctuary denial. Only the Sovereign Guardian can update registry metrics.");
        sanctuary.updateReportStatus(reportId, WhistleblowerSanctuary.ReportStatus.Validated, "Fake Approval Attempt");
        vm.prank(guardianWallet);
        sanctuary.updateReportStatus(reportId, WhistleblowerSanctuary.ReportStatus.Validated, "Intel verified.");
        (, , WhistleblowerSanctuary.ReportStatus status, , string memory log) = sanctuary.getReportMetrics(reportId);
        assertTrue(status == WhistleblowerSanctuary.ReportStatus.Validated);
        assertEq(log, "Intel verified.");
    }
}
