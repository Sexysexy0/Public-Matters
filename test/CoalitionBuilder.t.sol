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

        address[] memory members = builder.getMembers(0);
        string memory mission = builder.getMission(0);

        assertEq(members.length, 1);
        assertEq(members[0], address(this));
        assertEq(mission, "Anti-mine mission");
    }
}
