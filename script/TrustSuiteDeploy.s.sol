// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/SpeedOfTrust.sol";
import "../src/CoalitionBuilder.sol";
import "../src/BrittleInstrument.sol";
import "../src/InspirationIntimidation.sol";

contract TrustSuiteDeploy is Script {
    function run() external {
        vm.startBroadcast();

        SpeedOfTrust trust = new SpeedOfTrust();
        CoalitionBuilder coalition = new CoalitionBuilder();
        BrittleInstrument instrument = new BrittleInstrument();
        InspirationIntimidation ii = new InspirationIntimidation();

        console.log("SpeedOfTrust deployed at:", address(trust));
        console.log("CoalitionBuilder deployed at:", address(coalition));
        console.log("BrittleInstrument deployed at:", address(instrument));
        console.log("InspirationIntimidation deployed at:", address(ii));

        vm.stopBroadcast();
    }
}
