// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/OperatorPrivileges.sol";
import "../src/AIDecisionAudit.sol";

contract DeployAIDecisionAudit is Script {
    function run() external {
        uint256 pk = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(pk);

        // Reuse existing OperatorPrivileges from the AIAgentRegistry deploy
        // If it's already deployed at 0x25E7..., just pass that address
        address privileges = vm.envOr("PRIVILEGES_ADDRESS", address(0x25E737b7eAD518a84383A24b8653A946C6eA0097));

        AIDecisionAudit audit = new AIDecisionAudit(privileges);
        console.log("AIDecisionAudit:", address(audit));
        console.log("Bound to privileges:", privileges);

        vm.stopBroadcast();
    }
}
