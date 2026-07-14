// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import "../contracts/BitMarketAutopenControversyForecastOracle.sol";

contract BitMarketAutopenControversyForecastOracleTest is Test {
    BitMarketAutopenControversyForecastOracle oracle;

    function setUp() public {
        oracle = new BitMarketAutopenControversyForecastOracle();
    }

    function testForecastHighRiskDocument() public {
        oracle.logForecast("Pardon Letter", 85);
        // Expect: 🔥 Media Storm Likely
    }

    function testForecastLowRiskDocument() public {
        oracle.logForecast("Trade Memo", 40);
        // Expect: ✅ Stable Coverage
    }

    function testUpdateThreshold() public {
        oracle.updateThreshold(90);
        oracle.logForecast("Executive Order", 88);
        // Expect: ✅ Stable Coverage
    }
}
