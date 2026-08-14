// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {TaxPaymentProcessor} from "../src/TaxPaymentProcessor.sol";

contract DeployTaxPaymentProcessorV2 is Script {
    function run() external {
        address trustIntegrator = 0xEaB33E69B7599830Dc78D4e446CC02fC9D0aC0B6;
        uint256 vatRate = 800; // 8%
        address taxVault = 0xBEb87cB2f38def956ff95058FD0b1EcC98D30A76;

        vm.startBroadcast();
        TaxPaymentProcessor processor = new TaxPaymentProcessor(trustIntegrator, vatRate, taxVault);
        console.log("TaxPaymentProcessorV2 (8% VAT) deployed to:", address(processor));
        vm.stopBroadcast();
    }
}
