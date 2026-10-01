// SPDX-License-Identifier: MIT
pragma solidity ^0.8.35;

import "forge-std/Script.sol";
import "../contracts/AlignmentGuard.sol";

contract DeployAlignmentGuard is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_PRIVATE_KEY");
        address initialOperator = vm.envAddress("OPERATOR_PRIVILEGES_ADDRESS");

        vm.startBroadcast(deployerPrivateKey);

        AlignmentGuard guard = new AlignmentGuard(initialOperator);

        console.log("AlignmentGuard deployed at:", address(guard));
        console.log("Initial sovereign operator set to:", initialOperator);

        vm.stopBroadcast();
    }
}
