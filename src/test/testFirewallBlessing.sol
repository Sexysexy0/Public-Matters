// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import {FirewallBlessing} from "../../contracts/defense/FirewallBlessing.sol";

contract FirewallBlessingTest is Test {
    FirewallBlessing firewall;

    function setUp() public {
        firewall = new FirewallBlessing();
    }

    function testBanIP() public {
        firewall.banIP("192.168.1.1", "Rogue sanctum detected");
        assertTrue(firewall.isBanned("192.168.1.1"));
    }

    function testUnbanIP() public {
        firewall.banIP("10.0.0.1", "Suspicious activity");
        firewall.unbanIP("10.0.0.1");
        assertFalse(firewall.isBanned("10.0.0.1"));
    }

    function testMultipleBans() public {
        firewall.banIP("8.8.8.8", "Russia");
        firewall.banIP("1.1.1.1", "China");
        assertTrue(firewall.isBanned("8.8.8.8"));
        assertTrue(firewall.isBanned("1.1.1.1"));
    }
}
