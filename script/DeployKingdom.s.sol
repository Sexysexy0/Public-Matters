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
        whistleblower.addAuditor(deployer);
        whistleblower.addAuditor(deployer);
        PeopleSovereigntyCovenant covenant = new PeopleSovereigntyCovenant();
        CyberOperationalResilience cyber = new CyberOperationalResilience();

        // --- 3. SOCIAL BRICKS ---
        EndowmentGovernor endowment = new EndowmentGovernor(address(anchor));
        // Register the deployer as a test contributor for the Endowment
        endowment.registerCompany(deployer);

        MicroLendingEscrow lending = new MicroLendingEscrow(500); // 5% interest rate
        // Pre-register deployer as a borrower with a score of 50 for testing
        lending.registerBorrower(deployer, 50);

        HospitalClaimEscrow hospital = new HospitalClaimEscrow(address(endowment));
        LandTitleNFT land = new LandTitleNFT();

        // --- 4. WIRING THE ANCHOR (8 parameters) ---
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

        console.log("=== 13-BRICK KINGDOM DEPLOYED SUCCESSFULLY ===");
        console.log("Registry:      ", address(registry));
        console.log("Vault:         ", address(vault));
        console.log("Treaty:        ", address(treatyBase));
        console.log("Escrow:        ", address(escrow));
        console.log("Arbitration:   ", address(arbitration));
        console.log("Anchor:        ", address(anchor));
        console.log("--- SOVEREIGN BRICKS ---");
        console.log("Whistleblower: ", address(whistleblower));
        console.log("Covenant:      ", address(covenant));
        console.log("CyberRes:      ", address(cyber));
        console.log("--- SOCIAL BRICKS ---");
        console.log("Endowment:     ", address(endowment));
        console.log("Lending:       ", address(lending));
        console.log("Hospital:      ", address(hospital));
        console.log("LandTitle:     ", address(land));
    }
}
