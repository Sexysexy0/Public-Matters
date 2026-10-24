// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import {SecurityResponseRegistry} from "../src/security-response/SecurityResponseRegistry.sol";

contract DeploySecurityResponseRegistry is Script {
    function run() external returns (SecurityResponseRegistry registry) {
        vm.startBroadcast();
        registry = new SecurityResponseRegistry();
        vm.stopBroadcast();

        console.log("SecurityResponseRegistry deployed at:", address(registry));
    }
}
