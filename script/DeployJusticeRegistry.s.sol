// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/JusticeRegistry.sol";

contract DeployJusticeRegistry is Script {
    function run() external {
        vm.startBroadcast();
        JusticeRegistry registry = new JusticeRegistry();
        console.log(unicode"⚖️ Universal Justice Registry deployed at:", address(registry));
        vm.stopBroadcast();
    }
}
