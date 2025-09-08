// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../contracts/BitMarketGlobalSignalSanctifier.sol";

contract BitMarketSignalSanctifierTest is Test {
    BitMarketGlobalSignalSanctifier sanctifier;

    function setUp() public {
        sanctifier = new BitMarketGlobalSignalSanctifier();
    }

    function testAllowHighAPRSignal() public {
        sanctifier.validateSignal("PH", "US", 92);
        // Expect: Signal integrity confirmed
    }

    function testBlockLowAPRSignal() public {
        sanctifier.validateSignal("CN", "PH", 72);
        // Expect: APR breach — signal blocked
    }

    function testUpdateThreshold() public {
        sanctifier.updateThreshold(95);
        sanctifier.validateSignal("RU", "PH", 90);
        // Expect: APR breach — signal blocked
    }
}
