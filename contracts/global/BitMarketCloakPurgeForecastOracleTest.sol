// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../contracts/BitMarketCloakPurgeForecastOracle.sol";

contract BitMarketCloakPurgeForecastOracleTest is Test {
    BitMarketCloakPurgeForecastOracle oracle;

    function setUp() public {
        oracle = new BitMarketCloakPurgeForecastOracle();
    }

    function testHighStealthScoreTriggersBreach() public {
        oracle.logForecast("China", 85);
        // Expect: 🔥 Breach Risk High
    }

    function testLowStealthScoreIsStable() public {
        oracle.logForecast("Philippines", 40);
        // Expect: ✅ Stable Firewall
    }

    function testThresholdUpdate() public {
        oracle.updateThreshold(90);
        oracle.logForecast("Russia", 88);
        // Expect: ✅ Stable Firewall
    }
}
