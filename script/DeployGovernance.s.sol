// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/FairGovernanceFramework.sol";

contract DeployGovernance is Script {
    function run() external {
        vm.startBroadcast();
        FairGovernanceFramework gov = new FairGovernanceFramework();
        console.log(unicode"?? Fair Governance Framework deployed at:", address(gov));
        vm.stopBroadcast();
    }
}
