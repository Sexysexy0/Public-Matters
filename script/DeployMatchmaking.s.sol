// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/CommunityMatchmaking.sol";

contract DeployMatchmaking is Script {
    function run() external {
        vm.startBroadcast();
        CommunityMatchmaking mm = new CommunityMatchmaking();
        console.log(unicode"? Matchmaking Override deployed at:", address(mm));
        vm.stopBroadcast();
    }
}
