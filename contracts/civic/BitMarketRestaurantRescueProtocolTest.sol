// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../contracts/BitMarketRestaurantRescueProtocol.sol";

contract BitMarketRestaurantRescueProtocolTest is Test {
    BitMarketRestaurantRescueProtocol rescue;

    function setUp() public {
        rescue = new BitMarketRestaurantRescueProtocol();
    }

    function testTriggerHighDistressRescue() public {
        rescue.triggerRescue("Bunini's Grill", 82);
        // Expect: Subsidy Grant + Wage Rebalance
    }

    function testTriggerLowDistressMonitorOnly() public {
        rescue.triggerRescue("Tapsi ni Kuya", 68);
        // Expect: Monitor Only
    }

    function testUpdateThreshold() public {
        rescue.updateThreshold(85);
        rescue.triggerRescue("Sisig Republic", 83);
        // Expect: Monitor Only
    }
}
