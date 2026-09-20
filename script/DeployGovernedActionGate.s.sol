// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/GovernedActionGate.sol";

contract DeployGovernedActionGate is Script {
    function run() external {
        uint256 pk = vm.envUint("PRIVATE_KEY");

        address privileges = vm.envOr("PRIVILEGES_ADDRESS", address(0x25E737b7eAD518a84383A24b8653A946C6eA0097));
        address registry   = vm.envOr("REGISTRY_ADDRESS",   address(0xfb302dD14e235266A6EdedfdD2CDF709c55D7aF5));
        address audit      = vm.envOr("AUDIT_ADDRESS",      address(0x9E93a6A3421AD0F8F029406aC3Ce3E21e8544074));

        uint256 threshold = 2;         // 2-of-N
        uint256 ttl = 7 days;

        vm.startBroadcast(pk);
        GovernedActionGate gate = new GovernedActionGate(privileges, registry, audit, threshold, ttl);
        console.log("GovernedActionGate:", address(gate));
        console.log("Bound privileges:  ", privileges);
        console.log("Bound registry:    ", registry);
        console.log("Bound audit:       ", audit);
        console.log("Threshold:         ", threshold);
        console.log("TTL (sec):         ", ttl);
        vm.stopBroadcast();
    }
}
