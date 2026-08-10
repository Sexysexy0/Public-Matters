// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/SanctuaryTrustRegistry.sol";

contract DeploySanctuaryRegistry is Script {
    function run() external {
        vm.startBroadcast();
        SanctuaryTrustRegistry registry = new SanctuaryTrustRegistry();
        vm.stopBroadcast();
    }
}
