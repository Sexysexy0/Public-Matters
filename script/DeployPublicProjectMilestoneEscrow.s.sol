// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {PublicProjectMilestoneEscrow} from "../contracts/PublicProjectMilestoneEscrow.sol";

contract DeployPublicProjectMilestoneEscrow is Script {
    function run() external returns (PublicProjectMilestoneEscrow escrow) {
        address opv = vm.envAddress("OPERATOR_PRIVILEGES_V2");
        vm.startBroadcast();
        escrow = new PublicProjectMilestoneEscrow(opv);
        vm.stopBroadcast();
    }
}
