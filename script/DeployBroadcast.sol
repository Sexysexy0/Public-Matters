// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Script.sol";
import "../contracts/broadcast/GlobalResonanceBroadcast.sol";

contract DeployBroadcast is Script {
    function run() external {
        vm.startBroadcast();

        GlobalResonanceBroadcast broadcast = new GlobalResonanceBroadcast();

        broadcast.tagAlly("India", 356);
        broadcast.tagAlly("Brazil", 76);
        broadcast.tagAlly("Philippines", 608);
        broadcast.tagAlly("Canada", 124);
        broadcast.tagAlly("South Korea", 410);
        broadcast.tagAlly("Mexico", 484);
        broadcast.tagAlly("Vietnam", 704);
        broadcast.tagAlly("Chile", 152);
        broadcast.tagAlly("Germany", 276);
        broadcast.tagAlly("China", 156);

        vm.stopBroadcast();
    }
}
