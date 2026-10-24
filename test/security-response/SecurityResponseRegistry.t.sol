// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {SecurityResponseRegistry} from "../../src/security-response/SecurityResponseRegistry.sol";

contract SecurityResponseRegistryTest is Test {
    SecurityResponseRegistry registry;
    address deployer = makeAddr("deployer");
    bytes32 evidence = keccak256("evidence");

    function setUp() public {
        vm.prank(deployer);
        registry = new SecurityResponseRegistry();
    }

    function _propose(uint256 deadline) internal returns (uint256 id) {
        vm.prank(deployer);
        id = registry.proposeAction(
            SecurityResponseRegistry.IncidentKind.PHP2SHELL, "Patch all PHP servers", evidence, deadline
        );
    }

    function test_DeployerBecomesAdminAndFederation() public {
        assertEq(registry.admin(), deployer);
        assertEq(registry.federation(), deployer);
        assertEq(registry.totalActions(), 0);
    }

    function test_ProposeAction() public {
        uint256 deadline = block.timestamp + 7 days;
        uint256 id = _propose(deadline);

        SecurityResponseRegistry.Action memory a = registry.getAction(id);
        assertEq(uint8(a.status), uint8(SecurityResponseRegistry.Status.PROPOSED));
        assertEq(a.deadline, deadline);
        assertEq(a.proposer, deployer);
        assertEq(registry.totalActions(), 1);
    }

    function test_CommitAction() public {
        uint256 id = _propose(block.timestamp + 7 days);

        vm.prank(deployer);
        registry.commitAction(id);

        SecurityResponseRegistry.Action memory a = registry.getAction(id);
        assertEq(uint8(a.status), uint8(SecurityResponseRegistry.Status.COMMITTED));
    }

    function test_EnforceAction() public {
        uint256 id = _propose(block.timestamp + 7 days);

        vm.startPrank(deployer);
        registry.commitAction(id);
        registry.enforceAction(id, evidence);
        vm.stopPrank();

        SecurityResponseRegistry.Action memory a = registry.getAction(id);
        assertEq(uint8(a.status), uint8(SecurityResponseRegistry.Status.ENFORCED));
        assertGt(a.enforcedAt, 0);
    }

    function test_MarkViolated() public {
        uint256 id = _propose(block.timestamp + 1 days);

        vm.warp(block.timestamp + 2 days);
        registry.markViolated(id);

        SecurityResponseRegistry.Action memory a = registry.getAction(id);
        assertEq(uint8(a.status), uint8(SecurityResponseRegistry.Status.VIOLATED));
        assertGt(a.violatedAt, 0);
    }

    function test_CannotCommitAfterDeadline() public {
        uint256 id = _propose(block.timestamp + 1 days);

        vm.warp(block.timestamp + 2 days);
        vm.prank(deployer);
        vm.expectRevert(SecurityResponseRegistry.DeadlinePassed.selector);
        registry.commitAction(id);
    }

    function test_CannotEnforceWithoutCommit() public {
        uint256 id = _propose(block.timestamp + 7 days);

        vm.prank(deployer);
        vm.expectRevert(SecurityResponseRegistry.InvalidStatus.selector);
        registry.enforceAction(id, evidence);
    }

    function test_CannotCommitTwice() public {
        uint256 id = _propose(block.timestamp + 7 days);

        vm.startPrank(deployer);
        registry.commitAction(id);
        vm.expectRevert(SecurityResponseRegistry.InvalidStatus.selector);
        registry.commitAction(id);
        vm.stopPrank();
    }

    function test_OnlyAdminCanCommit() public {
        uint256 id = _propose(block.timestamp + 7 days);

        vm.prank(makeAddr("attacker"));
        vm.expectRevert(SecurityResponseRegistry.OnlyAdmin.selector);
        registry.commitAction(id);
    }

    function test_OnlyAdminCanEnforce() public {
        uint256 id = _propose(block.timestamp + 7 days);

        vm.startPrank(deployer);
        registry.commitAction(id);
        vm.stopPrank();

        vm.prank(makeAddr("attacker"));
        vm.expectRevert(SecurityResponseRegistry.OnlyAdmin.selector);
        registry.enforceAction(id, evidence);
    }

    function test_OnlyFederationCanPropose() public {
        vm.prank(makeAddr("attacker"));
        vm.expectRevert(SecurityResponseRegistry.OnlyFederation.selector);
        registry.proposeAction(SecurityResponseRegistry.IncidentKind.PHP2SHELL, "x", evidence, block.timestamp + 7 days);
    }

    function test_InvalidEvidenceReverts() public {
        vm.prank(deployer);
        vm.expectRevert(SecurityResponseRegistry.InvalidEvidence.selector);
        registry.proposeAction(
            SecurityResponseRegistry.IncidentKind.PHP2SHELL, "x", bytes32(0), block.timestamp + 7 days
        );
    }

    function test_GetActionRevertsForUnknownId() public {
        vm.expectRevert(SecurityResponseRegistry.UnknownAction.selector);
        registry.getAction(99);
    }

    function test_TotalActionsStartsAtZero() public {
        assertEq(registry.totalActions(), 0);
    }
}
