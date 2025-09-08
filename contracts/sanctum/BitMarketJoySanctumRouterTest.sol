// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../contracts/BitMarketJoySanctumRouter.sol";

contract BitMarketJoySanctumRouterTest is Test {
    BitMarketJoySanctumRouter router;

    function setUp() public {
        router = new BitMarketJoySanctumRouter();
    }

    function testRoutePulse() public {
        string memory result = router.routeJoySignal("/pulse");
        assertEq(result, "Routing to BitMarketJoyTelemetry.sol");
    }

    function testRouteBroadcast() public {
        string memory result = router.routeJoySignal("/broadcast");
        assertEq(result, "Routing to JoyLedger.md and JoySanctumDashboard.md");
    }

    function testUnknownRoute() public {
        string memory result = router.routeJoySignal("/unknown");
        assertEq(result, "Unknown endpoint — signal sanctification required");
    }
}
