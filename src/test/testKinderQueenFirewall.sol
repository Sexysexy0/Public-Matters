// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import {KinderQueenFirewall} from "../../contracts/firewall/KinderQueenFirewall.sol";

contract KinderQueenFirewallTest is Test {
    KinderQueenFirewall firewall;

    function setUp() public {
        firewall = new KinderQueenFirewall();
    }

    function testFilterPacketAllowed() public {
        bool allowed = firewall.filterPacket("SocialFeed", 80);
        assertTrue(allowed);
    }

    function testFilterPacketBlocked() public {
        bool allowed = firewall.filterPacket("GeoSignal", 60);
        assertFalse(allowed);
    }

    function testUpdateThreshold() public {
        firewall.updateThreshold(85);
        bool allowed = firewall.filterPacket("TarotFeed", 80);
        assertFalse(allowed);
    }
}
