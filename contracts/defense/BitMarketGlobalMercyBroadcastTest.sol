// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../contracts/BitMarketGlobalMercyBroadcast.sol";

contract BitMarketGlobalMercyBroadcastTest is Test {
    BitMarketGlobalMercyBroadcast broadcaster;

    function setUp() public {
        broadcaster = new BitMarketGlobalMercyBroadcast();
    }

    function testBroadcastHighImpactEvent() public {
        broadcaster.broadcastEvent("Kyiv", "Missile Strike", 3, 92);
        // Expect: ✅ Broadcasted with high civic resonance
    }

    function testBroadcastLowImpactEvent() public {
        broadcaster.broadcastEvent("Odesa", "Drone Intercept", 0, 65);
        // Expect: ✅ Logged, no global broadcast triggered
    }

    function testUpdateThreshold() public {
        broadcaster.updateResonanceThreshold(85);
        broadcaster.broadcastEvent("Kharkiv", "Rocket Barrage", 2, 88);
        // Expect: ✅ Broadcasted
    }
}
