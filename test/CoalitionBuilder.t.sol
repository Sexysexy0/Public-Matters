// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/CoalitionBuilder.sol";

contract CoalitionBuilderTest is Test {
    CoalitionBuilder builder;

    function setUp() public {
        builder = new CoalitionBuilder();
    }

    function testCreateAndJoinCoalition() public {
        builder.createCoalition("Anti-mine mission");
        builder.joinCoalition(0);
        assertEq(builder.coalitions(0).members.length, 1);
    }
}
