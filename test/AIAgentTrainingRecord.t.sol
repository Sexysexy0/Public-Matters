// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivileges.sol";
import "../src/AIAgentTrainingRecord.sol";

contract AIAgentTrainingRecordTest is Test {
    OperatorPrivileges privileges;
    AIAgentTrainingRecord records;

    address owner = address(0xA11CE);
    address op1 = address(0xB0B);
    bytes32 constant AGENT_1 = keccak256("agent-1");
    bytes32 constant MODEL_HASH = keccak256("model-v1");
    bytes32 constant REASON = keccak256("policy-violation");

    function setUp() public {
        vm.startPrank(owner);
        privileges = new OperatorPrivileges();
        privileges.addOperator(op1);
        vm.stopPrank();
        records = new AIAgentTrainingRecord(address(privileges));
    }

    function test_RecordTraining() public {
        vm.prank(op1);
        uint256 idx = records.recordTraining(AGENT_1, MODEL_HASH, "ipfs://meta");
        assertEq(idx, 0);
        assertEq(records.getRecordCount(AGENT_1), 1);
    }

    function test_CannotRecordEmptyHash() public {
        vm.prank(op1);
        vm.expectRevert("Invalid model hash");
        records.recordTraining(AGENT_1, bytes32(0), "ipfs://meta");
    }

    function test_AuthorizeDeployment() public {
        vm.startPrank(op1);
        records.recordTraining(AGENT_1, MODEL_HASH, "ipfs://meta");
        records.authorizeDeployment(AGENT_1, 0);
        vm.stopPrank();
        assertTrue(records.hasActiveAuthorization(AGENT_1));
    }

    function test_CannotAuthorizeTwice() public {
        vm.startPrank(op1);
        records.recordTraining(AGENT_1, MODEL_HASH, "ipfs://meta");
        records.authorizeDeployment(AGENT_1, 0);
        vm.expectRevert("Already authorized");
        records.authorizeDeployment(AGENT_1, 0);
        vm.stopPrank();
    }

    function test_RevokeAuthorization() public {
        vm.startPrank(op1);
        records.recordTraining(AGENT_1, MODEL_HASH, "ipfs://meta");
        records.authorizeDeployment(AGENT_1, 0);
        records.revokeAuthorization(AGENT_1, REASON);
        vm.stopPrank();
        assertFalse(records.hasActiveAuthorization(AGENT_1));
    }

    function test_CannotRevokeWithoutActive() public {
        vm.prank(op1);
        vm.expectRevert("No active authorization");
        records.revokeAuthorization(AGENT_1, REASON);
    }

    function test_GetActiveRecord() public {
        vm.startPrank(op1);
        records.recordTraining(AGENT_1, MODEL_HASH, "ipfs://meta");
        records.authorizeDeployment(AGENT_1, 0);
        AIAgentTrainingRecord.TrainingRecord memory r = records.getActiveRecord(AGENT_1);
        vm.stopPrank();
        assertEq(r.modelHash, MODEL_HASH);
        assertTrue(r.active);
    }

    function test_OnlyOperatorCanRecord() public {
        vm.prank(address(0xBAD));
        vm.expectRevert("Not authorized operator");
        records.recordTraining(AGENT_1, MODEL_HASH, "ipfs://meta");
    }
}
