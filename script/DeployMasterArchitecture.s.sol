// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

import {Script, console} from "forge-std/Script.sol";
import {GlobalAssetRegistry} from "../src/GlobalAssetRegistry.sol";
import {TrustIntegrator} from "../src/TrustIntegrator.sol";
import {TrustIndex} from "../src/TrustIndex.sol";

contract DeployMasterArchitecture is Script {
    function run() external {
        uint256 deployerPrivateKey =
            vm.envOr("PRIVATE_KEY", uint256(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80));

        vm.startBroadcast(deployerPrivateKey);

        // 1. Deploy Core Global Asset Registry
        GlobalAssetRegistry registry = new GlobalAssetRegistry();
        console.log("GlobalAssetRegistry deployed at:", address(registry));

        // 2. Deploy TrustIndex (passing uint256 initial values)
        TrustIndex trustIndex = new TrustIndex(100, 10);
        console.log("TrustIndex deployed at:", address(trustIndex));

        // 3. Deploy TrustIntegrator gamit ang TrustIndex address
        TrustIntegrator trustIntegrator = new TrustIntegrator(address(trustIndex));
        console.log("TrustIntegrator deployed at:", address(trustIntegrator));

        // 4. Register Standard Roles (Role Bitmaps)
        address sampleSteward = address(0x1001);
        address sampleAuditor = address(0x1002);

        registry.setEntityRoles(sampleSteward, registry.ROLE_STEWARD());
        registry.setEntityRoles(sampleAuditor, registry.ROLE_AUDITOR());

        console.log("Roles initialized successfully in Bitmapped Matrix.");

        vm.stopBroadcast();
    }
}
