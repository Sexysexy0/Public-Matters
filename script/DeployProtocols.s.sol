// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/TransparencyLedger.sol";
import "../src/LocalGovernanceOverride.sol";
import "../src/ResourceCommons.sol";

contract DeployProtocols is Script {
    function run() external {
        vm.startBroadcast();

        // 1. I-deploy ang TransparencyLedger (standard constructor call)
        TransparencyLedger ledger = new TransparencyLedger();
        console.log("TransparencyLedger deployed at:", address(ledger));

        // 2. I-deploy ang LocalGovernanceOverride
        LocalGovernanceOverride governance = new LocalGovernanceOverride(msg.sender);
        console.log("LocalGovernanceOverride deployed at:", address(governance));

        // 3. I-deploy ang ResourceCommons
        ResourceCommons commons = new ResourceCommons();
        console.log("ResourceCommons deployed at:", address(commons));

        vm.stopBroadcast();
    }
}
