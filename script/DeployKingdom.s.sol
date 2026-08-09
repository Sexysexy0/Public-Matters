// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/FamilyOfficeRegistry.sol";
import "../src/MultiSigEscrowVault.sol";
import "../src/TokenizedTreatyBase.sol";
import "../src/ProjectMilestoneEscrow.sol";
import "../src/DisputeResolutionArbitration.sol";
import "../src/AnchorGovernanceVault.sol";
// Importing the 3 new Sovereign Bricks
import "../src/AntiCorruptionWhistleblowerVault.sol";
import "../src/PeopleSovereigntyCovenant.sol";
import "../src/CyberOperationalResilience.sol";

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

        // --- 2. NEW SOVEREIGN BRICKS ---
        AntiCorruptionWhistleblowerVault whistleblower = new AntiCorruptionWhistleblowerVault();
        // Pre-register 3 auditors (you can change these addresses later, but for now, just deployer for testing)
        whistleblower.addAuditor(deployer);
        whistleblower.addAuditor(deployer); 
        whistleblower.addAuditor(deployer);

        PeopleSovereigntyCovenant covenant = new PeopleSovereigntyCovenant();
        CyberOperationalResilience cyber = new CyberOperationalResilience();

        // --- 3. WIRING THE NEW BRICKS INTO THE ANCHOR ---
        // We will overwrite the setCoreContracts function later to include these specific addresses.
        // For now, we set them directly via public variable assignment to support the new struct.
        // Note: If we want strict 5-parameter setCoreContracts, we need to modify the Anchor contract.
        // Since we're in a Script run, we'll assign them directly to the Anchor's state variables.
        // (Assuming Anchor has public variables we can assign to)
        // Actually, let's keep the Anchor strict. We'll just log them.
        // And we will modify the Anchor to have a specific setter or just keep them separate.
        // For this script, we will just connect them via the Anchor's existing setCoreContracts for the original 6.
        anchor.setCoreContracts(
            address(registry),
            address(vault),
            address(treatyBase),
            address(escrow),
            address(arbitration)
        );

        vm.stopBroadcast();

        console.log("=== Kingdom & Sovereign Bricks Deployed Successfully ===");
        console.log("Registry:   ", address(registry));
        console.log("Vault:      ", address(vault));
        console.log("Treaty:     ", address(treatyBase));
        console.log("Escrow:     ", address(escrow));
        console.log("Arbit:      ", address(arbitration));
        console.log("Anchor:     ", address(anchor));
        console.log("--- NEW BRICKS ---");
        console.log("Whistleblower:", address(whistleblower));
        console.log("Covenant:    ", address(covenant));
        console.log("CyberRes:    ", address(cyber));
    }
}
