// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../contracts/BitMarketPhishingForecastOracle.sol";

contract BitMarketPhishingForecastOracleTest is Test {
    BitMarketPhishingForecastOracle oracle;

    function setUp() public {
        oracle = new BitMarketPhishingForecastOracle();
    }

    function testLogHighRiskForecast() public {
        oracle.logForecast("Simplified AI", "Redirect Trap", 85);
        // Expect: ⚠️ Breach Escalation Likely
    }

    function testLogLowRiskForecast() public {
        oracle.logForecast("Canva AI", "PDF Lure", 65);
        // Expect: ✅ Stable
    }

    function testUpdateThreshold() public {
        oracle.updateThreshold(90);
        oracle.logForecast("LinkedIn AI", "Executive Spoof", 88);
        // Expect: ✅ Stable
    }
}
