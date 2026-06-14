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

contract DeployGovernanceEcosystem is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        // 1. I-deploy ang Core Registries at Central Auditing Ledger
        TimeLockedComplianceSignal gracePeriod = new TimeLockedComplianceSignal();
        InstitutionalAuditHistory auditHistory = new InstitutionalAuditHistory();
        IPClaimRegistry ipRegistry = new IPClaimRegistry();
        PublicBenefitGrant publicBenefitVault = new PublicBenefitGrant();

        // 2. I-deploy ang Operational Gateways at Multi-Agent Registries
        AutonomousComplianceEscrowRouter centralRouter = new AutonomousComplianceEscrowRouter(
            address(0xDEAd),
            address(gracePeriod),
            address(auditHistory)
        );

        WhistleblowerSanctuary whistleblowerSanctuary = new WhistleblowerSanctuary();
        ComplianceRecoveryEscrow complianceEscrow = new ComplianceRecoveryEscrow(address(publicBenefitVault));
        ShariahComplianceRouter shariahRouter = new ShariahComplianceRouter();
        JudiciaryWelfareVault welfareVault = new JudiciaryWelfareVault(0.05 ether);
        ContractorDelegationRegistry delegationRegistry = new ContractorDelegationRegistry();

        // 3. MASTER INITIALIZATION LOOP: Itali ang Cross-Contract Permissions at Telemetry Routes
        whistleblowerSanctuary.setAuditHistoryAddress(address(auditHistory));
        complianceEscrow.setAuditHistoryAddress(address(auditHistory));
        shariahRouter.setAuditHistoryAddress(address(auditHistory));
        welfareVault.setAuditHistoryAddress(address(auditHistory));
        delegationRegistry.setAuditHistoryAddress(address(auditHistory));

        // Bigyan ng pormal na Root Owner clearance ang sub-systems na mag-log sa central history registry
        auditHistory.setLoggerAuthorization(address(whistleblowerSanctuary), true);
        auditHistory.setLoggerAuthorization(address(complianceEscrow), true);
        auditHistory.setLoggerAuthorization(address(shariahRouter), true);
        auditHistory.setLoggerAuthorization(address(welfareVault), true);
        auditHistory.setLoggerAuthorization(address(delegationRegistry), true);

        console.log("=== MASTER ECOSYSTEM DEPLOYMENT SUCCESSFUL ===");
        console.log("Root Admin Central Router Deployed at:", address(centralRouter));
        console.log("Audit History Registry Deployed at:", address(auditHistory));
        console.log("Whistleblower Sanctuary Deployed at:", address(whistleblowerSanctuary));
        console.log("Compliance Escrow Deployed at:", address(complianceEscrow));
        console.log("Shariah Compliance Router Deployed at:", address(shariahRouter));
        console.log("Judiciary Welfare Vault Deployed at:", address(welfareVault));
        console.log("Contractor Delegation Registry Deployed at:", address(delegationRegistry));
        console.log("==============================================");

        vm.stopBroadcast();
    }
}
