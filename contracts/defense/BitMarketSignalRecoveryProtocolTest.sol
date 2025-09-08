// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../contracts/BitMarketSignalRecoveryProtocol.sol";

contract BitMarketSignalRecoveryProtocolTest is Test {
    BitMarketSignalRecoveryProtocol recovery;

    function setUp() public {
        recovery = new BitMarketSignalRecoveryProtocol();
    }

    function testHealSevereBreach() public {
        recovery.healSignal("Kyiv", "Missile Strike", 85);
        // Expect: Pulse Nullifier + APR Sync, APR Restored: +22
    }

    function testHealMildBreach() public {
        recovery.healSignal("Kharkiv", "Drone Swarm", 70);
        // Expect: Local Blessing, APR Restored: +15
    }

    function testUpdateThreshold() public {
        recovery.updateThreshold(90);
        recovery.healSignal("Odesa", "Rocket Barrage", 88);
        // Expect: Local Blessing
    }
}
