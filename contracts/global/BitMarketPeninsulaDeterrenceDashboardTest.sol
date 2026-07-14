// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import "../contracts/BitMarketPeninsulaDeterrenceDashboard.sol";

contract BitMarketPeninsulaDeterrenceDashboardTest is Test {
    BitMarketPeninsulaDeterrenceDashboard dashboard;

    function setUp() public {
        dashboard = new BitMarketPeninsulaDeterrenceDashboard();
    }

    function testLogJejuDeployment() public {
        dashboard.logDeployment("Jeju Island", 15000, "Missile Intercept");
        // Expect: ✅ Stable deterrence status
    }

    function testLogDMZCriticalAlert() public {
        dashboard.logDeployment("DMZ Buffer", 20000, "Invasion Deterrent");
        // Expect: 🔥 Critical alert triggered
    }

    function testUpdateReadinessThreshold() public {
        dashboard.updateReadinessThreshold(25000);
        dashboard.logDeployment("Pyeongtaek", 30000, "Rapid Response");
        // Expect: ✅ High readiness confirmed
    }
}
