// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

import {Script, console} from "forge-std/Script.sol";
import {CommunityTaxVault} from "../src/CommunityTaxVault.sol";

contract DeployCommunityTaxVault is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Instantiated CommunityTaxVault with 0 arguments to match the updated contract layout
        CommunityTaxVault vault = new CommunityTaxVault();
        console.log("CommunityTaxVault successfully deployed at:", address(vault));

        vm.stopBroadcast();
    }
}
