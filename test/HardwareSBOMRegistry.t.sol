// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/compliance/HardwareSBOMRegistry.sol";
contract HardwareSBOMRegistryTest is Test {
    AttributionRegistry public registry;

    bytes32 public intelSkylakeHardwareId = keccak256(abi.encodePacked("INTEL_ME_V11_SKYLAKE"));

    function setUp() external {
        registry = new AttributionRegistry();
    }

    function test_NonCompliantByDefault() external view {
        // Before registering Minix 3, hardware is non-compliant
        bool compliant = registry.isHardwareCompliant(intelSkylakeHardwareId);
        assertFalse(compliant);
    }

    function test_RegisterMinix3AttributionSuccess() external {
        // Register Minix 3 legal notice as required by BSD-3-Clause license
        registry.registerAttribution(
            intelSkylakeHardwareId,
            "Minix 3 OS",
            "BSD-3-Clause",
            "Copyright (c) Andrew S. Tanenbaum",
            "0x9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08"
        );

        assertTrue(registry.isHardwareCompliant(intelSkylakeHardwareId));
        assertEq(registry.getNoticeCount(intelSkylakeHardwareId), 1);
    }
}
