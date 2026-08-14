// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {UserTrust} from "../src/UserTrust.sol";

contract DeployUserTrust is Script {
    function run() external {
        vm.startBroadcast();
        UserTrust trust = new UserTrust();
        console.log("UserTrust deployed to:", address(trust));
        vm.stopBroadcast();
    }
}
