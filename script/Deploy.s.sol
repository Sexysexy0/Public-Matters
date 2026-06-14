// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../contracts/DecentralizedWhistleblowerInbox.sol";
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

        // Deployment sequence batay sa active on-chain codebase
        bytes32 initialCommitment = bytes32(uint256(1));
        AnonymousIdentityProof identityProof = new AnonymousIdentityProof(initialCommitment);
        CompliantIdentityRevealer identityRevealer = new CompliantIdentityRevealer();
        
        TimeLockedComplianceSignal gracePeriod = new TimeLockedComplianceSignal();
        InstitutionalAuditHistory auditHistory = new InstitutionalAuditHistory();
        ImmutablePolicyLedger policyLedger = new ImmutablePolicyLedger();
        
        // I-deploy ang Router (Gumagamit ng dummy validation address para sa reputation system sa ngayon)
        AutonomousComplianceEscrowRouter centralRouter = new AutonomousComplianceEscrowRouter(
            address(0xDEAd),
            address(gracePeriod),
            address(auditHistory)
        );

        PublicBenefitGrant publicGrants = new PublicBenefitGrant();
        ComplianceRecoveryEscrow recoveryEscrow = new ComplianceRecoveryEscrow(address(publicGrants));
        EcosystemShutdown killSwitch = new EcosystemShutdown(secureBackupWallet);
        DecentralizedWhistleblowerInbox whistleblower = new DecentralizedWhistleblowerInbox();

        console.log("=== ECOSYSTEM DEPLOYMENT SUCCESSFUL ===");
        console.log("Central Router Deployed at:", address(centralRouter));
        console.log("Sovereign Kill-Switch Deployed at:", address(killSwitch));
        console.log("=======================================");

        vm.stopBroadcast();
    }
}
