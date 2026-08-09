// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
// Core 6
import "../src/FamilyOfficeRegistry.sol";
import "../src/MultiSigEscrowVault.sol";
import "../src/TokenizedTreatyBase.sol";
import "../src/ProjectMilestoneEscrow.sol";
import "../src/DisputeResolutionArbitration.sol";
import "../src/AnchorGovernanceVault.sol";
// Sovereign 3
import "../src/AntiCorruptionWhistleblowerVault.sol";
import "../src/PeopleSovereigntyCovenant.sol";
import "../src/CyberOperationalResilience.sol";
// Social 4
import "../src/EndowmentGovernor.sol";
import "../src/MicroLendingEscrow.sol";
import "../src/HospitalClaimEscrow.sol";
import "../src/LandTitleNFT.sol";
// Content & Surveillance
import "../src/ContentOwnershipRegistry.sol";
import "../src/CCTVTransparencyRegistry.sol";
// Education & Scholarships
import "../src/EducationCredential.sol";
import "../src/ScholarshipEscrow.sol";
// Job Market
import "../src/JobMatchingDAO.sol";
// Recovery (Knox)
import "../src/KnoxBypassProtocol.sol";
// Genesis
import "../src/GenesisManifesto.sol";
// Soul Bricks
import "../src/DailyResilience.sol";
import "../src/LegacyMint.sol";
import "../src/PermissionlessBroadcast.sol";
import "../src/BroadcasterRegistry.sol";
// Trust & Security
import "../src/TrustIndex.sol";
import "../src/TrustIntegrator.sol";
import "../src/DependencyMonitor.sol";

