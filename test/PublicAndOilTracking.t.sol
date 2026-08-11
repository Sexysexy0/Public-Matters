// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

import "forge-std/Test.sol";
import "../src/OilPriceBufferTracker.sol";
import "../src/PublicNewsTransparency.sol";

contract PublicAndOilTrackingTest is Test {
    OilPriceBufferTracker oilTracker;
    PublicNewsTransparency newsTracker;

    function setUp() public {
        oilTracker = new OilPriceBufferTracker();
        newsTracker = new PublicNewsTransparency();
    }

    function test_OilPriceRollbackLogging() public {
        // Halimbawa: -470 (Gasolina -P4.70) at -430 (Diesel -P4.30) sa sentimo scale
        oilTracker.logPriceAdjustment(-470, -430, "Malaking oil price rollback ngayong linggo");

        (, int256 gasChange, int256 dieselChange, string memory reason) = oilTracker.getLatestPriceLog();

        assertEq(gasChange, -470);
        assertEq(dieselChange, -430);
        assertEq(reason, "Malaking oil price rollback ngayong linggo");
    }

    function test_PublicNewsBulletinPublish() public {
        newsTracker.publishBulletin("Energy", "Bawas presyo sa petrolyo epektibo ngayong Martes", "ipfs://bafybeic...");

        assertEq(newsTracker.getTotalBulletins(), 1);

        (, string memory category, string memory headline,, bool verified) = newsTracker.bulletins(0);
        assertEq(category, "Energy");
        assertEq(headline, "Bawas presyo sa petrolyo epektibo ngayong Martes");
        assertTrue(verified);
    }
}
