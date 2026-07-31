// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/health/SovereignEHRVault.sol";
import "../src/health/PatientConsentEngine.sol";

contract DeploySovereignEHR is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        SovereignEHRVault vault = new SovereignEHRVault();
        PatientConsentEngine consent = new PatientConsentEngine();

        console.log("SovereignEHRVault Deployed at:", address(vault));
        console.log("PatientConsentEngine Deployed at:", address(consent));

        vm.stopBroadcast();
    }
}
