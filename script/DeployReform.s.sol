// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/PublicMattersReform.sol";

contract DeployReform is Script {
    function run() external {
        vm.startBroadcast();
        PublicMattersReform reform = new PublicMattersReform();
        console.log(unicode"? PublicMattersReform deployed at:", address(reform));
        vm.stopBroadcast();
    }
}
