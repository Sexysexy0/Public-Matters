// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/FamilyOfficeRegistry.sol";
import "../src/MultiSigEscrowVault.sol";
import "../src/TokenizedTreatyBase.sol";
import "../src/ProjectMilestoneEscrow.sol";
import "../src/DisputeResolutionArbitration.sol";
import "../src/AnchorGovernanceVault.sol";

contract DeployKingdom is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        vm.startBroadcast(deployerPrivateKey);

        // 1. Deploy Registry
        FamilyOfficeRegistry registry = new FamilyOfficeRegistry();

        // 2. Deploy MultiSig Vault (set your initial signers here)
        address[] memory signers = new address[](2);
        signers[0] = deployer; // You
        signers[1] = deployer; // Temporarily using same address    // <--- Replace this with your trusted partner's address before deploying!
        MultiSigEscrowVault vault = new MultiSigEscrowVault(signers, 2);
        
        // 3. Deploy Treaty Base
        TokenizedTreatyBase treatyBase = new TokenizedTreatyBase();

        // 4. Deploy Escrow (linked to the Vault)
        ProjectMilestoneEscrow escrow = new ProjectMilestoneEscrow(address(vault));
        
        // Important: The Escrow needs to be a signer to submit transactions
        vault.addSigner(address(escrow));

        // 5. Deploy Arbitration
        DisputeResolutionArbitration arbitration = new DisputeResolutionArbitration();

        // 6. Deploy Anchor (Command Center)
        AnchorGovernanceVault anchor = new AnchorGovernanceVault();

        // 7. WIRE EVERYTHING TOGETHER
        anchor.setCoreContracts(
            address(registry),
            address(vault),
            address(treatyBase),
            address(escrow),
            address(arbitration)
        );

        vm.stopBroadcast();

        console.log("=== Kingdom Deployed Successfully ===");
        console.log("Registry:", address(registry));
        console.log("Vault:   ", address(vault));
        console.log("Treaty:  ", address(treatyBase));
        console.log("Escrow:  ", address(escrow));
        console.log("Arbit:   ", address(arbitration));
        console.log("Anchor:  ", address(anchor));
    }
}
