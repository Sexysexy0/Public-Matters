// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {QuadraticFundingTreasury} from "../contracts/QuadraticFundingTreasury.sol";

contract MockOperatorPrivileges {
    mapping(address => bool) public ops;
    function setOperator(address a, bool v) external { ops[a] = v; }
    function isOperator(address a) external view returns (bool) { return ops[a]; }
}

contract QuadraticFundingTreasuryTest is Test {
    QuadraticFundingTreasury treasury;
    MockOperatorPrivileges opv;
    address operator = address(0xB0b);
    address projectOwner = address(0xC1c);
    address contributor1 = address(0xD1d);
    address contributor2 = address(0xE1e);

    function setUp() public {
        opv = new MockOperatorPrivileges();
        treasury = new QuadraticFundingTreasury(address(opv));
        opv.setOperator(operator, true);
        vm.deal(address(this), 10 ether);
        treasury.fundMatchingPool{value: 2 ether}();
    }

    function test_FundMatchingPool() public view {
        assertEq(treasury.matchingPool(), 2 ether);
    }

    function test_StartRound() public {
        vm.prank(operator);
        uint256 roundId = treasury.startRound(3600);
        assertEq(roundId, 0);
        assertTrue(treasury.roundActive());
    }

    function test_RegisterAndContribute() public {
        vm.prank(operator);
        treasury.startRound(3600);
        vm.prank(projectOwner);
        treasury.registerProject(0);
        vm.deal(contributor1, 1 ether);
        vm.prank(contributor1);
        treasury.contribute{value: 0.1 ether}(0, projectOwner);
        (, , , uint256 totalContrib, ) = treasury.projects(0, projectOwner);
        assertEq(totalContrib, 0.1 ether);
    }

    function test_FinalizeRoundDistributesMatching() public {
        vm.prank(operator);
        treasury.startRound(3600);
        vm.prank(projectOwner);
        treasury.registerProject(0);
        vm.deal(contributor1, 1 ether);
        vm.prank(contributor1);
        treasury.contribute{value: 0.1 ether}(0, projectOwner);
        vm.warp(block.timestamp + 3601);
        vm.prank(operator);
        treasury.finalizeRound(0);
        assertGt(treasury.pendingWithdrawals(projectOwner), 0);
    }

    function test_NonOperatorCannotStartRound() public {
        vm.prank(address(0xDEAD));
        vm.expectRevert();
        treasury.startRound(3600);
    }

    function test_WithdrawPullBased() public {
        vm.prank(operator);
        treasury.startRound(3600);
        vm.prank(projectOwner);
        treasury.registerProject(0);
        vm.deal(contributor1, 1 ether);
        vm.prank(contributor1);
        treasury.contribute{value: 0.1 ether}(0, projectOwner);
        vm.warp(block.timestamp + 3601);
        vm.prank(operator);
        treasury.finalizeRound(0);
        uint256 before = projectOwner.balance;
        vm.prank(projectOwner);
        treasury.withdraw();
        assertGt(projectOwner.balance, before);
    }
}
