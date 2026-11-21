// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {GTACharacterRegistry} from "../contracts/GTACharacterRegistry.sol";

contract DeployGTACharacterRegistry is Script {
    function run() external returns (GTACharacterRegistry registry) {
        address opv = vm.envAddress("OPERATOR_PRIVILEGES_V2");
        address governance = vm.envAddress("GOVERNANCE_ADDRESS");
        vm.startBroadcast();
        registry = new GTACharacterRegistry(opv, governance);
        vm.stopBroadcast();
    }
}
