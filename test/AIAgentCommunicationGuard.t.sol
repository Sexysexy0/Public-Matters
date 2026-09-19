// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivileges.sol";
import "../src/AIAgentCommunicationGuard.sol";

contract AIAgentCommunicationGuardTest is Test {
    OperatorPrivileges privileges;
    AIAgentCommunicationGuard guard;

    address owner = address(0xA11CE);
    address op1 = address(0xB0B);

    bytes32 constant AGENT_1 = keccak256("agent-1");
    bytes32 constant AGENT_2 = keccak256("agent-2");
    bytes32 constant CHANNEL_1 = keccak256("channel-1");
    bytes32 constant MSG_HASH = keccak256("hello-world");

    function setUp() public {
        vm.startPrank(owner);
        privileges = new OperatorPrivileges();
        privileges.addOperator(op1);
        vm.stopPrank();

        guard = new AIAgentCommunicationGuard(address(privileges));
    }

    function test_CreateChannel() public {
        vm.prank(op1);
        guard.createChannel(CHANNEL_1, "general");

        assertEq(guard.totalChannels(), 1);
    }

    function test_CannotCreateDuplicateChannel() public {
        vm.startPrank(op1);
        guard.createChannel(CHANNEL_1, "general");
        vm.expectRevert("Channel exists");
        guard.createChannel(CHANNEL_1, "general");
        vm.stopPrank();
    }

    function test_AuthorizeAgent() public {
        vm.prank(op1);
        guard.setAgentAuthorized(AGENT_1, true);

        assertTrue(guard.agentAuthorized(AGENT_1));
    }

    function test_LogAuthorizedMessage() public {
        vm.startPrank(op1);
        guard.createChannel(CHANNEL_1, "general");
        guard.setAgentAuthorized(AGENT_1, true);
        guard.setAgentAuthorized(AGENT_2, true);
        guard.logMessage(AGENT_1, AGENT_2, MSG_HASH, CHANNEL_1);
        vm.stopPrank();

        assertEq(guard.getMessageCount(), 1);
        assertEq(guard.totalUnauthorized(), 0);
    }

    function test_LogUnauthorizedMessage() public {
        vm.startPrank(op1);
        guard.createChannel(CHANNEL_1, "general");
        guard.setAgentAuthorized(AGENT_1, true);
        guard.logMessage(AGENT_1, AGENT_2, MSG_HASH, CHANNEL_1);
        vm.stopPrank();

        assertEq(guard.getMessageCount(), 1);
        assertEq(guard.totalUnauthorized(), 1);
    }

    function test_UnauthorizedChannelBlocks() public {
        vm.startPrank(op1);
        guard.createChannel(CHANNEL_1, "general");
        guard.setAgentAuthorized(AGENT_1, true);
        guard.setAgentAuthorized(AGENT_2, true);
        guard.setChannelAuthorized(CHANNEL_1, false);
        guard.logMessage(AGENT_1, AGENT_2, MSG_HASH, CHANNEL_1);
        vm.stopPrank();

        assertEq(guard.totalUnauthorized(), 1);
    }

    function test_GetMessageByAgent() public {
        vm.startPrank(op1);
        guard.createChannel(CHANNEL_1, "general");
        guard.setAgentAuthorized(AGENT_1, true);
        guard.setAgentAuthorized(AGENT_2, true);
        guard.logMessage(AGENT_1, AGENT_2, MSG_HASH, CHANNEL_1);
        vm.stopPrank();

        uint256[] memory msgs = guard.getMessagesByAgent(AGENT_1);
        assertEq(msgs.length, 1);
    }

    function test_OnlyOperatorCanCreateChannel() public {
        vm.prank(address(0xBAD));
        vm.expectRevert("Not authorized operator");
        guard.createChannel(CHANNEL_1, "general");
    }
}
