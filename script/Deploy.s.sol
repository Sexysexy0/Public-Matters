// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../contracts/InstitutionOversight.sol";
import "../contracts/ComplianceAuditRegistry.sol";
import "../contracts/MultiHatRoleManager.sol";
import "../contracts/IPClaimRegistry.sol";
import "../contracts/GuardianSignalConsole.sol";
import "../contracts/InstitutionEmergencyFreeze.sol";
import "../contracts/VestingGovernanceVault.sol";
import "../contracts/AnonymousReputationSystem.sol";
import "../contracts/DecentralizedWhistleblowerInbox.sol";
import "../contracts/PublicBenefitGrant.sol";
import "../contracts/ImmutablePolicyLedger.sol";
import "../contracts/ComplianceRecoveryEscrow.sol";
import "../contracts/TimeLockedComplianceSignal.sol";
import "../contracts/AnonymousIdentityProof.sol";
import "../contracts/InstitutionalAuditHistory.sol";
import "../contracts/AutonomousComplianceEscrowRouter.sol";
import "../contracts/AnonymousGovernanceDAO.sol";
import "../contracts/CompliantIdentityRevealer.sol";
import "../contracts/EcosystemShutdown.sol";

contract DeployGovernanceEcosystem is Script {
    function run() external {
        // Kuhanin ang deployer private key mula sa iyong terminal environment variables
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        // Simulan ang broadcast ng mga transaksyon sa blockchain
        vm.startBroadcast(deployerPrivateKey);

        // 1. I-deploy ang Core Foundation at Identity Contracts
        MultiHatRoleManager roleManager = new MultiHatRoleManager();
        
        bytes32 initialCommitment = keccak256(abi.encodePacked("ALPHA_ORIGIN_SOVEREIGN_OVERSIGHT"));
        AnonymousIdentityProof identityProof = new AnonymousIdentityProof(initialCommitment);
        CompliantIdentityRevealer identityRevealer = new CompliantIdentityRevealer();

        // 2. I-deploy ang Data Registries at Reputasyon (Mga Resibo)
        AnonymousReputationSystem reputation = new AnonymousReputationSystem();
        TimeLockedComplianceSignal gracePeriod = new TimeLockedComplianceSignal();
        InstitutionalAuditHistory auditHistory = new InstitutionalAuditHistory();
        ImmutablePolicyLedger policyLedger = new ImmutablePolicyLedger();
        IPClaimRegistry ipRegistry = new IPClaimRegistry();

        // 3. I-deploy ang Central Router at ipasok ang dependencies ng Registries
        AutonomousComplianceEscrowRouter centralRouter = new AutonomousComplianceEscrowRouter(
            address(reputation),
            address(gracePeriod),
            address(auditHistory)
        );

        // 4. I-deploy ang Operational at Emergency Defense Vaults
        // Maglaan ng 1 ETH pool para sa simula ng Public Benefit Grants
        PublicBenefitGrant publicGrants = new PublicBenefitGrant{value: 1 ether}();
        
        // Ipasok ang Public Benefit Vault address sa Escrow Recovery Contract
        ComplianceRecoveryEscrow recoveryEscrow = new ComplianceRecoveryEscrow(address(publicGrants));
        
        // I-target ang backup wallet para sa global kill-switch
        address secureBackupWallet = vm.envAddress("BACKUP_WALLET");
        EcosystemShutdown killSwitch = new EcosystemShutdown(secureBackupWallet);

        // 5. I-deploy ang Komunikasyon at Governance Channels
        InstitutionOversight oversight = new InstitutionOversight();
        ComplianceAuditRegistry auditRegistry = new ComplianceAuditRegistry();
        GuardianSignalConsole signalConsole = new GuardianSignalConsole();
        InstitutionEmergencyFreeze emergencyFreeze = new InstitutionEmergencyFreeze();
        DecentralizedWhistleblowerInbox whistleblowerInbox = new DecentralizedWhistleblowerInbox();
        AnonymousGovernanceDAO shadowDAO = new AnonymousGovernanceDAO();

        // Mag-release ng pondo para sa conditional vesting allocation (halimbawa: 6 months duration)
        VestingGovernanceVault vestingVault = new VestingGovernanceVault{value: 1 ether}();

        // I-log sa terminal ang mga master addresses para sa iyong registry bookkeeping
        console.log("=== ECOSYSTEM DEPLOYMENT SUCCESSFUL ===");
        console.log("Central Router Deployed at:", address(centralRouter));
        console.log("Shadow DAO Deployed at:", address(shadowDAO));
        console.log("Sovereign Kill-Switch Deployed at:", address(killSwitch));
        console.log("=======================================");

        vm.stopBroadcast();
    }
}
