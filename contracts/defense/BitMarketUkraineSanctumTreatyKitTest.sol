// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import "../contracts/BitMarketUkraineSanctumTreatyKit.sol";

contract BitMarketUkraineSanctumTreatyKitTest is Test {
    BitMarketUkraineSanctumTreatyKit treaty;

    function setUp() public {
        treaty = new BitMarketUkraineSanctumTreatyKit();
    }

    function testActivateDefenseClause() public {
        treaty.activateClause("Sovereign Defense Pact", "Kyiv", "Missile Strike", 92);
        // Expect: 🔥 Mandatory clause triggered
    }

    function testActivateShieldClause() public {
        treaty.activateClause("Civilian Shield Protocol", "Kharkiv", "Drone Swarm", 78);
        // Expect: ✅ Recommended clause triggered
    }

    function testUpdateThreshold() public {
        treaty.updateEnforcementThreshold("Global Mercy Broadcast Clause", 85);
        treaty.activateClause("Global Mercy Broadcast Clause", "Odesa", "Rocket Barrage", 88);
        // Expect: ✅ Broadcast clause triggered
    }
}
