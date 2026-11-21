// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {ReputationTimelockGovernor} from "../contracts/ReputationTimelockGovernor.sol";

contract MockOperatorPrivileges {
    mapping(address => bool) public ops;

    function setOperator(address a, bool v) external {
        ops[a] = v;
    }

    function isOperator(address a) external view returns (bool) {
        return ops[a];
    }
}

contract MockTarget {
    uint256 public lastValue;

    function receiveValue(uint256 v) external payable {
        lastValue = v;
    }
}

contract ReputationTimelockGovernorTest is Test {
    ReputationTimelockGovernor governor;
    MockOperatorPrivileges opv;
    MockTarget target;
    address operator1 = address(0xB0b);
    address operator2 = address(0xC1c);

    function setUp() public {
        opv = new MockOperatorPrivileges();
        governor = new ReputationTimelockGovernor(address(opv), 3600);
        target = new MockTarget();
        opv.setOperator(operator1, true);
        opv.setOperator(operator2, true);
        vm.prank(operator1);
        governor.setReputation(operator1, 60);
        vm.prank(operator1);
        governor.setReputation(operator2, 40);
    }

    function test_SetReputation() public view {
        assertEq(governor.reputation(operator1), 60);
        assertEq(governor.totalReputation(), 100);
    }

    function test_ProposeVoteQueueExecute() public {
        vm.prank(operator1);
        uint256 pid = governor.propose(
            address(target), 0, abi.encodeWithSelector(target.receiveValue.selector, 1 ether), "Fund target"
        );
        vm.prank(operator1);
        governor.vote(pid, true);
        vm.prank(operator2);
        governor.vote(pid, true);
        vm.prank(operator1);
        governor.queue(pid);
        vm.warp(block.timestamp + 3601);
        vm.prank(operator1);
        governor.execute(pid);
        assertEq(target.lastValue(), 1 ether);
    }

    function test_QuorumNotReachedReverts() public {
        vm.prank(operator1);
        uint256 pid = governor.propose(address(target), 0, "", "Test");
        vm.prank(operator1);
        governor.vote(pid, false);
        vm.prank(operator1);
        vm.expectRevert();
        governor.queue(pid);
    }

    function test_TimelockNotElapsedReverts() public {
        vm.prank(operator1);
        uint256 pid = governor.propose(address(target), 0, "", "Test");
        vm.prank(operator1);
        governor.vote(pid, true);
        vm.prank(operator2);
        governor.vote(pid, true);
        vm.prank(operator1);
        governor.queue(pid);
        vm.prank(operator1);
        vm.expectRevert();
        governor.execute(pid);
    }

    function test_DoubleVoteReverts() public {
        vm.prank(operator1);
        uint256 pid = governor.propose(address(target), 0, "", "Test");
        vm.prank(operator1);
        governor.vote(pid, true);
        vm.prank(operator1);
        vm.expectRevert();
        governor.vote(pid, true);
    }

    function test_CancelProposal() public {
        vm.prank(operator1);
        uint256 pid = governor.propose(address(target), 0, "", "Test");
        vm.prank(operator1);
        governor.cancel(pid);
        (,,,,,,, ReputationTimelockGovernor.ProposalState state) = governor.proposals(pid);
        assertEq(uint256(state), 3); // Cancelled
    }
}
