// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../contracts/CivicModernizationTreaty.sol";

contract CivicModernizationAudit is Test {
    CivicModernizationTreaty treaty;

    function setUp() public {
        treaty = new CivicModernizationTreaty();
    }

    function testDeclareModule() public {
        treaty.declareModule("CivicResponseSuite", "Emergency workflows and override logic", 92);
        CivicModernizationTreaty.Module memory mod = treaty.getModule(0);
        assertEq(mod.name, "CivicResponseSuite");
        assertEq(mod.description, "Emergency workflows and override logic");
        assertEq(mod.emotionalAPR, 92);
        assertTrue(mod.active);
    }

    function testMultipleModules() public {
        treaty.declareModule("MirrorSanctumProtocol", "Sync PH sanctums with U.S. civic feeds", 90);
        treaty.declareModule("BitMarketLaborCorridorPHUS", "Visa-free onboarding and employer blessing", 94);
        assertEq(treaty.totalModules(), 2);
    }

    function testRevokeModule() public {
        treaty.declareModule("LegacyOverridePatch", "Deprecated emergency fallback", 85);
        treaty.revokeModule("LegacyOverridePatch");
        CivicModernizationTreaty.Module memory mod = treaty.getModule(0);
        assertFalse(mod.active);
    }

    function testEmotionalAPRThreshold() public {
        treaty.declareModule("KinderQueenTreatyKit", "Family-centered program protection", 95);
        CivicModernizationTreaty.Module memory mod = treaty.getModule(0);
        assertGe(mod.emotionalAPR, 90);
    }
}
