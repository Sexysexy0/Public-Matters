// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/OperatorPrivileges.sol";
import "../src/BudgetDeliberationRegistry.sol";

contract DeployBudgetDeliberationRegistry is Script {
    function run() external {
        uint256 pk = vm.envUint("PRIVATE_KEY");

        // Reuse existing OperatorPrivileges (multisig-owned)
        address privileges = vm.envOr(
            "OPERATOR_PRIVILEGES_V2_ADDRESS",
            address(0x1ec4a1fB4e8D297DE39b3995Bcbbd8c5e7fcEF98)
        );

        vm.startBroadcast(pk);
        BudgetDeliberationRegistry registry = new BudgetDeliberationRegistry(privileges);
        console.log("BudgetDeliberationRegistry:", address(registry));
        console.log("Bound to OperatorPrivileges:", privileges);
        vm.stopBroadcast();
    }
}
