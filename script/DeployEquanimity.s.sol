// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/optimization/EquanimityProtocol.sol";

contract DeployEquanimity is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        EquanimityProtocol equanimity = new EquanimityProtocol();

        console.log("EquanimityProtocol Deployed at:", address(equanimity));

        vm.stopBroadcast();
    }
}
