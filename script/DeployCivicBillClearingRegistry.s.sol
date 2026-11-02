// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/CivicBillClearingRegistry.sol";

contract DeployCivicBillClearingRegistry is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        CivicBillClearingRegistry registry = new CivicBillClearingRegistry();

        vm.stopBroadcast();

        console.log("CivicBillClearingRegistry deployed at:", address(registry));
    }
}
