// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {CommunityFund} from "../src/CommunityFund.sol";

contract DeployCommunityFund is Script {
    function run() external {
        address userTrust = 0x067294c832d7aE858c7240dc31c8D965C1D917f1;
        address trustIntegrator = 0xEaB33E69B7599830Dc78D4e446CC02fC9D0aC0B6;
        address taxVault = 0xBEb87cB2f38def956ff95058FD0b1EcC98D30A76;

        vm.startBroadcast();
        CommunityFund fund = new CommunityFund(userTrust, trustIntegrator, taxVault);
        console.log("CommunityFund deployed to:", address(fund));
        vm.stopBroadcast();
    }
}
