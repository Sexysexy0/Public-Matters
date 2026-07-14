// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import "../contracts/FinancialIndexReconstitutionOracle.sol";
import "../contracts/WipoContentExpertDetermination.sol";
import "../contracts/QualityAssuranceSelfAssessment.sol";
import "../contracts/FoundationGovernanceLedger.sol";
import "../contracts/AcademicAccreditationSAROracle.sol";
import "../contracts/HolisticCompetencyRegistry.sol";
import "../contracts/NetworkEngineerPerformanceAudit.sol";
import "../contracts/IetTechnicalReportRegistry.sol";
import "../contracts/PersonalGrowthBetEscrow.sol";
import "../contracts/SovereignSupplierEsourcingRouter.sol";
import "../contracts/ForceMajeureMdrOracle.sol";
import "../contracts/InstitutionalAuditHistory.sol";

contract SovereignGrcEcosystemTest is Test {
    FinancialIndexReconstitutionOracle public indexOracle;
    WipoContentExpertDetermination public wipoVault;
    QualityAssuranceSelfAssessment public qaVault;
    FoundationGovernanceLedger public foundationLedger;
    AcademicAccreditationSAROracle public accreditationOracle;
    HolisticCompetencyRegistry public competencyRouter;
    NetworkEngineerPerformanceAudit public networkAudit;
    IetTechnicalReportRegistry public ietRegistry;
    PersonalGrowthBetEscrow public growthBetEscrow;
    SovereignSupplierEsourcingRouter public supplierRouter;
    ForceMajeureMdrOracle public forceMajeureMdr;
    InstitutionalAuditHistory public auditHistory;

    address public masterContractor = address(0x9999);
    address public targetNodeNode = address(0x1111);
    address public secondaryNodeNode = address(0x2222);

    bytes32 public constant sampleHash = keccak256(abi.encodePacked("SOVEREIGN_GRC_COMPLIANCE_PROOF"));

    receive() external payable {}
    fallback() external payable {}

    function setUp() public {
        vm.startPrank(masterContractor);
        auditHistory = new InstitutionalAuditHistory();

        indexOracle = new FinancialIndexReconstitutionOracle();
        wipoVault = new WipoContentExpertDetermination();
        qaVault = new QualityAssuranceSelfAssessment();
        foundationLedger = new FoundationGovernanceLedger();
        accreditationOracle = new AcademicAccreditationSAROracle();
        competencyRouter = new HolisticCompetencyRegistry();
        networkAudit = new NetworkEngineerPerformanceAudit();
        ietRegistry = new IetTechnicalReportRegistry();
        growthBetEscrow = new PersonalGrowthBetEscrow();
        supplierRouter = new SovereignSupplierEsourcingRouter();
        forceMajeureMdr = new ForceMajeureMdrOracle();

        indexOracle.setAuditHistoryAddress(address(auditHistory));
        wipoVault.setAuditHistoryAddress(address(auditHistory));
        qaVault.setAuditHistoryAddress(address(auditHistory));
        foundationLedger.setAuditHistoryAddress(address(auditHistory));
        accreditationOracle.setAuditHistoryAddress(address(auditHistory));
        competencyRouter.setAuditHistoryAddress(address(auditHistory));
        networkAudit.setAuditHistoryAddress(address(auditHistory));
        ietRegistry.setAuditHistoryAddress(address(auditHistory));
        growthBetEscrow.setAuditHistoryAddress(address(auditHistory));
        supplierRouter.setAuditHistoryAddress(address(auditHistory));
        forceMajeureMdr.setAuditHistoryAddress(address(auditHistory));

        auditHistory.setLoggerAuthorization(address(indexOracle), true);
        auditHistory.setLoggerAuthorization(address(wipoVault), true);
        auditHistory.setLoggerAuthorization(address(qaVault), true);
        auditHistory.setLoggerAuthorization(address(foundationLedger), true);
        auditHistory.setLoggerAuthorization(address(accreditationOracle), true);
        auditHistory.setLoggerAuthorization(address(competencyRouter), true);
        auditHistory.setLoggerAuthorization(address(networkAudit), true);
        auditHistory.setLoggerAuthorization(address(ietRegistry), true);
        auditHistory.setLoggerAuthorization(address(growthBetEscrow), true);
        auditHistory.setLoggerAuthorization(address(supplierRouter), true);
        auditHistory.setLoggerAuthorization(address(forceMajeureMdr), true);

        vm.stopPrank();
    }

    function test_MorningstarIndexWeightComplianceFlow() public {
        vm.startPrank(masterContractor);
        uint256 idxId = indexOracle.initiateIndex("Wide Moat Focus");
        address[] memory assets = new address[](2);
        assets[0] = address(0xAAAA);
        assets[1] = address(0xBBBB);
        uint256[] memory weights = new uint256[](2);
        weights[0] = 600000;
        weights[1] = 400000;
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
        weights[0] = 500000;
        vm.expectRevert("Error: Mismatch identified. Weights sum must equal exactly 100%.");
        indexOracle.executeIndexReconstitution(idxId, assets, weights, sampleHash);
        vm.stopPrank();
    }

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

    function test_QualityAssuranceSARLifecycleFlow() public {
        vm.prank(targetNodeNode);
        uint256 sarId = qaVault.submitSelfAssessmentReport("Strategy & Planning", sampleHash);
        vm.prank(masterContractor);
        qaVault.evaluateSARCompliance(sarId, true);
        (,,,,, bool isApproved) = qaVault.audits(sarId);
        assertTrue(isApproved);
    }

    function test_FoundationGovernanceExternalConflictSanction() public {
        vm.startPrank(masterContractor);
        foundationLedger.registerBoardNode(targetNodeNode, "Managing Director", 100000, 20000);
        foundationLedger.auditExternalTaskCompliance(targetNodeNode, sampleHash, false);
        vm.stopPrank();
        (,,,, bool currentClearance) = foundationLedger.boardRegistry(targetNodeNode);
        assertFalse(currentClearance);
    }

    function test_AcademicAccreditationOutcomeFloorRevert() public {
        vm.startPrank(masterContractor);
        vm.expectRevert("Error: Accreditation rejected. Course Outcome attainment falls below strict 70% threshold.");
        accreditationOracle.processProgramAccreditationSAR("Tier-I Computer Science", 65, 80, sampleHash);
        vm.stopPrank();
    }

    function test_HolisticCompetencyValidationFlow() public {
        vm.prank(masterContractor);
        competencyRouter.registerProfessionalEngineer(targetNodeNode, true, true);
        (,,,, bool isValidated) = competencyRouter.engineers(targetNodeNode);
        assertTrue(isValidated);
    }

    function test_NetworkEngineerLowPerformanceSanction() public {
        vm.startPrank(masterContractor);
        networkAudit.logPersonnelPerformance(
            targetNodeNode, 9100, NetworkEngineerPerformanceAudit.CompetencyRating.NeedsImprovement
        );
        vm.stopPrank();
        (,,,, bool hasClearance) = networkAudit.evaluationRegistry(targetNodeNode);
        assertFalse(hasClearance);
    }

    function test_IetDocumentationReferencesFloorRevert() public {
        vm.startPrank(masterContractor);
        vm.expectRevert("Error: Structural violation. Technical reports must include references.");
        ietRegistry.registerTechnicalDocumentation(targetNodeNode, sampleHash, 1, false);
        vm.stopPrank();
    }

    function test_MaxRaskinPersonalGrowthForfeitureFlow() public {
        vm.deal(targetNodeNode, 10 ether);
        vm.prank(targetNodeNode);
        uint256 betId = growthBetEscrow.initializeGrowthBet{value: 5 ether}(500, secondaryNodeNode, sampleHash);
        uint256 initialContractorBalance = masterContractor.balance;
        vm.prank(secondaryNodeNode);
        growthBetEscrow.evaluateAndSettleBet(betId, false);
        assertEq(masterContractor.balance, initialContractorBalance + 5 ether);
    }

    function test_SngSupplierPrivacyBreachSanctionFlow() public {
        vm.startPrank(masterContractor);
        supplierRouter.registerSngSupplier(targetNodeNode, sampleHash);
        supplierRouter.enforcePrivacyBreachSanction(targetNodeNode, sampleHash);
        vm.stopPrank();
        (,,,, bool hasAccess, bool isLocked) = supplierRouter.suppliers(targetNodeNode);
        assertFalse(hasAccess);
        assertTrue(isLocked);
    }

    function test_ForceMajeureMdrOracleRemedialRecoveryFlow() public {
        vm.deal(masterContractor, 20 ether);

        vm.startPrank(masterContractor);
        uint256 dId =
            forceMajeureMdr.flagForceMajeureIncident{value: 10 ether}(targetNodeNode, secondaryNodeNode, sampleHash);
        forceMajeureMdr.escalateToMediation(dId);
        vm.stopPrank();

        uint256 initialAffectedNodeBalance = targetNodeNode.balance;

        vm.prank(secondaryNodeNode);
        forceMajeureMdr.resolveMdrDispute(dId, true, sampleHash);

        assertEq(targetNodeNode.balance, initialAffectedNodeBalance + 10 ether);
    }
}
