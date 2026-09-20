// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivilegesV2.sol";
import "../src/InstitutionalResetRegistry.sol";

contract InstitutionalResetRegistryTest is Test {
    OperatorPrivilegesV2 privileges;
    InstitutionalResetRegistry registry;

    address owner = address(0xA11CE);
    address op1 = address(0xB0B);
    address op2 = address(0xC0C);
    address outsider = address(0xBAD);

    bytes32 constant INSTITUTION = keccak256("singapore-education");
    bytes32 constant DOMAIN = keccak256("education");
    bytes32 constant EVIDENCE = keccak256("policy-document-hash");

    function setUp() public {
        vm.startPrank(owner);
        privileges = new OperatorPrivilegesV2();
        privileges.addOperator(op1);
        privileges.addOperator(op2);
        vm.stopPrank();
        registry = new InstitutionalResetRegistry(address(privileges));
    }

    function test_ProposeReset() public {
        vm.prank(op1);
        uint256 id = registry.proposeReset(
            INSTITUTION,
            DOMAIN,
            "De-stream education",
            "Hyper-competitive model",
            EVIDENCE
        );
        assertEq(id, 1);
        assertEq(registry.totalResets(), 1);
    }

    function test_OnlyOperatorCanPropose() public {
        vm.prank(outsider);
        vm.expectRevert("Not authorized operator");
        registry.proposeReset(INSTITUTION, DOMAIN, "Test", "Test", EVIDENCE);
    }

    function test_ApproveReset() public {
        vm.prank(op1);
        uint256 id = registry.proposeReset(INSTITUTION, DOMAIN, "Test", "Test", EVIDENCE);

        vm.prank(op2);
        registry.approveReset(id);

        InstitutionalResetRegistry.Reset memory r = registry.getReset(id);
        assertEq(r.approvals, 2);
    }

    function test_CannotApproveTwice() public {
        vm.startPrank(op1);
        uint256 id = registry.proposeReset(INSTITUTION, DOMAIN, "Test", "Test", EVIDENCE);
        vm.expectRevert("Already approved");
        registry.approveReset(id);
        vm.stopPrank();
    }

    function test_ActivateRequiresApprovals() public {
        vm.prank(op1);
        uint256 id = registry.proposeReset(INSTITUTION, DOMAIN, "Test", "Test", EVIDENCE);

        // Only 1 approval (proposer)
        vm.prank(op1);
        vm.expectRevert("Insufficient approvals");
        registry.activateReset(id);
    }

    function test_ActivateAfterApproval() public {
        vm.prank(op1);
        uint256 id = registry.proposeReset(INSTITUTION, DOMAIN, "Test", "Test", EVIDENCE);

        vm.prank(op2);
        registry.approveReset(id);

        vm.prank(op1);
        registry.activateReset(id);

        InstitutionalResetRegistry.Reset memory r = registry.getReset(id);
        assertEq(uint256(r.status), uint256(InstitutionalResetRegistry.ResetStatus.ACTIVE));
    }

    function test_CompleteReset() public {
        vm.prank(op1);
        uint256 id = registry.proposeReset(INSTITUTION, DOMAIN, "Test", "Test", EVIDENCE);
        vm.prank(op2);
        registry.approveReset(id);
        vm.prank(op1);
        registry.activateReset(id);
        vm.prank(op1);
        registry.completeReset(id);

        InstitutionalResetRegistry.Reset memory r = registry.getReset(id);
        assertEq(uint256(r.status), uint256(InstitutionalResetRegistry.ResetStatus.COMPLETED));
    }

    function test_RevertReset() public {
        vm.prank(op1);
        uint256 id = registry.proposeReset(INSTITUTION, DOMAIN, "Test", "Test", EVIDENCE);
        vm.prank(op2);
        registry.approveReset(id);
        vm.prank(op1);
        registry.activateReset(id);
        vm.prank(op1);
        registry.revertReset(id, "Policy failed");

        InstitutionalResetRegistry.Reset memory r = registry.getReset(id);
        assertEq(uint256(r.status), uint256(InstitutionalResetRegistry.ResetStatus.REVERTED));
    }

    function test_GetResetsByDomain() public {
        vm.startPrank(op1);
        registry.proposeReset(INSTITUTION, DOMAIN, "Test 1", "R1", EVIDENCE);
        registry.proposeReset(keccak256("other"), DOMAIN, "Test 2", "R2", EVIDENCE);
        vm.stopPrank();

        uint256[] memory ids = registry.getResetsByDomain(DOMAIN);
        assertEq(ids.length, 2);
    }

    function test_GetApprovals() public {
        vm.prank(op1);
        uint256 id = registry.proposeReset(INSTITUTION, DOMAIN, "Test", "Test", EVIDENCE);
        vm.prank(op2);
        registry.approveReset(id);

        InstitutionalResetRegistry.Approval[] memory approvals = registry.getApprovals(id);
        assertEq(approvals.length, 2);
    }
}
