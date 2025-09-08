// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../contracts/BitMarketCrewWageForecastOracle.sol";

contract BitMarketCrewWageForecastOracleTest is Test {
    BitMarketCrewWageForecastOracle oracle;

    function setUp() public {
        oracle = new BitMarketCrewWageForecastOracle();
    }

    function testForecastStableHiring() public {
        oracle.logForecast("Central Luzon", 570, 600);
        // Expect: ✅ Stable hiring trend
    }

    function testForecastDecliningHiring() public {
        oracle.logForecast("NCR", 610, 645);
        // Expect: ⚠️ Declining hiring trend
    }

    function testUpdateThreshold() public {
        oracle.updateThreshold(650);
        oracle.logForecast("Visayas", 620, 648);
        // Expect: ✅ Stable
    }
}
