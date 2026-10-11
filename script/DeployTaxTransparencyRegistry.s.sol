// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/TaxTransparencyRegistry.sol";

contract DeployTaxTransparencyRegistry is Script {
    function run() external {
        uint256 pk = vm.envUint("PRIVATE_KEY");

        // Reuse existing OperatorPrivilegesV2 (multisig-owned)
        address privileges = vm.envOr(
            "OPERATOR_PRIVILEGES_V2_ADDRESS",
            address(0x1ec4a1fB4e8D297DE39b3995Bcbbd8c5e7fcEF98)
        );

        vm.startBroadcast(pk);
        TaxTransparencyRegistry registry = new TaxTransparencyRegistry(privileges);
        vm.stopBroadcast();

        console.log("TaxTransparencyRegistry:", address(registry));
        console.log("Bound to OperatorPrivilegesV2:", privileges);
    }
}
