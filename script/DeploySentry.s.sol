// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/GuardianSentryEvaluator.sol";

contract DeploySentry is Script {
    function run() external {
        vm.startBroadcast();
        GuardianSentryEvaluator sentry = new GuardianSentryEvaluator();
        console.log(unicode"🛡️ Guardian Sentry Watch Tower deployed at:", address(sentry));
        vm.stopBroadcast();
    }
}
