// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/SkepticismProtocol.sol";

contract DeploySkepticismProtocol is Script {
    function run() external {
        vm.startBroadcast();
        new SkepticismProtocol();
        vm.stopBroadcast();
    }
}
