// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {ExecutiveManagementRegistry} from "../contracts/ExecutiveManagementRegistry.sol";

contract DeployExecutiveManagementRegistry is Script {
    function run() external returns (ExecutiveManagementRegistry registry) {
        address opv = vm.envAddress("OPERATOR_PRIVILEGES_V2");
        vm.startBroadcast();
        registry = new ExecutiveManagementRegistry(opv);
        vm.stopBroadcast();
    }
}
