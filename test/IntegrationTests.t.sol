// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/IntegrationRouter.sol";

contract IntegrationTests is Test {
    IntegrationRouter router;

    function setUp() public {
        // deploy dummy addresses for modules
        router = new IntegrationRouter(
            address(0x1),
            address(0x2),
            address(0x3),
            address(0x4),
            address(0x5),
            address(0x6),
            address(0x7)
        );
    }

    function testRouterLinks() public {
        assertEq(address(router.access()), address(0x1));
        assertEq(address(router.dueProcess()), address(0x2));
        assertEq(address(router.damay()), address(0x3));
        assertEq(address(router.apr()), address(0x4));
        assertEq(address(router.samma()), address(0x5));
        assertEq(address(router.civic()), address(0x6));
        assertEq(address(router.registry()), address(0x7));
    }

    function testAPRTriggersDamayViaRouter() public {
        // simulate APR update call
        router.updateAPRAndCheckDamay(-100, 0, 0, 0, address(this));
        // expect damay alert triggered (dummy check, real integration would assert event)
    }
}
