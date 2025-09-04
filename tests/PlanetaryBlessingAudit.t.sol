// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../contracts/PlanetaryBlessingRegistry.sol";

contract PlanetaryBlessingAudit is Test {
    PlanetaryBlessingRegistry registry;

    function setUp() public {
        registry = new PlanetaryBlessingRegistry();
    }

    function testCommitBlessing() public {
        registry.commitBlessing("VendorX", "VendorBlessing", 91, "Treaty-VBX-2025");
        (
            string memory entity,
            string memory tag,
            uint256 apr,
            string memory treaty,
            uint256 timestamp,
            bool active
        ) = registry.getBlessing(0);

        assertEq(entity, "VendorX");
        assertEq(tag, "VendorBlessing");
        assertEq(apr, 91);
        assertEq(treaty, "Treaty-VBX-2025");
        assertTrue(active);
        assertGt(timestamp, 0);
    }

    function testBlessingRevocation() public {
        registry.commitBlessing("EmployerA", "EmployerBlessing", 94, "Treaty-EMP-2025");
        registry.revokeBlessing("EmployerA");
        assertFalse(registry.isBlessed("EmployerA"));
    }

    function testMultipleBlessings() public {
        registry.commitBlessing("StewardB", "LaborCorridorBlessing", 95, "Treaty-LABORPHUS-2025");
        registry.commitBlessing("CivicModuleZ", "CivicModernization", 92, "Treaty-CIVMOD-2025");
        assertEq(registry.totalBlessings(), 2);
    }

    function testEmotionalAPRThreshold() public {
        registry.commitBlessing("KinderQueen", "KinderQueenTreaty", 96, "Treaty-KQ-2025");
        (, , uint256 apr, , , ) = registry.getBlessing(0);
        assertGe(apr, 90);
    }
}
