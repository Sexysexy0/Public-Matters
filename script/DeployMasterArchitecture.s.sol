// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

import {Script, console} from "forge-std/Script.sol";
import {GlobalAssetRegistry} from "../src/GlobalAssetRegistry.sol";
import {TrustIntegrator} from "../src/TrustIntegrator.sol";
import {TrustIndex} from "../src/TrustIndex.sol";
import {InfrastructureProofRegistry} from "../src/InfrastructureProofRegistry.sol";
import {TransientSupplyPassport} from "../src/TransientSupplyPassport.sol";
import {EmergencyResponderRegistry} from "../src/EmergencyResponderRegistry.sol";
import {CommunityFloodVault} from "../src/CommunityFloodVault.sol";
import {ZKWhistleblowerOversight} from "../src/ZKWhistleblowerOversight.sol";
import {DeSciManuscriptEquity} from "../src/DeSciManuscriptEquity.sol";

contract DeployMasterArchitecture is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envOr("PRIVATE_KEY", uint256(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80));

        vm.startBroadcast(deployerPrivateKey);

        // 1. Core Base Contracts
        GlobalAssetRegistry registry = new GlobalAssetRegistry();
        console.log("GlobalAssetRegistry deployed at:", address(registry));

        TrustIndex trustIndex = new TrustIndex(100, 10);
        console.log("TrustIndex deployed at:", address(trustIndex));

        TrustIntegrator trustIntegrator = new TrustIntegrator(address(trustIndex));
        console.log("TrustIntegrator deployed at:", address(trustIntegrator));

        // 2. Public Infra & Anti-Ghosting
        InfrastructureProofRegistry infraRegistry = new InfrastructureProofRegistry(address(trustIntegrator));
        console.log("InfrastructureProofRegistry deployed at:", address(infraRegistry));

        // 3. EIP-1153 Transient Supply Passport
        TransientSupplyPassport supplyPassport = new TransientSupplyPassport();
        console.log("TransientSupplyPassport deployed at:", address(supplyPassport));

        // 4. Emergency Responder & Community Flood Vault
        EmergencyResponderRegistry responderRegistry = new EmergencyResponderRegistry(address(trustIntegrator));
        console.log("EmergencyResponderRegistry deployed at:", address(responderRegistry));

        CommunityFloodVault floodVault = new CommunityFloodVault(address(trustIntegrator));
        console.log("CommunityFloodVault deployed at:", address(floodVault));

        // 5. ZK Whistleblower & DeSci Manuscript Modules
        bytes32 mockRoot = keccak256(abi.encodePacked("INITIAL_MERKLE_ROOT_2026"));
        ZKWhistleblowerOversight zkOversight = new ZKWhistleblowerOversight(mockRoot);
        console.log("ZKWhistleblowerOversight deployed at:", address(zkOversight));

        DeSciManuscriptEquity desciEquity = new DeSciManuscriptEquity(address(trustIntegrator));
        console.log("DeSciManuscriptEquity deployed at:", address(desciEquity));

        vm.stopBroadcast();
    }
}
