// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../contracts/BitMarketTrustAnchorSanctifier.sol";
import "../contracts/BitMarketAnchorSanctumRouter.sol";

contract BitMarketAnchorSanctumRouterTest is Test {
    BitMarketTrustAnchorSanctifier sanctifier;
    BitMarketAnchorSanctumRouter router;

    function setUp() public {
        sanctifier = new BitMarketTrustAnchorSanctifier();
        router = new BitMarketAnchorSanctumRouter(address(sanctifier));
    }

    function testRouteValidEmail() public {
        router.routeEmail("vinvin@example.com");
        // Expect: Routed to reset flow
    }

    function testRouteSpoofEmail() public {
        router.routeEmail("vіnvіn@exаmple.com"); // Cyrillic spoof
        // Expect: Blocked by spoof firewall
    }
}
