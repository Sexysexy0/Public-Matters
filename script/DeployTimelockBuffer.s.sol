// SPDX-License-Identifier: MIT
pragma solidity ^0.8.35;

import "forge-std/Script.sol";
import "../contracts/TimelockBuffer.sol";

contract DeployTimelockBuffer is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_PRIVATE_KEY");
        address initialOperator = vm.envAddress("OPERATOR_PRIVILEGES_ADDRESS");

        vm.startBroadcast(deployerPrivateKey);

        TimelockBuffer buffer = new TimelockBuffer(initialOperator);

        console.log("TimelockBuffer deployed at:", address(buffer));
        console.log("Initial sovereign operator set to:", initialOperator);

        vm.stopBroadcast();
    }
}
