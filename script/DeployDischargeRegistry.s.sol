// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/DischargePublicRegistry.sol";

contract DeployDischargeRegistry is Script {
    function run() external {
        vm.startBroadcast();
        DischargePublicRegistry registry = new DischargePublicRegistry();
        console.log(unicode"? DischargePublicRegistry deployed at:", address(registry));
        vm.stopBroadcast();
    }
}
