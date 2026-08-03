// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../contracts/LaborEquilibrium.sol";
import "../contracts/SovereignLaborProtocol.sol";
import "../contracts/SovereignHarvestProtocol.sol";
import "../contracts/SovereignTransitProtocol.sol";
import "../contracts/SovereignTreasuryProtocol.sol";

contract DeploySovereignOS is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envOr("PRIVATE_KEY", uint256(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80));

        vm.startBroadcast(deployerPrivateKey);

        LaborEquilibrium laborEq = new LaborEquilibrium();
        
        // Upgraded Living Wage Floor: 1000 units for worker prosperity
        SovereignLaborProtocol laborProto = new SovereignLaborProtocol(1000);
        
        SovereignHarvestProtocol harvest = new SovereignHarvestProtocol();
        SovereignTransitProtocol transit = new SovereignTransitProtocol();
        SovereignTreasuryProtocol treasury = new SovereignTreasuryProtocol();

        console.log("LaborEquilibrium Deployed at:", address(laborEq));
        console.log("SovereignLaborProtocol Deployed at:", address(laborProto));
        console.log("SovereignHarvestProtocol Deployed at:", address(harvest));
        console.log("SovereignTransitProtocol Deployed at:", address(transit));
        console.log("SovereignTreasuryProtocol Deployed at:", address(treasury));

        vm.stopBroadcast();
    }
}
