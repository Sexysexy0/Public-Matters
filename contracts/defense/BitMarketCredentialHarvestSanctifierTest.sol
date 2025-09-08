// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../contracts/BitMarketCredentialHarvestSanctifier.sol";

contract BitMarketCredentialHarvestSanctifierTest is Test {
    BitMarketCredentialHarvestSanctifier sanctifier;

    function setUp() public {
        sanctifier = new BitMarketCredentialHarvestSanctifier();
    }

    function testBlockHighRiskSpoof() public {
        sanctifier.blockSpoofTrap("app.simplified.com", "Redirect Trap", 85);
        // Expect: Credential Trap Nullified
    }

    function testMonitorLowRiskSpoof() public {
        sanctifier.blockSpoofTrap("ai-marketing.io", "Login Spoof", 65);
        // Expect: Monitor Only
    }

    function testUpdateThreshold() public {
        sanctifier.updateThreshold(90);
        sanctifier.blockSpoofTrap("pharma-redirect.ai", "PDF Lure", 88);
        // Expect: Monitor Only
    }
}
