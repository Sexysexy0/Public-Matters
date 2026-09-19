// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/OperatorPrivileges.sol";
import "../src/AIGovernanceMultisig.sol";
import "../src/AIAgentUpgradeTimelock.sol";

contract DeployAIGovernanceWave3 is Script {
    function run() external {
        uint256 pk = vm.envUint("PRIVATE_KEY");
        address privilegesAddr = vm.envAddress("OPERATOR_PRIVILEGES_ADDRESS");

        address[] memory signers = new address[](3);
        signers[0] = vm.envAddress("SIGNER_1");
        signers[1] = vm.envAddress("SIGNER_2");
        signers[2] = vm.envAddress("SIGNER_3");

        vm.startBroadcast(pk);

        AIGovernanceMultisig multisig = new AIGovernanceMultisig(privilegesAddr, signers, 2);
        AIAgentUpgradeTimelock timelock = new AIAgentUpgradeTimelock(privilegesAddr);

        vm.stopBroadcast();

        console.log("=== WAVE 3 DEPLOYMENTS ===");
        console.log("AIGovernanceMultisig:      ", address(multisig));
        console.log("AIAgentUpgradeTimelock:    ", address(timelock));
    }
}
