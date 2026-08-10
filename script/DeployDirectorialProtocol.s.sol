// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

import "../src/MythologicalDirectorialIntegrity.sol";
import "forge-std/Script.sol";

contract DeployDirectorialProtocol is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address auteur = vm.addr(deployerPrivateKey);

        vm.startBroadcast(deployerPrivateKey);

        MythologicalDirectorialIntegrity directorialProtocol = new MythologicalDirectorialIntegrity(auteur);

        console.log("MythologicalDirectorialIntegrity deployed at:", address(directorialProtocol));

        vm.stopBroadcast();
    }
}
