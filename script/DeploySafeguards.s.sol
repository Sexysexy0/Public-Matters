// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../contracts/SimpleMultisig.sol";
import "../contracts/SimpleTimelock.sol";
import "../contracts/HashRegistry.sol";
import "../contracts/EmergencyFreeze.sol";
import "../contracts/BountyVault.sol";

contract DeploySafeguards is Script {
    function run() external {
        uint256 deployerKey = vm.envOr("DEPLOY_KEY", uint256(0));
        require(deployerKey != 0, "set DEPLOY_KEY env var");
        vm.startBroadcast(deployerKey);

        // 1) Timelock (48 hours)
        SimpleTimelock timelock = new SimpleTimelock(48 hours);
        console.log("Timelock:", address(timelock));

        // 2) Multisig (replace placeholder addresses with real owner addresses via env)
        address[] memory owners = new address[](3);
        owners[0] = vm.envAddress("OWNER_A");
        owners[1] = vm.envAddress("OWNER_B");
        owners[2] = vm.envAddress("OWNER_C");
        SimpleMultisig multisig = new SimpleMultisig(owners, 2);
        console.log("Multisig:", address(multisig));

        // 3) HashRegistry
        HashRegistry registry = new HashRegistry();
        console.log("HashRegistry:", address(registry));

        // 4) EmergencyFreeze (guardian = multisig)
        EmergencyFreeze freeze = new EmergencyFreeze(address(multisig));
        console.log("EmergencyFreeze:", address(freeze));

        // 5) BountyVault
        BountyVault vault = new BountyVault();
        console.log("BountyVault:", address(vault));

        vm.stopBroadcast();
    }
}
