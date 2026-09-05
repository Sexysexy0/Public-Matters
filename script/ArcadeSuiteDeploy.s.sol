// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/ArcadeGovernance.sol";
import "../src/SymbolismFilter.sol";
import "../src/ChildProtectionFund.sol";

contract ArcadeSuiteDeploy is Script {
    function run() external {
        vm.startBroadcast();

        ArcadeGovernance gov = new ArcadeGovernance();
        SymbolismFilter filter = new SymbolismFilter();
        ChildProtectionFund fund = new ChildProtectionFund(msg.sender);

        console.log("ArcadeGovernance deployed at:", address(gov));
        console.log("SymbolismFilter deployed at:", address(filter));
        console.log("ChildProtectionFund deployed at:", address(fund));

        vm.stopBroadcast();
    }
}
