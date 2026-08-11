// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/EnvironmentalAuditVault.sol";

contract DeployEnvironmentalAudit is Script {
    function run() external {
        vm.startBroadcast();
        EnvironmentalAuditVault vault = new EnvironmentalAuditVault();
        console.log(unicode"🛡️ EnvironmentalAuditVault deployed at:", address(vault));
        vm.stopBroadcast();
    }
}
