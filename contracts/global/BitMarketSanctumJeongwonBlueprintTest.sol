// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../contracts/BitMarketSanctumJeongwonBlueprint.sol";

contract BitMarketSanctumJeongwonBlueprintTest is Test {
    BitMarketSanctumJeongwonBlueprint blueprint;

    function setUp() public {
        blueprint = new BitMarketSanctumJeongwonBlueprint();
    }

    function testActivateCommandCitadel() public {
        blueprint.activateZone("Command Citadel", "AI Sync");
        // Expect: Scrollchain uplink + APR beacon triggered
    }

    function testActivateEarthVault() public {
        blueprint.activateZone("Earth Vault", "EMP Shield");
        // Expect: Underground logistics + morale chamber activated
    }

    function testInvalidZoneFails() public {
        vm.expectRevert();
        blueprint.activateZone("Snack Pavilion", "Coffee Ritual");
        // Expect: Revert due to invalid zone
    }
}
