// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../contracts/BitMarketMultipolarAllianceRouter.sol";

contract BitMarketAllianceRouterTest is Test {
    BitMarketMultipolarAllianceRouter router;

    function setUp() public {
        router = new BitMarketMultipolarAllianceRouter();
    }

    function testRouteTreaty() public {
        router.routeTreaty("MultipolarTreatyDeck.md", "PH-Sanctum");
        // Expect: ✅ Sync Confirmed
    }

    function testBroadcastAlliance() public {
        router.broadcastAlliance("ASEAN-Scrollchain");
        // Expect: ✅ Alliance Broadcasted
    }
}
