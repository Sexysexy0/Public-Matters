// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/PublicMattersCovenant.sol";
import "../src/TransparencyMandateRegistry.sol";

/// @title Deployment Script for Public Matters Covenant
/// @notice Deploys the Bill of Human Preservation contract and auto-registers in TransparencyMandateRegistry
contract DeployCovenant is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Deploy covenant with deployer as steward
        PublicMattersCovenant covenant = new PublicMattersCovenant(msg.sender);

        // Add global jurisdictions
        covenant.addJurisdiction("Philippines");
        covenant.addJurisdiction("Singapore");
        covenant.addJurisdiction("Hong Kong SAR");
        covenant.addJurisdiction("Bermuda");
        covenant.addJurisdiction("United States");
        covenant.addJurisdiction("Global");

        // Auto-register covenant in TransparencyMandateRegistry
        TransparencyMandateRegistry registry = TransparencyMandateRegistry(vm.envAddress("TRANSPARENCY_REGISTRY"));

        // FIX: use fileHumanPreservationCovenant (4 args) instead of fileProject (5 args)
        registry.fileHumanPreservationCovenant(
            keccak256(abi.encodePacked("BillOfHumanPreservation")),
            address(covenant),
            "Bill of Human Preservation Covenant",
            "Humanity first, Living things next, System last"
        );

        vm.stopBroadcast();

        console.log("Covenant deployed at:", address(covenant));
        console.log("Registered in TransparencyMandateRegistry at:", address(registry));
    }
}
