// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/SkillRegistry.sol";

contract DeploySkillRegistry is Script {
    function run() external {
        vm.startBroadcast();
        SkillRegistry registry = new SkillRegistry();
        console.log(unicode"🛠️ Community Skill Share Registry deployed at:", address(registry));
        vm.stopBroadcast();
    }
}
