// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/PathogenGuardRegistry.sol";

contract DeployPathogenGuard is Script {
    function run() external {
        vm.startBroadcast();
        PathogenGuardRegistry guard = new PathogenGuardRegistry();
        vm.stopBroadcast();
    }
}
