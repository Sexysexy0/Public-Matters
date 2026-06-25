// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {PlatformWorkerRelief} from "./PlatformWorkerRelief.sol";
import {TalentSovereigntyLedger} from "./TalentSovereigntyLedger.sol";

contract DeployKnownEntity is Script {
    function run() external {
        // Hihilahin ang private key mula sa iyong .env file
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        // Magsisimula ang live broadcast sequence sa blockchain
        vm.startBroadcast(deployerPrivateKey);

        // 1. I-deploy ang Platform Worker Relief Pool
        PlatformWorkerRelief workerRelief = new PlatformWorkerRelief();
        
        // 2. I-deploy ang Talent Sovereignty Provenance Ledger
        TalentSovereigntyLedger talentLedger = new TalentSovereigntyLedger();

        vm.stopBroadcast();
    }
}
