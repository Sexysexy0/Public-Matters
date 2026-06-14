// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
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

contract DeployEcosystem is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envOr("PRIVATE_KEY", uint256(1));
        vm.startBroadcast(deployerPrivateKey);

        // 1. Core History Telemetry Ledger Deployment
        InstitutionalAuditHistory auditHistory = new InstitutionalAuditHistory();

        // 2. Multi-Variant Governance Contracts Initialization
        FinancialIndexReconstitutionOracle indexOracle = new FinancialIndexReconstitutionOracle();
        WipoContentExpertDetermination wipoVault = new WipoContentExpertDetermination();
        QualityAssuranceSelfAssessment qaVault = new QualityAssuranceSelfAssessment();
        FoundationGovernanceLedger foundationLedger = new FoundationGovernanceLedger();
        AcademicAccreditationSAROracle accreditationOracle = new AcademicAccreditationSAROracle();
        HolisticCompetencyRegistry competencyRouter = new HolisticCompetencyRegistry();
        NetworkEngineerPerformanceAudit networkAudit = new NetworkEngineerPerformanceAudit();
        IetTechnicalReportRegistry ietRegistry = new IetTechnicalReportRegistry();
        PersonalGrowthBetEscrow growthBetEscrow = new PersonalGrowthBetEscrow();
        SovereignSupplierEsourcingRouter supplierRouter = new SovereignSupplierEsourcingRouter();
        ForceMajeureMdrOracle forceMajeureMdr = new ForceMajeureMdrOracle();

        // 3. Central Audit History Wire Integration
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

        // 4. Granting Telemetry Logger Clearance Privileges
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

        vm.stopBroadcast();

        // Log Successful Production Address Space Outread
        console.log("Central Institutional Audit History Deployed at:", address(auditHistory));
        console.log("Morningstar Index Oracle Deployed at:", address(indexOracle));
        console.log("WIPO Expert ADR Vault Deployed at:", address(wipoVault));
        console.log("GAC QA Self-Assessment Deployed at:", address(qaVault));
        console.log("Foundation Governance Ledger Deployed at:", address(foundationLedger));
        console.log("NBA Academic Accreditation Deployed at:", address(accreditationOracle));
        console.log("Holistic Competency Router Deployed at:", address(competencyRouter));
        console.log("Network Engineer Performance Audit Deployed at:", address(networkAudit));
        console.log("IET Technical Report Registry Deployed at:", address(ietRegistry));
        console.log("Raskin Personal Growth Bet Escrow Deployed at:", address(growthBetEscrow));
        console.log("SNG Supplier E-Sourcing Privacy Router Deployed at:", address(supplierRouter));
        console.log("Holden MDR Force Majeure Oracle Deployed at:", address(forceMajeureMdr));
    }
}
