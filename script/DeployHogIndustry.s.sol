// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {HogIndustryPolicyRegistry} from "../src/hog-industry/HogIndustryPolicyRegistry.sol";

contract DeployHogIndustry is Script {
    function run() external returns (HogIndustryPolicyRegistry registry) {
        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);
        registry = new HogIndustryPolicyRegistry();
        vm.stopBroadcast();

        console.log("HogIndustryPolicyRegistry deployed at:", address(registry));
        console.log("Admin/Federation rep:", msg.sender);
    }
}
