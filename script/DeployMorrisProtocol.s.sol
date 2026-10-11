// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

import "../src/MorrisResilienceProtocol.sol";
import "forge-std/Script.sol";

contract DeployMorrisProtocol is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address steward = 0x6bDf6D887038AB97957c2f57d05eDd0eb338589A;

        vm.startBroadcast(deployerPrivateKey);

        MorrisResilienceProtocol protocol = new MorrisResilienceProtocol(steward);

        console.log("MorrisResilienceProtocol deployed at:", address(protocol));

        vm.stopBroadcast();
    }
}
