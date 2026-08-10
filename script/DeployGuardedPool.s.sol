// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/GuardedResourcePool.sol";

contract DeployGuardedPool is Script {
    function run() external {
        vm.startBroadcast();
        bytes32 coreContext = keccak256("CORE_PROTOCOL_V1");
        GuardedResourcePool pool = new GuardedResourcePool(coreContext);
        vm.stopBroadcast();
    }
}
