// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/OperatorPrivilegesV2.sol";
import "../src/AIAgentRegistryV2.sol";

contract DeployAIGovernanceV2 is Script {
    function run() external {
        uint256 pk = vm.envUint("PRIVATE_KEY");
        address multisig = vm.envAddress("MULTISIG_ADDRESS");

        vm.startBroadcast(pk);

        // 1. Deploy OperatorPrivilegesV2 (owner = deployer initially)
        OperatorPrivilegesV2 privilegesV2 = new OperatorPrivilegesV2();

        // 2. Deploy AIAgentRegistryV2 (unified auth)
        AIAgentRegistryV2 registryV2 = new AIAgentRegistryV2(address(privilegesV2));

        // 3. Transfer ownership to multisig (2-step: starts pending)
        privilegesV2.transferOwnership(multisig);

        vm.stopBroadcast();

        console.log("=== V2 DEPLOYMENTS ===");
        console.log("OperatorPrivilegesV2:  ", address(privilegesV2));
        console.log("AIAgentRegistryV2:     ", address(registryV2));
        console.log("");
        console.log("=== OWNERSHIP PENDING ===");
        console.log("Pending owner (multisig):", multisig);
        console.log("");
        console.log("NEXT: multisig must call acceptOwnership()");
    }
}
