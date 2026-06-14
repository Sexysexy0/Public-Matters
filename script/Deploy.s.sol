// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../contracts/IPClaimRegistry.sol";
import "../contracts/SovereignAllowanceProtocol.sol";
import "../contracts/WhistleblowerSanctuary.sol";
import "../contracts/PublicBenefitGrant.sol";
import "../contracts/ImmutablePolicyLedger.sol";
import "../contracts/ComplianceRecoveryEscrow.sol";
import "../contracts/TimeLockedComplianceSignal.sol";
import "../contracts/AnonymousIdentityProof.sol";
import "../contracts/InstitutionalAuditHistory.sol";
import "../contracts/AutonomousComplianceEscrowRouter.sol";
import "../contracts/CompliantIdentityRevealer.sol";
import "../contracts/EcosystemShutdown.sol";
import "../contracts/ShariahComplianceRouter.sol";
import "../contracts/JudiciaryWelfareVault.sol";
import "../contracts/ContractorDelegationRegistry.sol";
import "../contracts/JudicialDisputeRouter.sol";
import "../contracts/SubcontractorComplianceEscrow.sol";
import "../contracts/FinancialIndexReconstitutionOracle.sol";
import "../contracts/WipoContentExpertDetermination.sol";
import "../contracts/QualityAssuranceSelfAssessment.sol";
import "../contracts/FoundationGovernanceLedger.sol";
import "../contracts/AcademicAccreditationSAROracle.sol";
import "../contracts/HolisticCompetencyRegistry.sol";

contract DeployGovernanceEcosystem is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        // 1. I-deploy ang Auditing Registry Ledger
        InstitutionalAuditHistory auditHistory = new InstitutionalAuditHistory();

        // 2. I-deploy ang Bagong Anim (6) na GRC Sovereign Strategic Modules
        FinancialIndexReconstitutionOracle indexOracle = new FinancialIndexReconstitutionOracle();
        WipoContentExpertDetermination wipoVault = new WipoContentExpertDetermination();
        QualityAssuranceSelfAssessment qaVault = new QualityAssuranceSelfAssessment();
        FoundationGovernanceLedger foundationLedger = new FoundationGovernanceLedger();
        AcademicAccreditationSAROracle accreditationOracle = new AcademicAccreditationSAROracle();
        HolisticCompetencyRegistry competencyRouter = new HolisticCompetencyRegistry();

        // 3. MASTER TELEMETRY BINDING CONNECTORS
        indexOracle.setAuditHistoryAddress(address(auditHistory));
        wipoVault.setAuditHistoryAddress(address(auditHistory));
        qaVault.setAuditHistoryAddress(address(auditHistory));
        foundationLedger.setAuditHistoryAddress(address(auditHistory));
        acreditationOracle.setAuditHistoryAddress(address(auditHistory));
        competencyRouter.setAuditHistoryAddress(address(auditHistory));

        auditHistory.setLoggerAuthorization(address(indexOracle), true);
        auditHistory.setLoggerAuthorization(address(wipoVault), true);
        auditHistory.setLoggerAuthorization(address(qaVault), true);
        auditHistory.setLoggerAuthorization(address(foundationLedger), true);
        auditHistory.setLoggerAuthorization(address(acreditationOracle), true);
        auditHistory.setLoggerAuthorization(address(competencyRouter), true);

        console.log("=== GLOBAL SOVEREIGN ECOSYSTEM GRC DEPLOY SUCCESSFUL ===");
        console.log("Morningstar Index Oracle Deployed at:", address(indexOracle));
        console.log("WIPO ADR Determination Deployed at:", address(wipoVault));
        console.log("Quality Assurance QA Vault Deployed at:", address(qaVault));
        console.log("Foundation Governance Ledger Deployed at:", address(foundationLedger));
        console.log("NBA Academic Accreditation Deployed at:", address(acreditationOracle));
        console.log("Engineers Australia Router Deployed at:", address(competencyRouter));
        console.log("=========================================================");

        vm.stopBroadcast();
    }
}
