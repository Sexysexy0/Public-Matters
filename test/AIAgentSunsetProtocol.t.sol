// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivilegesV2.sol";
import "../src/AIAgentSunsetProtocol.sol";

contract AIAgentSunsetProtocolTest is Test {
    OperatorPrivilegesV2 privileges;
    AIAgentSunsetProtocol sunset;

    address owner = address(0xA11CE);
    address op1 = address(0xB0B);
    bytes32 constant AGENT_1 = keccak256("agent-1");

    function setUp() public {
        vm.startPrank(owner);
        privileges = new OperatorPrivilegesV2();
        privileges.addOperator(op1);
        vm.stopPrank();
        sunset = new AIAgentSunsetProtocol(address(privileges));
    }

    function test_ScheduleSunset() public {
        vm.prank(op1);
        sunset.scheduleSunset(AGENT_1, 1 days, "end of life");
        assertTrue(sunset.isPending(AGENT_1));
    }

    function test_InvalidGracePeriod() public {
        vm.prank(op1);
        vm.expectRevert("Invalid grace period");
        sunset.scheduleSunset(AGENT_1, 1 minutes, "too short");
    }

    function test_CancelSunset() public {
        vm.startPrank(op1);
        sunset.scheduleSunset(AGENT_1, 1 days, "eol");
        sunset.cancelSunset(AGENT_1);
        vm.stopPrank();
        assertFalse(sunset.isPending(AGENT_1));
    }

    function test_CompleteSunsetAfterGrace() public {
        vm.prank(op1);
        sunset.scheduleSunset(AGENT_1, 1 days, "eol");

        vm.prank(op1);
        vm.expectRevert("Grace period not passed");
        sunset.completeSunset(AGENT_1);

        vm.warp(block.timestamp + 1 days + 1);

        vm.prank(op1);
        sunset.completeSunset(AGENT_1);

        AIAgentSunsetProtocol.Sunset memory s = sunset.getSunset(AGENT_1);
        assertEq(uint256(s.status), uint256(AIAgentSunsetProtocol.SunsetStatus.COMPLETED));
    }

    function test_CannotScheduleTwice() public {
        vm.startPrank(op1);
        sunset.scheduleSunset(AGENT_1, 1 days, "eol");
        vm.expectRevert("Already scheduled");
        sunset.scheduleSunset(AGENT_1, 1 days, "eol");
        vm.stopPrank();
    }
}
