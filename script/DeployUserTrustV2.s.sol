// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {UserTrustV2} from "../src/UserTrustV2.sol";

contract DeployUserTrustV2 is Script {
    function run() external {
        vm.startBroadcast();
        UserTrustV2 trust = new UserTrustV2();
        console.log("UserTrustV2 deployed to:", address(trust));
        vm.stopBroadcast();
    }
}
