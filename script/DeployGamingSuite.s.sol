// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/MandatoryPhysicalDiscRegistry.sol";
import "../src/GameResaleEscrow.sol";
import "../src/OfflineRightVault.sol";
import "../src/GpuComputeEscrow.sol";
import "../src/IndieGameVault.sol";

contract DeployGamingSuite is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        MandatoryPhysicalDiscRegistry discRegistry = new MandatoryPhysicalDiscRegistry();
        GameResaleEscrow resaleEscrow = new GameResaleEscrow();
        OfflineRightVault offlineVault = new OfflineRightVault("IPFS_OFFLINE_GAME_KEY_HASH_999");
        GpuComputeEscrow gpuEscrow = new GpuComputeEscrow();
        IndieGameVault indieVault = new IndieGameVault(msg.sender);

        console.log("--------------------------------------------------");
        console.log("Disc Registry Deployed at:", address(discRegistry));
        console.log("Resale Escrow Deployed at:", address(resaleEscrow));
        console.log("Offline Vault Deployed at:", address(offlineVault));
        console.log("GPU Escrow Deployed at:", address(gpuEscrow));
        console.log("Indie Vault Deployed at:", address(indieVault));
        console.log("--------------------------------------------------");

        vm.stopBroadcast();
    }
}
