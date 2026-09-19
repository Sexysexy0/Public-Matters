// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivilegesV2.sol";
import "../src/AIDecisionChallenge.sol";

contract AIDecisionChallengeTest is Test {
    OperatorPrivilegesV2 privileges;
    AIDecisionChallenge challenge;

    address owner = address(0xA11CE);
    address op1 = address(0xB0B);
    address challenger = address(0xC0C);

    bytes32 constant DECISION_ID = keccak256("decision-1");

    function setUp() public {
        vm.startPrank(owner);
        privileges = new OperatorPrivilegesV2();
        privileges.addOperator(op1);
        vm.stopPrank();
        challenge = new AIDecisionChallenge(address(privileges));
        vm.deal(challenger, 1 ether);
    }

    function test_FileChallenge() public {
        vm.prank(challenger);
        uint256 id = challenge.fileChallenge{value: 0.001 ether}(DECISION_ID, "wrong output");
        assertEq(id, 1);
        assertEq(challenge.totalChallenges(), 1);
    }

    function test_StakeRequired() public {
        vm.prank(challenger);
        vm.expectRevert("Stake too low");
        challenge.fileChallenge{value: 0.0001 ether}(DECISION_ID, "test");
    }

    function test_UpholdChallenge() public {
        vm.prank(challenger);
        challenge.fileChallenge{value: 0.001 ether}(DECISION_ID, "wrong");

        vm.prank(op1);
        challenge.upholdChallenge(1, "verified incorrect");

        AIDecisionChallenge.Challenge memory c = challenge.getChallenge(1);
        assertEq(uint256(c.status), uint256(AIDecisionChallenge.ChallengeStatus.UPHELD));
    }

    function test_RejectChallenge() public {
        vm.prank(challenger);
        challenge.fileChallenge{value: 0.001 ether}(DECISION_ID, "wrong");

        vm.prank(op1);
        challenge.rejectChallenge(1, "decision verified correct");

        AIDecisionChallenge.Challenge memory c = challenge.getChallenge(1);
        assertEq(uint256(c.status), uint256(AIDecisionChallenge.ChallengeStatus.REJECTED));
    }

    function test_OnlyOperatorCanResolve() public {
        vm.prank(challenger);
        challenge.fileChallenge{value: 0.001 ether}(DECISION_ID, "wrong");

        vm.prank(challenger);
        vm.expectRevert("Not authorized operator");
        challenge.upholdChallenge(1, "no");
    }

    function test_GetChallengesByDecision() public {
        vm.prank(challenger);
        challenge.fileChallenge{value: 0.001 ether}(DECISION_ID, "wrong");
        vm.prank(challenger);
        challenge.fileChallenge{value: 0.001 ether}(DECISION_ID, "wrong again");

        uint256[] memory ids = challenge.getChallengesByDecision(DECISION_ID);
        assertEq(ids.length, 2);
    }
}
