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
        address secureBackupWallet = vm.envAddress("BACKUP_WALLET");

        vm.startBroadcast(deployerPrivateKey);

        TimeLockedComplianceSignal gracePeriod = new TimeLockedComplianceSignal();
        InstitutionalAuditHistory auditHistory = new InstitutionalAuditHistory();
        
        AutonomousComplianceEscrowRouter centralRouter = new AutonomousComplianceEscrowRouter(
            address(0xDEAd),
            address(gracePeriod),
            address(auditHistory)
        );

        EcosystemShutdown killSwitch = new EcosystemShutdown(secureBackupWallet);
        WhistleblowerSanctuary whistleblowerSanctuary = new WhistleblowerSanctuary();
        SovereignAllowanceProtocol allowance = new SovereignAllowanceProtocol();
        IPClaimRegistry ipRegistry = new IPClaimRegistry();

        console.log("=== ECOSYSTEM DEPLOYMENT SUCCESSFUL ===");
        console.log("Central Router Deployed at:", address(centralRouter));
        console.log("IP Claim Registry Deployed at:", address(ipRegistry));
        console.log("=======================================");

        vm.stopBroadcast();
    }
}
