// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {CommunityTaxVault} from "../src/CommunityTaxVault.sol";

contract DeployCommunityTaxVault is Script {
    function run() external {
        address communityDAO = 0x00Dd17280FD2cA7B51A938D77533702aC08637bc;
        address trustIntegrator = 0xEaB33E69B7599830Dc78D4e446CC02fC9D0aC0B6;

        vm.startBroadcast();
        CommunityTaxVault vault = new CommunityTaxVault(communityDAO, trustIntegrator);
        console.log("CommunityTaxVault deployed to:", address(vault));
        vm.stopBroadcast();
    }
}
