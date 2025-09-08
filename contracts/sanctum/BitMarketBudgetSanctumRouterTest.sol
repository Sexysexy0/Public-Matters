// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../contracts/BitMarketBudgetSanctumRouter.sol";

contract BitMarketBudgetSanctumRouterTest is Test {
    BitMarketBudgetSanctumRouter router;

    function setUp() public {
        router = new BitMarketBudgetSanctumRouter();
    }

    function testRouteHousingSignal() public {
        string memory result = router.routeSignal("housing");
        assertEq(result, "ShelterSweepDeck.md");
    }

    function testRouteYouthSignal() public {
        string memory result = router.routeSignal("youth");
        assertEq(result, "KinderQueenTreatyKit.md");
    }

    function testUnknownSignalTriggersProphecyLoop() public {
        string memory result = router.routeSignal("unknown");
        assertEq(result, "Unknown — prophecy loop check required");
    }
}
