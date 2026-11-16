// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {QuadraticFundingTreasury} from "../contracts/QuadraticFundingTreasury.sol";

contract DeployQuadraticFundingTreasury is Script {
    function run() external returns (QuadraticFundingTreasury treasury) {
        address opv = vm.envAddress("OPERATOR_PRIVILEGES_V2");
        vm.startBroadcast();
        treasury = new QuadraticFundingTreasury(opv);
        vm.stopBroadcast();
    }
}
