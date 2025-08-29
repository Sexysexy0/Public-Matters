// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {SovereignAllowanceProtocol} from "contracts/restoration/allowance/SovereignAllowanceProtocol.sol";

contract DeployAllowance is Script {
    function run() external {
        vm.startBroadcast();

        SovereignAllowanceProtocol allowance = new SovereignAllowanceProtocol();

        vm.stopBroadcast();
    }
}
