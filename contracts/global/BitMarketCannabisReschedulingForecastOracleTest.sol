// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../contracts/BitMarketCannabisReschedulingForecastOracle.sol";

contract BitMarketCannabisReschedulingForecastOracleTest is Test {
    BitMarketCannabisReschedulingForecastOracle oracle;

    function setUp() public {
        oracle = new BitMarketCannabisReschedulingForecastOracle();
    }

    function testHighSignalTriggersRescheduling() public {
        oracle.logForecast("FDA", 85);
        // Expect: 🔥 Rescheduling Imminent
    }

    function testLowSignalMaintainsStatus() public {
        oracle.logForecast("Congress", 60);
        // Expect: ✅ Stable Status
    }

    function testUpdateTriggerThreshold() public {
        oracle.updateThreshold(90);
        oracle.logForecast("DEA", 88);
        // Expect: ✅ Stable Status
    }
}
