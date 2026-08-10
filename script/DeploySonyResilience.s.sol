// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

import "../src/SonyCreativeResilience.sol";
import "forge-std/Script.sol";

contract DeploySonyResilience is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address executive = vm.addr(deployerPrivateKey);
        uint256 initialBudgetCap = 500000000 * 1e18; // Controlled budget cap

        vm.startBroadcast(deployerPrivateKey);

        SonyCreativeResilience sonyProtocol = new SonyCreativeResilience(executive, initialBudgetCap);

        console.log("SonyCreativeResilience deployed at:", address(sonyProtocol));

        vm.stopBroadcast();
    }
}
