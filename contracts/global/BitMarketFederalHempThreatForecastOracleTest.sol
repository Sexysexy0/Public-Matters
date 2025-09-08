// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../contracts/BitMarketFederalHempThreatForecastOracle.sol";

contract BitMarketFederalHempThreatForecastOracleTest is Test {
    BitMarketFederalHempThreatForecastOracle oracle;

    function setUp() public {
        oracle = new BitMarketFederalHempThreatForecastOracle();
    }

    function testHighRiskTriggersCollapse() public {
        oracle.logForecast("Total THC Redefinition Act", 85);
        // Expect: 🔥 Market Collapse Likely
    }

    function testLowRiskMaintainsStability() public {
        oracle.logForecast("Veteran Access Act", 45);
        // Expect: ✅ Stable Industry
    }

    function testUpdateCollapseThreshold() public {
        oracle.updateThreshold(90);
        oracle.logForecast("Hemp Ban Proposal", 88);
        // Expect: ✅ Stable Industry
    }
}
