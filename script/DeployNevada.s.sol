// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../contracts/restoration/nevada/CyberResilienceEnhanced.sol";

contract DeployNevada is Script {
    function run() external {
        // Load from env for safety
        address client = vm.envAddress("NEVADA_CLIENT");
        address contractor = vm.envAddress("STEWARD_ENTITY");

        string memory purpose = "Restore & harden Nevada's state systems post-cyberattack with Mythic Stewardship replication.";

        // Start broadcast
        vm.startBroadcast();

        CyberResilienceEnhanced nevada = new CyberResilienceEnhanced(client, contractor, purpose);

        // JSON loader section
        string memory json = vm.readFile("./contracts/restoration/nevada/CyberResilienceEnhanced.json");
        string[] memory names = vm.parseJsonStringArray(json, ".deliverables[*].name");
        string[] memory descs = vm.parseJsonStringArray(json, ".deliverables[*].description");

        for (uint i = 0; i < names.length; i++) {
            nevada.addDeliverable(names[i], descs[i]);
        }

        vm.stopBroadcast();
    }
}