contract DeployKingdom is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);
        vm.startBroadcast(deployerPrivateKey);
        // --- 1. ORIGINAL BRICKS ---
        FamilyOfficeRegistry registry = new FamilyOfficeRegistry();
        address[] memory signers = new address[](2);
        signers[0] = deployer;
        signers[1] = deployer; // Replace with partner address for Mainnet
        MultiSigEscrowVault vault = new MultiSigEscrowVault(signers, 2);
        TokenizedTreatyBase treatyBase = new TokenizedTreatyBase();
        ProjectMilestoneEscrow escrow = new ProjectMilestoneEscrow(address(vault));
        vault.addSigner(address(escrow));
        DisputeResolutionArbitration arbitration = new DisputeResolutionArbitration();
        AnchorGovernanceVault anchor = new AnchorGovernanceVault();
        // --- 2. SOVEREIGN BRICKS ---
        AntiCorruptionWhistleblowerVault whistleblower = new AntiCorruptionWhistleblowerVault();
        whistleblower.addAuditor(deployer);
        // --- 3. SOCIAL BRICKS ---
        EndowmentGovernor endowment = new EndowmentGovernor(address(anchor));
        endowment.registerCompany(deployer);
        PeopleSovereigntyCovenant covenant = new PeopleSovereigntyCovenant(address(endowment));
        endowment.setAuthorizedTrigger(address(covenant));
        CyberOperationalResilience cyber = new CyberOperationalResilience();
        HospitalClaimEscrow hospital = new HospitalClaimEscrow(address(0)); // placeholder, will be updated
        LandTitleNFT land = new LandTitleNFT();
        // --- 4. CONTENT & SURVEILLANCE ---
        ContentOwnershipRegistry content = new ContentOwnershipRegistry();
        CCTVTransparencyRegistry cctv = new CCTVTransparencyRegistry();
        // --- 5. EDUCATION & SCHOLARSHIPS ---
        EducationCredential edu = new EducationCredential(address(0)); // placeholder
        ScholarshipEscrow scholarship = new ScholarshipEscrow();
        // --- 6. JOB MARKET ---
        JobMatchingDAO job = new JobMatchingDAO(address(edu));
        // --- 7. RECOVERY (KNOX) ---
        KnoxBypassProtocol knox = new KnoxBypassProtocol(address(anchor));
        // --- 8. GENESIS MANIFESTO ---
        GenesisManifesto manifesto = new GenesisManifesto(
            "2008: digital money without a middleman. A compounding graph. The seed of a sovereign system."
        );
        // --- 9. SOUL BRICKS ---
        DailyResilience daily = new DailyResilience("You have survived 100% of your worst days.");
        LegacyMint legacy = new LegacyMint(keccak256(abi.encodePacked("Genesis Manifesto")), "The Bridge is open.");
        PermissionlessBroadcast broadcast = new PermissionlessBroadcast(address(0)); // placeholder
        BroadcasterRegistry broadcaster = new BroadcasterRegistry(new address[](0));
        // --- 10. TRUST & SECURITY ---
        TrustIndex trust = new TrustIndex(100, 10);
        TrustIntegrator trustIntegrator = new TrustIntegrator(address(trust));
        DependencyMonitor monitor = new DependencyMonitor(keccak256(abi.encodePacked("initial-deps")));
        // --- 11. WIRE THE DEPENDENT BRICKS WITH TRUST INTEGRATOR ---
        // Re-deploy Lending with TrustIntegrator (replacing the old one)
        MicroLendingEscrow lending = new MicroLendingEscrow(500, address(trustIntegrator));
        lending.registerBorrower(deployer, 50);
        // Re-deploy Hospital with TrustIntegrator
        hospital = new HospitalClaimEscrow(address(trustIntegrator));
        // Re-deploy Education with TrustIntegrator
        edu = new EducationCredential(address(trustIntegrator));
        // Re-deploy Broadcast with TrustIntegrator
        broadcast = new PermissionlessBroadcast(address(trustIntegrator));
        // --- 12. WIRE THE ANCHOR (8 parameters) ---
        anchor.setCoreContracts(
            address(registry),
            address(vault),
            address(treatyBase),
            address(escrow),
            address(whistleblower),
            address(covenant),
            address(cyber),
            address(arbitration)
        );
        vm.stopBroadcast();
        console.log("=== 30-BRICK KINGDOM DEPLOYED SUCCESSFULLY ===");
        console.log("Registry:        ", address(registry));
        console.log("Vault:           ", address(vault));
        console.log("Treaty:          ", address(treatyBase));
        console.log("Escrow:          ", address(escrow));
        console.log("Arbitration:     ", address(arbitration));
        console.log("Anchor:          ", address(anchor));
        console.log("--- SOVEREIGN ---");
        console.log("Whistleblower:   ", address(whistleblower));
        console.log("Covenant:        ", address(covenant));
        console.log("CyberRes:        ", address(cyber));
        console.log("--- SOCIAL ---");
        console.log("Endowment:       ", address(endowment));
        console.log("Lending:         ", address(lending));
        console.log("Hospital:        ", address(hospital));
        console.log("LandTitle:       ", address(land));
        console.log("--- CONTENT & SURVEILLANCE ---");
        console.log("Content:         ", address(content));
        console.log("CCTV:            ", address(cctv));
        console.log("--- EDUCATION & SCHOLARSHIPS ---");
        console.log("Education:       ", address(edu));
        console.log("Scholarship:     ", address(scholarship));
        console.log("--- JOB MARKET ---");
        console.log("JobMatching:     ", address(job));
        console.log("--- RECOVERY ---");
        console.log("Knox:            ", address(knox));
        console.log("--- GENESIS ---");
        console.log("Manifesto:       ", address(manifesto));
        console.log("--- SOUL BRICKS ---");
        console.log("DailyResilience: ", address(daily));
        console.log("LegacyMint:      ", address(legacy));
        console.log("Permissionless:  ", address(broadcast));
        console.log("BroadcasterReg:  ", address(broadcaster));
        console.log("--- TRUST & SECURITY ---");
        console.log("TrustIndex:      ", address(trust));
        console.log("TrustIntegrator: ", address(trustIntegrator));
        console.log("DependencyMonitor:", address(monitor));
    }
}
