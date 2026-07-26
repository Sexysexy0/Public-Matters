// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../contracts/SovereignRegistry.sol";

contract BatchRegister is Script {
    function run() external {
        vm.startBroadcast();
        
        SovereignRegistry registry = SovereignRegistry(0xYourDeployedAddress); // Replace after deployment
        
        // Example batch — you can generate this from your contract list
        registry.register(address(0x1111), "BankFusionDAO", "finance", "1.0");
        registry.register(address(0x2222), "WaterMercyAct_0002", "water", "1.0");
        // ... add all 11k contracts here
        
        vm.stopBroadcast();
    }
}
