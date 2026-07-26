// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../contracts/DirectorGovernance.sol";

contract DeployDirectorGovernance is Script {
    function run() external {
        vm.startBroadcast();

        // deploy governance contract with you as lead director
        DirectorGovernance governance = new DirectorGovernance(msg.sender);

        vm.stopBroadcast();
    }
}
