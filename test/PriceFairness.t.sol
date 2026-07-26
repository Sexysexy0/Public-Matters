// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/PriceFairness.sol";

contract PriceFairnessTest is Test {
    PriceFairness fairness;
    address lead = address(this);

    event PriceLogged(
        uint256 id,
        string vendor,
        string competitor,
        uint256 oldPrice,
        uint256 newPrice,
        bool coerced
    );

    function setUp() public {
        fairness = new PriceFairness(lead);
    }

    function testVoluntaryPriceChange() public {
        vm.expectEmit(true, true, true, true);
        emit PriceLogged(1, "VendorA", "CompetitorX", 100, 95, false);

        fairness.logPriceEvent("VendorA", "CompetitorX", 100, 95, false);

        PriceFairness.PriceEvent memory ev = fairness.getEvent(1);
        assertEq(ev.vendor, "VendorA");
        assertEq(ev.competitor, "CompetitorX");
        assertEq(ev.oldPrice, 100);
        assertEq(ev.newPrice, 95);
        assertFalse(ev.coerced);
    }

    function testCoercedPriceIncrease() public {
        vm.expectEmit(true, true, true, true);
        emit PriceLogged(1, "VendorB", "CompetitorY", 80, 100, true);

        fairness.logPriceEvent("VendorB", "CompetitorY", 80, 100, true);

        PriceFairness.PriceEvent memory ev = fairness.getEvent(1);
        assertEq(ev.vendor, "VendorB");
        assertEq(ev.competitor, "CompetitorY");
        assertEq(ev.oldPrice, 80);
        assertEq(ev.newPrice, 100);
        assertTrue(ev.coerced);
    }
}
