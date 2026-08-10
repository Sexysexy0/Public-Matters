// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

import "../src/UbisoftRescueProtocol.sol";
import "forge-std/Script.sol";

contract DeployUbisoftRescue is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address foundingFamily = vm.addr(deployerPrivateKey);
        uint256 initialDebt = 2450000000 * 1e18; // $2.45 Billion representation

        vm.startBroadcast(deployerPrivateKey);

        UbisoftRescueProtocol rescueProtocol = new UbisoftRescueProtocol(foundingFamily, initialDebt);
        
        console.log("UbisoftRescueProtocol deployed at:", address(rescueProtocol));

        vm.stopBroadcast();
    }
}
