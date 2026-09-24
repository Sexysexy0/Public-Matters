// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/PeaceContinuity.sol";

contract PeaceContinuityTest is Test {
    PeaceContinuity peace;
    address admin = address(0xABCD);
    address agent = address(0x1234);

    function setUp() public {
        vm.prank(admin);
        peace = new PeaceContinuity();
    }

    function testAuthorizeAgent() public {
        vm.prank(admin);
        peace.authorizeAgent(agent);
        assertTrue(peace.reliefAgents(agent));
    }

    function testDistributeAid() public {
        vm.prank(admin);
        peace.authorizeAgent(agent);

        vm.expectEmit(true, true, false, true);
        emit PeaceContinuity.AidDistributed(agent, 100);

        peace.distributeAid(agent, 100);
    }
}
