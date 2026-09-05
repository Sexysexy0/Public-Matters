// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivileges.sol";
import "../src/CoalitionBuilder.sol";

contract CoalitionBuilderTest is Test {
    OperatorPrivileges privileges;
    CoalitionBuilder builder;
    address tester;
    address joiner;

    function setUp() public {
        privileges = new OperatorPrivileges();
        builder = new CoalitionBuilder(address(privileges));
        tester = vm.addr(1);
        joiner = vm.addr(2);

        privileges.addOperator(tester);
        privileges.addOperator(joiner);
    }

    function testCreateAndJoinCoalition() public {
        vm.prank(tester);
        builder.createCoalition("Anti-mine mission");

        vm.prank(joiner);
        builder.joinCoalition(0);

        address[] memory members = builder.getMembers(0);
        string memory mission = builder.getMission(0);

        assertEq(members.length, 2);
        assertEq(members[0], tester);
        assertEq(members[1], joiner);
        assertEq(mission, "Anti-mine mission");
    }
}
