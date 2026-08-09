// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/CyberOperationalResilience.sol";

contract CyberOperationalResilienceTest is Test {
    CyberOperationalResilience public cyber;

    address public owner = address(this);
    address public commander1 = makeAddr("commander1");

    function setUp() public {
        cyber = new CyberOperationalResilience();
    }

    function test_RegisterAndUpdateMerit() public {
        cyber.registerCyberUnit(commander1, "Alpha Unit", 75);
        (address unitCommander, string memory codename, uint8 meritScore,, bool isActive) =
            cyber.cyberForces(commander1);

        assertEq(unitCommander, commander1);
        assertEq(codename, "Alpha Unit");
        assertEq(meritScore, 75);
        assertTrue(isActive);

        cyber.updateMeritScore(commander1, 92);
        (,, meritScore,,) = cyber.cyberForces(commander1);
        assertEq(meritScore, 92);
    }

    function test_MissionUpdateAndAlert() public {
        cyber.setMissionPriority("Defend the Sovereign Grid");
        assertEq(cyber.currentMissionPriority(), "Defend the Sovereign Grid");

        cyber.setAlert(true);
        assertTrue(cyber.systemAlert());

        cyber.setAlert(false);
        assertFalse(cyber.systemAlert());
    }
}
