// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

import "../src/SpiritualDataIntegrity.sol";
import "forge-std/Script.sol";

contract DeploySpiritualProtocol is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address seeker = vm.addr(deployerPrivateKey);

        vm.startBroadcast(deployerPrivateKey);

        SpiritualDataIntegrity protocol = new SpiritualDataIntegrity(seeker);

        console.log("SpiritualDataIntegrity deployed at:", address(protocol));

        vm.stopBroadcast();
    }
}
