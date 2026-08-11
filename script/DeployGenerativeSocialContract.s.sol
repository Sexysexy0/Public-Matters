// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/GenerativeSocialContract.sol";

contract DeployGenerativeSocialContract is Script {
    function run() external {
        vm.startBroadcast();
        GenerativeSocialContract contractInstance = new GenerativeSocialContract();
        console.log(unicode"🤝 Generative Social Contract deployed at:", address(contractInstance));
        vm.stopBroadcast();
    }
}
