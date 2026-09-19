// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivileges.sol";
import "../src/AIAgentReputation.sol";

contract AIAgentReputationTest is Test {
    OperatorPrivileges privileges;
    AIAgentReputation reputation;

    address owner = address(0xA11CE);
    address op1 = address(0xB0B);
    bytes32 constant AGENT_1 = keccak256("agent-1");
    bytes32 constant REASON = keccak256("good-behavior");

    function setUp() public {
        vm.startPrank(owner);
        privileges = new OperatorPrivileges();
        privileges.addOperator(op1);
        vm.stopPrank();
        reputation = new AIAgentReputation(address(privileges));
    }

    function test_Initialize() public {
        vm.prank(op1);
        reputation.initialize(AGENT_1);
        assertEq(reputation.getScore(AGENT_1), 500);
    }

    function test_CannotInitTwice() public {
        vm.startPrank(op1);
        reputation.initialize(AGENT_1);
        vm.expectRevert("Already initialized");
        reputation.initialize(AGENT_1);
        vm.stopPrank();
    }

    function test_Reward() public {
        vm.startPrank(op1);
        reputation.initialize(AGENT_1);
        reputation.reward(AGENT_1, 100, REASON);
        vm.stopPrank();
        assertEq(reputation.getScore(AGENT_1), 600);
    }

    function test_RewardCapsAtMax() public {
        vm.startPrank(op1);
        reputation.initialize(AGENT_1);
        reputation.reward(AGENT_1, 10000, REASON);
        vm.stopPrank();
        assertEq(reputation.getScore(AGENT_1), 1000);
    }

    function test_Slash() public {
        vm.startPrank(op1);
        reputation.initialize(AGENT_1);
        reputation.slash(AGENT_1, 100, REASON);
        vm.stopPrank();
        assertEq(reputation.getScore(AGENT_1), 400);
    }

    function test_SlashBelowZero() public {
        vm.startPrank(op1);
        reputation.initialize(AGENT_1);
        reputation.slash(AGENT_1, 9999, REASON);
        vm.stopPrank();
        assertEq(reputation.getScore(AGENT_1), 0);
    }

    function test_HistoryTracked() public {
        vm.startPrank(op1);
        reputation.initialize(AGENT_1);
        reputation.reward(AGENT_1, 50, REASON);
        reputation.slash(AGENT_1, 20, REASON);
        vm.stopPrank();
        assertEq(reputation.getHistoryLength(AGENT_1), 2);
    }

    function test_OnlyOperatorReward() public {
        vm.prank(op1);
        reputation.initialize(AGENT_1);

        vm.prank(address(0xBAD));
        vm.expectRevert("Not authorized operator");
        reputation.reward(AGENT_1, 100, REASON);
    }

    function test_TotalTracked() public {
        vm.startPrank(op1);
        reputation.initialize(AGENT_1);
        reputation.initialize(keccak256("agent-2"));
        vm.stopPrank();
        assertEq(reputation.totalTracked(), 2);
    }
}
