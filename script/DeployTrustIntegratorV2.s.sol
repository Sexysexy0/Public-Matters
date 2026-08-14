// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {TrustIntegratorV2} from "../src/TrustIntegratorV2.sol";

contract DeployTrustIntegratorV2 is Script {
    function run() external {
        address trustIndex = 0x6A4c9087d91d7C95A596F96a052b8B94E7D9C088;
        address userTrust = 0x0B06c421a8f2368Ad3aa342e0Ef3e9C330999AE7;

        vm.startBroadcast();
        TrustIntegratorV2 integrator = new TrustIntegratorV2(trustIndex, userTrust);
        console.log("TrustIntegratorV2 deployed to:", address(integrator));
        vm.stopBroadcast();
    }
}
