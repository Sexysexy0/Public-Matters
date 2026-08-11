// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/ZKWhistleblowerShield.sol";

contract DeployZKShield is Script {
    function run() external {
        vm.startBroadcast();
        ZKWhistleblowerShield shield = new ZKWhistleblowerShield();
        console.log(unicode"🛡️ ZKWhistleblowerShield deployed at:", address(shield));
        vm.stopBroadcast();
    }
}
