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

contract DeployGovernanceEcosystem is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        // 1. I-deploy ang Core Registries at Auditing Ledger
        TimeLockedComplianceSignal gracePeriod = new TimeLockedComplianceSignal();
        InstitutionalAuditHistory auditHistory = new InstitutionalAuditHistory();
        IPClaimRegistry ipRegistry = new IPClaimRegistry();
        PublicBenefitGrant publicBenefitVault = new PublicBenefitGrant();

        // 2. I-deploy ang Operational Gateways (Router, Sanctuary, Escrow)
        AutonomousComplianceEscrowRouter centralRouter = new AutonomousComplianceEscrowRouter(
            address(0xDEAd),
            address(gracePeriod),
            address(auditHistory)
        );

        WhistleblowerSanctuary whistleblowerSanctuary = new WhistleblowerSanctuary();
        ComplianceRecoveryEscrow complianceEscrow = new ComplianceRecoveryEscrow(address(publicBenefitVault));

        // 3. AUTOMATED INITIALIZATION LOOP: Itali ang Cross-Contract Permissions
        // Ikabit ang Audit History tracking addresses sa sub-systems
        whistleblowerSanctuary.setAuditHistoryAddress(address(auditHistory));
        complianceEscrow.setAuditHistoryAddress(address(auditHistory));

        // Bigyan ng pormal na awtorisasyon ang sub-systems na mag-log sa Audit History
        auditHistory.setLoggerAuthorization(address(whistleblowerSanctuary), true);
        auditHistory.setLoggerAuthorization(address(complianceEscrow), true);

        console.log("=== ECOSYSTEM DEPLOYMENT SUCCESSFUL ===");
        console.log("Central Router Deployed at:", address(centralRouter));
        console.log("Audit History Registry Deployed at:", address(auditHistory));
        console.log("Whistleblower Sanctuary Deployed at:", address(whistleblowerSanctuary));
        console.log("Compliance Escrow Deployed at:", address(complianceEscrow));
        console.log("=======================================");

        vm.stopBroadcast();
    }
}
