// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

import "../src/IndigenousKnowledgeRegistry.sol";
import "forge-std/Script.sol";

contract DeployIndigenousRegistry is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address guardian = vm.addr(deployerPrivateKey);

        vm.startBroadcast(deployerPrivateKey);

        IndigenousKnowledgeRegistry registry = new IndigenousKnowledgeRegistry(guardian);

        console.log("IndigenousKnowledgeRegistry deployed at:", address(registry));

        vm.stopBroadcast();
    }
}
