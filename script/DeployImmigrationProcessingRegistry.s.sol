// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/ImmigrationProcessingRegistry.sol";

contract DeployImmigrationProcessingRegistry is Script {
    function run() external {
        uint256 pk = vm.envUint("PRIVATE_KEY");
        address privileges = vm.envOr(
            "OPERATOR_PRIVILEGES_V2_ADDRESS",
            address(0x1ec4a1fB4e8D297DE39b3995Bcbbd8c5e7fcEF98)
        );
        vm.startBroadcast(pk);
        ImmigrationProcessingRegistry r = new ImmigrationProcessingRegistry(privileges);
        vm.stopBroadcast();
        console.log("ImmigrationProcessingRegistry:", address(r));
        console.log("Bound to OperatorPrivilegesV2:", privileges);
    }
}
