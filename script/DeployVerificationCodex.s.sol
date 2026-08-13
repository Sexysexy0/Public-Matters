// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/VerificationCodex.sol";

contract DeployVerificationCodex is Script {
    function run() external {
        vm.startBroadcast();
        new VerificationCodex();
        vm.stopBroadcast();
    }
}
