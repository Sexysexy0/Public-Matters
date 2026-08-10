// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

import "../src/BethesdaQualityProtocol.sol";
import "forge-std/Script.sol";

contract DeployBethesdaProtocol is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address director = vm.addr(deployerPrivateKey);
        uint256 initialQA = 180; // 180 days strict testing

        vm.startBroadcast(deployerPrivateKey);

        BethesdaQualityProtocol bethesdaProtocol = new BethesdaQualityProtocol(director, initialQA);

        console.log("BethesdaQualityProtocol deployed at:", address(bethesdaProtocol));

        vm.stopBroadcast();
    }
}

