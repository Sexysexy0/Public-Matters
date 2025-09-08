// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../contracts/BitMarketSignalRecoveryProtocol.sol";

contract BitMarketSignalRecoveryProtocolTest is Test {
    BitMarketSignalRecoveryProtocol recovery;

    function setUp() public {
        recovery = new BitMarketSignalRecoveryProtocol();
    }

    function testHealSevereSignal() public {
        recovery.healSignal("CN-Huawei", "Remote config injection", 85);
        // Expect: Signal Purge + APR Sync, APR Restored: +22
    }

    function testHealMildSignal() public {
        recovery.healSignal("RU-ProxyNode", "Credential probe", 70);
        // Expect: Firewall Blessing, APR Restored: +15
    }

    function testUpdateThreshold() public {
        recovery.updateThreshold(90);
        recovery.healSignal("Unknown MAC", "SMS injection", 88);
        // Expect: Firewall Blessing
    }
}
