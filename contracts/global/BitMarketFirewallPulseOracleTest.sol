// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../contracts/BitMarketSanctumFirewallPulseOracle.sol";

contract BitMarketFirewallPulseOracleTest is Test {
    BitMarketSanctumFirewallPulseOracle oracle;

    function setUp() public {
        oracle = new BitMarketSanctumFirewallPulseOracle();
    }

    function testDetectFatigue() public {
        oracle.logPulse("PH Telecom Core", 72);
        // Expect: ⚠️ Firewall Fatigue Detected
    }

    function testStablePulse() public {
        oracle.logPulse("PH GovNet", 91);
        // Expect: ✅ Stable
    }

    function testUpdateThreshold() public {
        oracle.updateThreshold(95);
        oracle.logPulse("PH Mobile Layer", 90);
        // Expect: ⚠️ Firewall Fatigue Detected
    }
}
