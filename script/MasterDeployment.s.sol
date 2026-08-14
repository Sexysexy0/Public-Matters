// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/PublicMattersCovenant.sol";
import "../src/TransparencyMandateRegistry.sol";
import "../src/GovernanceBundle.sol";

/// @title Master Deployment Script
/// @notice Deploys Registry, Governance Bundle, and Covenant in one shot
contract MasterDeployment is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address supremeSteward = vm.envAddress("WALLET_ADDRESS");

        vm.startBroadcast(deployerPrivateKey);

        // Deploy Transparency Registry
        TransparencyMandateRegistry registry = new TransparencyMandateRegistry();

        // Deploy Governance Bundle with Supreme Steward from env
        GovernanceBundle bundle = new GovernanceBundle(address(registry), supremeSteward);

        // Deploy Covenant and auto-link
        bytes32 id = keccak256("BillOfHumanPreservation");
        address covenant = bundle.deployAndLinkCovenant(
            id,
            "Bill of Human Preservation Covenant",
            "Humanity first, Living things next, System last"
        );

        // Add global jurisdictions
        PublicMattersCovenant(covenant).addJurisdiction("Philippines");
        PublicMattersCovenant(covenant).addJurisdiction("Singapore");
        PublicMattersCovenant(covenant).addJurisdiction("Hong Kong SAR");
        PublicMattersCovenant(covenant).addJurisdiction("Bermuda");
        PublicMattersCovenant(covenant).addJurisdiction("United States");
        PublicMattersCovenant(covenant).addJurisdiction("Global");

        vm.stopBroadcast();

        console.log("Registry deployed at:", address(registry));
        console.log("Governance Bundle deployed at:", address(bundle));
        console.log("Covenant deployed and linked at:", covenant);
        console.log("Supreme Steward set to:", supremeSteward);
    }
}
