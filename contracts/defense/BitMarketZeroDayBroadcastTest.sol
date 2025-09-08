// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../contracts/BitMarketZeroDayBroadcast.sol";

contract BitMarketZeroDayBroadcastTest is Test {
    BitMarketZeroDayBroadcast broadcaster;

    function setUp() public {
        broadcaster = new BitMarketZeroDayBroadcast();
    }

    function testBroadcastCriticalExploit() public {
        broadcaster.broadcastExploit("CVE-2025-38352", "Kernel Race Condition", "Android 13–16", 92);
        // Expect: ✅ Broadcast Triggered
    }

    function testBroadcastModerateExploit() public {
        broadcaster.broadcastExploit("CVE-2025-21483", "Qualcomm Memory Leak", "Snapdragon 700 Series", 68);
        // Expect: ⚠️ Logged, no broadcast
    }

    function testUpdateThreshold() public {
        broadcaster.updateBroadcastThreshold(85);
        broadcaster.broadcastExploit("CVE-2025-48543", "Runtime Escape", "All Qualcomm Devices", 88);
        // Expect: ✅ Broadcast Triggered
    }
}
