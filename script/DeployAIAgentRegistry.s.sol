// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/OperatorPrivileges.sol";
import "../src/AIAgentRegistry.sol";

/**
 * @title DeployAIAgentRegistry
 * @notice Deploys OperatorPrivileges (if needed) + AIAgentRegistry,
 *         wires the deployer as operator + kill-switch authority.
 *
 * Usage:
 *   forge script script/DeployAIAgentRegistry.s.sol \
 *     --rpc-url $SEPOLIA_RPC --private-key $PRIVATE_KEY \
 *     --broadcast --verify
 */
contract DeployAIAgentRegistry is Script {
    function run() external {
        uint256 pk = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(pk);

        console.log("Deployer:", deployer);

        vm.startBroadcast(pk);

        // 1. Deploy OperatorPrivileges (or reuse if you have one)
        OperatorPrivileges privileges = new OperatorPrivileges();
        console.log("OperatorPrivileges:", address(privileges));

        // 2. Deploy AIAgentRegistry bound to privileges
        AIAgentRegistry registry = new AIAgentRegistry(address(privileges));
        console.log("AIAgentRegistry:", address(registry));

        // 3. Wire the deployer as operator on the privileges layer
        //    (constructor already makes deployer owner + operator, but explicit
        //     addOperator ensures ledger-level consistency for future ops)
        privileges.addOperator(deployer);

        // 4. Deployer is already admin + kill-switch authorized via constructor.
        //    No further setup needed unless you want to authorize additional keys.

        vm.stopBroadcast();

        console.log("");
        console.log("== Deployment Summary ==");
        console.log("Network:             Sepolia");
        console.log("OperatorPrivileges: ", address(privileges));
        console.log("AIAgentRegistry:    ", address(registry));
        console.log("Kill-switch admin:  ", deployer);
    }
}
