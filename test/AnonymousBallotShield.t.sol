// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {AnonymousBallotShield} from "../contracts/AnonymousBallotShield.sol";

contract MockOperatorPrivileges {
    mapping(address => bool) public ops;
    function setOperator(address a, bool v) external { ops[a] = v; }
    function isOperator(address a) external view returns (bool) { return ops[a]; }
}

contract AnonymousBallotShieldTest is Test {
    AnonymousBallotShield shield;
    MockOperatorPrivileges opv;
    address operator = address(0xB0b);
    address voter1 = address(0xC1c);
    address voter2 = address(0xD2d);

    function setUp() public {
        opv = new MockOperatorPrivileges();
        shield = new AnonymousBallotShield(address(opv));
        opv.setOperator(operator, true);
    }

    function test_CreateBallot() public {
        vm.prank(operator);
        uint256 bid = shield.createBallot("Should we fund X?", 3600, 3600);
        (string memory question, , , , , AnonymousBallotShield.BallotStatus status) = shield.ballots(bid);
        assertEq(question, "Should we fund X?");
        assertEq(uint256(status), 0); // Open
    }

    function test_CommitAndReveal() public {
        vm.prank(operator);
        uint256 bid = shield.createBallot("Test", 3600, 3600);
        bytes32 commitment = keccak256(abi.encodePacked(true, bytes32("salt1")));
        vm.prank(voter1);
        shield.commitVote(bid, commitment);
        vm.warp(block.timestamp + 3601);
        vm.prank(voter1);
        shield.revealVote(bid, true, bytes32("salt1"));
        (, , , uint256 yes, , ) = shield.ballots(bid);
        assertEq(yes, 1);
    }

    function test_DoubleCommitReverts() public {
        vm.prank(operator);
        uint256 bid = shield.createBallot("Test", 3600, 3600);
        bytes32 commitment = keccak256(abi.encodePacked(true, bytes32("salt1")));
        vm.prank(voter1);
        shield.commitVote(bid, commitment);
        vm.prank(voter1);
        vm.expectRevert();
        shield.commitVote(bid, commitment);
    }

    function test_InvalidCommitmentReverts() public {
        vm.prank(operator);
        uint256 bid = shield.createBallot("Test", 3600, 3600);
        bytes32 commitment = keccak256(abi.encodePacked(true, bytes32("salt1")));
        vm.prank(voter1);
        shield.commitVote(bid, commitment);
        vm.warp(block.timestamp + 3601);
        vm.prank(voter1);
        vm.expectRevert();
        shield.revealVote(bid, true, bytes32("wrongSalt"));
    }

    function test_CloseBallot() public {
        vm.prank(operator);
        uint256 bid = shield.createBallot("Test", 3600, 3600);
        vm.warp(block.timestamp + 7201);
        vm.prank(operator);
        shield.closeBallot(bid);
        (, , , , , AnonymousBallotShield.BallotStatus status) = shield.ballots(bid);
        assertEq(uint256(status), 2); // Closed
    }

    function test_NonOperatorReverts() public {
        vm.prank(voter1);
        vm.expectRevert();
        shield.createBallot("Test", 3600, 3600);
    }
}
