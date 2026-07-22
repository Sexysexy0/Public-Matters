// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../contracts/HRDDGovernance.sol";

contract DeployHRDDGovernance is Script {
    function run() external {
        vm.startBroadcast();

        // deploy HRDD governance contract with you as lead
        HRDDGovernance governance = new HRDDGovernance(msg.sender);

        vm.stopBroadcast();
    }
}
