// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivileges.sol";
import "../src/AIVetoPowerRegistry.sol";

contract AIVetoPowerRegistryTest is Test {
    OperatorPrivileges privileges;
    AIVetoPowerRegistry vetoRegistry;

    address humanOp = vm.addr(1);
    address aiAgent = vm.addr(2);
    address employee = vm.addr(3);

    bytes32 constant ACTION_ID = keccak256("Fire-Employee-001");
    bytes32 constant REASON_HASH = keccak256("Late 17 of 23 shifts");

    function setUp() public {
        privileges = new OperatorPrivileges();
        privileges.addOperator(humanOp);
        
        vetoRegistry = new AIVetoPowerRegistry(address(privileges));
    }

    function testAIProposesAction() public {
        vm.prank(humanOp);
        vetoRegistry.proposeAction(ACTION_ID, aiAgent, employee, 0, REASON_HASH);

        AIVetoPowerRegistry.VetoableAction memory a = vetoRegistry.getAction(ACTION_ID);
        assertEq(a.aiAgent, aiAgent);
        assertEq(uint(a.status), uint(AIVetoPowerRegistry.ActionStatus.PROPOSED));
    }

    function testHumanApprovesAction() public {
        vm.prank(humanOp);
        vetoRegistry.proposeAction(ACTION_ID, aiAgent, employee, 0, REASON_HASH);

        vm.prank(humanOp);
        vetoRegistry.approveAndExecute(ACTION_ID);

        AIVetoPowerRegistry.VetoableAction memory a = vetoRegistry.getAction(ACTION_ID);
        assertEq(uint(a.status), uint(AIVetoPowerRegistry.ActionStatus.EXECUTED));
        assertEq(a.humanApprover, humanOp);
        assertEq(vetoRegistry.totalExecuted(), 1);
    }

    function testHumanVetoesAction() public {
        vm.prank(humanOp);
        vetoRegistry.proposeAction(ACTION_ID, aiAgent, employee, 0, REASON_HASH);

        vm.prank(humanOp);
        vetoRegistry.vetoAction(ACTION_ID);

        AIVetoPowerRegistry.VetoableAction memory a = vetoRegistry.getAction(ACTION_ID);
        assertEq(uint(a.status), uint(AIVetoPowerRegistry.ActionStatus.VETOED));
        assertEq(vetoRegistry.totalVetoed(), 1);
    }

    function testAICannotSelfApprove() public {
        vm.prank(humanOp);
        vetoRegistry.proposeAction(ACTION_ID, aiAgent, employee, 0, REASON_HASH);

        // Prank the AI agent trying to approve
        vm.prank(aiAgent);
        vm.expectRevert("Not authorized operator");
        vetoRegistry.approveAndExecute(ACTION_ID);
    }
}
