// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {DisasterAidDistributionRegistry} from "../contracts/DisasterAidDistributionRegistry.sol";

contract DeployDisasterAidDistributionRegistry is Script {
    function run() external returns (DisasterAidDistributionRegistry registry) {
        address opv = vm.envAddress("OPERATOR_PRIVILEGES_V2");
        vm.startBroadcast();
        registry = new DisasterAidDistributionRegistry(opv);
        vm.stopBroadcast();
    }
}
