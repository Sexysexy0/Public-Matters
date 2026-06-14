// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/FinancialIndexReconstitutionOracle.sol";
import "../contracts/WipoContentExpertDetermination.sol";
import "../contracts/QualityAssuranceSelfAssessment.sol";
import "../contracts/FoundationGovernanceLedger.sol";
import "../contracts/AcademicAccreditationSAROracle.sol";
import "../contracts/HolisticCompetencyRegistry.sol";
import "../contracts/InstitutionalAuditHistory.sol";

contract SovereignGrcEcosystemTest is Test {
    FinancialIndexReconstitutionOracle public indexOracle;
    WipoContentExpertDetermination public wipoVault;
    QualityAssuranceSelfAssessment public qaVault;
    FoundationGovernanceLedger public foundationLedger;
    AcademicAccreditationSAROracle public accreditationOracle;
    HolisticCompetencyRegistry public competencyRouter;
    InstitutionalAuditHistory public auditHistory;

    address public masterContractor = address(0x9999);
    address public targetNodeNode = address(0x1111);
    address public secondaryNodeNode = address(0x2222);
    
    bytes32 public constant sampleHash = keccak256(abi.encodePacked("SOVEREIGN_GRC_COMPLIANCE_PROOF"));

    function setUp() public {
        vm.startPrank(masterContractor);
        auditHistory = new InstitutionalAuditHistory();
        
        indexOracle = new FinancialIndexReconstitutionOracle();
        wipoVault = new WipoContentExpertDetermination();
        qaVault = new QualityAssuranceSelfAssessment();
        foundationLedger = new FoundationGovernanceLedger();
        accreditationOracle = new AcademicAccreditationSAROracle();
        competencyRouter = new HolisticCompetencyRegistry();

        // FIXED: Itinuwid ang lahat ng tawag patungong accreditationOracle
        indexOracle.setAuditHistoryAddress(address(auditHistory));
        wipoVault.setAuditHistoryAddress(address(auditHistory));
        qaVault.setAuditHistoryAddress(address(auditHistory));
        foundationLedger.setAuditHistoryAddress(address(auditHistory));
        accreditationOracle.setAuditHistoryAddress(address(auditHistory));
        competencyRouter.setAuditHistoryAddress(address(auditHistory));

        auditHistory.setLoggerAuthorization(address(indexOracle), true);
        auditHistory.setLoggerAuthorization(address(wipoVault), true);
        auditHistory.setLoggerAuthorization(address(qaVault), true);
        auditHistory.setLoggerAuthorization(address(foundationLedger), true);
        auditHistory.setLoggerAuthorization(address(accreditationOracle), true);
        auditHistory.setLoggerAuthorization(address(competencyRouter), true);
        
        vm.stopPrank();
    }

    // 1. TESTING MORNINGSTAR INDEX MATRIX
    function test_MorningstarIndexWeightComplianceFlow() public {
        vm.startPrank(masterContractor);
        uint256 idxId = indexOracle.initiateIndex("Wide Moat Focus");
        
        address[] memory assets = new address[](2);
        assets[0] = address(0xAAAA);
        assets[1] = address(0xBBBB);

        uint256[] memory weights = new uint256[](2);
        weights[0] = 600000; // 60%
        weights[1] = 400000; // 40% (Total = 100%)

        indexOracle.executeIndexReconstitution(idxId, assets, weights, sampleHash);
        vm.stopPrank();

        assertEq(indexOracle.constituentWeights(idxId, address(0xAAAA)), 600000);
    }

    function test_MorningstarIndexWeightMismatchRevert() public {
        vm.startPrank(masterContractor);
        uint256 idxId = indexOracle.initiateIndex("Multi-Asset High Income");
        
        address[] memory assets = new address[](1);
        assets[0] = address(0xAAAA);

        uint256[] memory weights = new uint256[](1);
        weights[0] = 500000; // Only 50% (Must revert!)

        vm.expectRevert("Error: Mismatch identified. Weights sum must equal exactly 100%.");
        indexOracle.executeIndexReconstitution(idxId, assets, weights, sampleHash);
        vm.stopPrank();
    }

    // 2. TESTING WIPO ADR MECHANISMS
    function test_WipoExpertDeterminationResolutionFlow() public {
        vm.startPrank(masterContractor);
        wipoVault.setExpertClearance(secondaryNodeNode, true);
        uint256 caseId = wipoVault.openContentADR(targetNodeNode, sampleHash, secondaryNodeNode);
        vm.stopPrank();

        vm.prank(secondaryNodeNode);
        wipoVault.resolveContentADR(caseId, true, sampleHash);

        (,,,, WipoContentExpertDetermination.ADRStatus pinalStatus, bytes32 pinalHash) = wipoVault.disputes(caseId);
        
        assertTrue(pinalStatus == WipoContentExpertDetermination.ADRStatus.Upheld);
        assertEq(pinalHash, sampleHash);
    }

    // 3. TESTING QUALITY ASSURANCE SELF ASSESSMENT
    function test_QualityAssuranceSARLifecycleFlow() public {
        vm.prank(targetNodeNode);
        uint256 sarId = qaVault.submitSelfAssessmentReport("Strategy & Planning", sampleHash);

        vm.prank(masterContractor);
        qaVault.evaluateSARCompliance(sarId, true);

        (,,,,, bool isApproved) = qaVault.audits(sarId);
        assertTrue(isApproved);
    }

    // 4. TESTING FOUNDATION GOVERNANCE REMUNERATION
    function test_FoundationGovernanceExternalConflictSanction() public {
        vm.startPrank(masterContractor);
        foundationLedger.registerBoardNode(targetNodeNode, "Managing Director", 100000, 20000);
        
        foundationLedger.auditExternalTaskCompliance(targetNodeNode, sampleHash, false);
        vm.stopPrank();

        (,,,, bool currentClearance) = foundationLedger.boardRegistry(targetNodeNode);
        assertFalse(currentClearance);
    }

    // 5. TESTING NBA ACCREDITATION ATTENMENT CRITERIA
    function test_AcademicAccreditationOutcomeFloorRevert() public {
        vm.startPrank(masterContractor);
        // FIXED: Itinuwid ang identifier patungong accreditationOracle
        vm.expectRevert("Error: Accreditation rejected. Course Outcome attainment falls below strict 70% threshold.");
        accreditationOracle.processProgramAccreditationSAR("Tier-I Computer Science", 65, 80, sampleHash);
        vm.stopPrank();
    }

    // 6. TESTING ENGINEERS AUSTRALIA COMPETENCY CONTROLLER
    function test_HolisticCompetencyValidationFlow() public {
        vm.prank(masterContractor);
        competencyRouter.registerProfessionalEngineer(targetNodeNode, true, true);

        (,,,, bool isValidated) = competencyRouter.engineers(targetNodeNode);
        assertTrue(isValidated);
    }
}
