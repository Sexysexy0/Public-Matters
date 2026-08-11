// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/GreenBondEscrow.sol";

contract DeployGreenBond is Script {
    function run() external {
        vm.startBroadcast();
        GreenBondEscrow escrow = new GreenBondEscrow();
        console.log(unicode"🌱 GreenBondEscrow deployed at:", address(escrow));
        vm.stopBroadcast();
    }
}
