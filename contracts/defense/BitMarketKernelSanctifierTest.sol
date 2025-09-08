// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../contracts/BitMarketKernelSanctifier.sol";

contract BitMarketKernelSanctifierTest is Test {
    BitMarketKernelSanctifier sanctifier;

    function setUp() public {
        sanctifier = new BitMarketKernelSanctifier();
    }

    function testSanctifyHighRiskKernel() public {
        sanctifier.sanctifyKernel("Pixel 6", "Race Condition", 85);
        // Expect: Race Patch + Privilege Nullifier
    }

    function testSanctifyLowRiskKernel() public {
        sanctifier.sanctifyKernel("Samsung A10", "Memory Leak", 65);
        // Expect: Monitor Only
    }

    function testUpdateThreshold() public {
        sanctifier.updateThreshold(90);
        sanctifier.sanctifyKernel("Huawei Y6", "Timer Breach", 88);
        // Expect: Monitor Only
    }
}
