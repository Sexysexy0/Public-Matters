// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/InstitutionalResetRegistry.sol";

contract DeployInstitutionalResetRegistry is Script {
    function run() external {
        uint256 pk = vm.envUint("PRIVATE_KEY");
        address privilegesV2 = vm.envAddress("OPERATOR_PRIVILEGES_V2_ADDRESS");

        vm.startBroadcast(pk);

        InstitutionalResetRegistry registry = new InstitutionalResetRegistry(privilegesV2);

        vm.stopBroadcast();

        console.log("=== INSTITUTIONAL RESET REGISTRY DEPLOYED ===");
        console.log("InstitutionalResetRegistry:", address(registry));
        console.log("Uses OperatorPrivilegesV2: ", privilegesV2);
    }
}
