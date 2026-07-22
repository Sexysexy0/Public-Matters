// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../contracts/TransparencyRegistry.sol";

contract DeployTransparencyRegistry is Script {
    function run() external {
        // Load private key from .env
        uint256 deployerPrivateKey = vm.envUint("DEPLOY_KEY");

        vm.startBroadcast(deployerPrivateKey);
        TransparencyRegistry registry = new TransparencyRegistry();
        vm.stopBroadcast();

        console.log("TransparencyRegistry deployed at:", address(registry));
    }
}
