// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../contracts/defense/LTTDefenseSuite.sol";

contract DeployLTTSuite is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        // 1. Deploy Vendor Shutdown Protection
        VendorShutdownProtection vendorProt = new VendorShutdownProtection(
            "QmOfflinePatchHash123456789SovereignKey"
        );

        // 2. Deploy Digital Ownership Enforcer
        DigitalOwnershipEnforcer ownershipEnforcer = new DigitalOwnershipEnforcer();

        vm.stopBroadcast();

        console.log("VendorShutdownProtection Deployed at:", address(vendorProt));
        console.log("DigitalOwnershipEnforcer Deployed at:", address(ownershipEnforcer));
    }
}
