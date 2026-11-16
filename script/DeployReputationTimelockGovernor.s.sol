// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {ReputationTimelockGovernor} from "../contracts/ReputationTimelockGovernor.sol";

contract DeployReputationTimelockGovernor is Script {
    function run() external returns (ReputationTimelockGovernor governor) {
        address opv = vm.envAddress("OPERATOR_PRIVILEGES_V2");
        uint256 delay = 3600; // 1 hour timelock
        vm.startBroadcast();
        governor = new ReputationTimelockGovernor(opv, delay);
        vm.stopBroadcast();
    }
}
