// SPDX-License-Identifier: MIT
pragma solidity ^0.8.35;

import "forge-std/Script.sol";
import "../contracts/PrivacyGuard.sol";

contract DeployPrivacyGuard is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_PRIVATE_KEY");
        address initialOperator = vm.envAddress("OPERATOR_PRIVILEGES_ADDRESS");

        vm.startBroadcast(deployerPrivateKey);

        PrivacyGuard guard = new PrivacyGuard(initialOperator);

        console.log("PrivacyGuard deployed at:", address(guard));
        console.log("Initial operator set to:", initialOperator);

        vm.stopBroadcast();
    }
}
