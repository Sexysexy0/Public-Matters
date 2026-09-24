// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivileges.sol";
import "../src/AIAgentRegistry.sol";
import "../src/AIDecisionAudit.sol";
import "../src/GovernedActionGate.sol";

contract GovernedActionGateTest is Test {
    OperatorPrivileges privileges;
    AIAgentRegistry registry;
    AIDecisionAudit audit;
    GovernedActionGate gate;

    address proposer;
    address council1;
    address council2;
    address council3;
    bytes32 agentId;

    function setUp() public {
        privileges = new OperatorPrivileges();
        registry = new AIAgentRegistry(address(privileges));
        audit = new AIDecisionAudit(address(privileges));
        gate = new GovernedActionGate(address(privileges), address(registry), address(audit), 2, 1 days);

        proposer = vm.addr(1);
        council1 = vm.addr(2);
        council2 = vm.addr(3);
        council3 = vm.addr(4);

        privileges.addOperator(proposer);
        privileges.addOperator(address(this));

        gate.addCouncilMember(council1);
        gate.addCouncilMember(council2);
        gate.addCouncilMember(council3);

        // Register an agent as operator
        vm.prank(proposer);
        string[] memory caps = new string[](0);
        agentId = registry.registerAgent("Treasury-Agent-01", proposer, "OpenAI/GPT-5.6", caps);
    }

    function testProposeCreatesPending() public {
        vm.prank(proposer);
        uint256 pid = gate.propose(agentId, bytes32(0), 100 ether, "Pay supplier");
        (,,,,,,, GovernedActionGate.ProposalStatus status,,) = gate.getProposal(pid);
        assertEq(uint256(status), uint256(GovernedActionGate.ProposalStatus.PENDING));
    }

    function testApproveReachesThreshold() public {
        vm.prank(proposer);
        uint256 pid = gate.propose(agentId, bytes32(0), 100 ether, "Pay supplier");

        vm.prank(council1);
        gate.approve(pid);
        vm.prank(council2);
        gate.approve(pid);

        (,,,,,,, GovernedActionGate.ProposalStatus status, uint256 approvals,) = gate.getProposal(pid);
        assertEq(uint256(status), uint256(GovernedActionGate.ProposalStatus.APPROVED));
        assertEq(approvals, 2);
    }

    function testOneApprovalNotEnough() public {
        vm.prank(proposer);
        uint256 pid = gate.propose(agentId, bytes32(0), 100 ether, "Pay supplier");

        vm.prank(council1);
        gate.approve(pid);

        (,,,,,,, GovernedActionGate.ProposalStatus status,,) = gate.getProposal(pid);
        assertEq(uint256(status), uint256(GovernedActionGate.ProposalStatus.PENDING));
    }

    function testProposerCannotApproveOwn() public {
        // make proposer also a council member
        gate.addCouncilMember(proposer);
        vm.prank(proposer);
        uint256 pid = gate.propose(agentId, bytes32(0), 100 ether, "Pay supplier");

        vm.prank(proposer);
        vm.expectRevert("Proposer cannot approve");
        gate.approve(pid);
    }

    function testCannotVoteTwice() public {
        vm.prank(proposer);
        uint256 pid = gate.propose(agentId, bytes32(0), 100 ether, "Pay supplier");

        vm.prank(council1);
        gate.approve(pid);
        vm.prank(council1);
        vm.expectRevert("Already voted");
        gate.approve(pid);
    }

    function testReject() public {
        vm.prank(proposer);
        uint256 pid = gate.propose(agentId, bytes32(0), 100 ether, "Pay supplier");

        vm.prank(council1);
        gate.reject(pid, "suspicious supplier");

        (,,,,,,, GovernedActionGate.ProposalStatus status,,) = gate.getProposal(pid);
        assertEq(uint256(status), uint256(GovernedActionGate.ProposalStatus.REJECTED));
    }

    function testAutoExecBelowLimit() public {
        gate.setAutoExecLimit(10 ether);
        vm.prank(proposer);
        uint256 pid = gate.propose(agentId, bytes32(0), 5 ether, "Small expense");

        (,,,,,,, GovernedActionGate.ProposalStatus status,,) = gate.getProposal(pid);
        assertEq(uint256(status), uint256(GovernedActionGate.ProposalStatus.EXECUTED));
    }

    function testExecuteAfterApproval() public {
        vm.prank(proposer);
        uint256 pid = gate.propose(agentId, keccak256("d1"), 100 ether, "Pay supplier");

        vm.prank(council1);
        gate.approve(pid);
        vm.prank(council2);
        gate.approve(pid);

        vm.prank(proposer);
        gate.execute(pid);

        (,,,,,,, GovernedActionGate.ProposalStatus status,,) = gate.getProposal(pid);
        assertEq(uint256(status), uint256(GovernedActionGate.ProposalStatus.EXECUTED));
    }

    function testCannotExecuteBeforeApproval() public {
        vm.prank(proposer);
        uint256 pid = gate.propose(agentId, bytes32(0), 100 ether, "Pay supplier");

        vm.prank(proposer);
        vm.expectRevert("Not approved");
        gate.execute(pid);
    }

    function testNonCouncilCannotApprove() public {
        address stranger = vm.addr(999);
        vm.prank(proposer);
        uint256 pid = gate.propose(agentId, bytes32(0), 100 ether, "Pay supplier");

        vm.prank(stranger);
        vm.expectRevert("Not council member");
        gate.approve(pid);
    }

    function testExpire() public {
        vm.prank(proposer);
        uint256 pid = gate.propose(agentId, bytes32(0), 100 ether, "Pay supplier");

        vm.warp(block.timestamp + 2 days);
        gate.expire(pid);

        (,,,,,,, GovernedActionGate.ProposalStatus status,,) = gate.getProposal(pid);
        assertEq(uint256(status), uint256(GovernedActionGate.ProposalStatus.EXPIRED));
    }

    function testSetThresholdOnlyAdmin() public {
        address stranger = vm.addr(999);
        vm.prank(stranger);
        vm.expectRevert("Not admin");
        gate.setThreshold(3);
    }
}
