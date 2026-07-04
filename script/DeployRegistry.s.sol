// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {RoleAuthorityRegistry} from "../contracts/RoleAuthorityRegistry.sol";

/**
 * @title DeployRegistry
 * @dev Automated deployment configuration routing logic for system permissions modules.
 */
contract DeployRegistry is Script {
    function run() external {
        // Hilain ang variable private key context mula sa localized .env workspace settings
        uint256 deployerPrivateKey = vm.envOr("PRIVATE_KEY", uint256(1));
        address deployerAddress = vm.addr(deployerPrivateKey);

        vm.startBroadcast(deployerPrivateKey);

        // Hakbang 1: Genesis creation block para sa central security checkpoint ledger
        RoleAuthorityRegistry registry = new RoleAuthorityRegistry(deployerAddress);
        console.log("Central RoleAuthorityRegistry Deployed at:", address(registry));

        // Hakbang 2: Setup role authority nodes para sa iyong system tracking identities
        // Kunwari ay magtatalaga tayo ng dummy addresses para sa verification simulation loops
        address simulatedOverseer = address(0x01);
        address simulatedSteward = address(0x02);

        registry.grantRole(registry.OVERSEER_ROLE(), simulatedOverseer);
        registry.grantRole(registry.STEWARD_ROLE(), simulatedSteward);

        console.log("System Status: Roles initialization sequences mapped successfully.");

        vm.stopBroadcast();
    }
}
