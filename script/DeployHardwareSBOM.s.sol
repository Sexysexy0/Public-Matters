// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/compliance/HardwareSBOMRegistry.sol";

contract DeployHardwareSBOM is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        AttributionRegistry sbomRegistry = new AttributionRegistry();

        console.log("Hardware SBOM AttributionRegistry Deployed at:", address(sbomRegistry));

        vm.stopBroadcast();
    }
}
