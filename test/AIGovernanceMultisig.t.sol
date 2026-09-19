// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivileges.sol";
import "../src/AIGovernanceMultisig.sol";

contract AIGovernanceMultisigTest is Test {
    OperatorPrivileges privileges;
    AIGovernanceMultisig multisig;

    address owner = address(0xA11CE);
    address signer1 = address(0x51);
    address signer2 = address(0x52);
    address signer3 = address(0x53);
    address target = address(0x74);

    function setUp() public {
        vm.startPrank(owner);
        privileges = new OperatorPrivileges();
        vm.stopPrank();

        address[] memory signers = new address[](3);
        signers[0] = signer1;
        signers[1] = signer2;
        signers[2] = signer3;

        multisig = new AIGovernanceMultisig(address(privileges), signers, 2);
    }

    function test_InitState() public view {
        assertEq(multisig.threshold(), 2);
        assertEq(multisig.signerCount(), 3);
    }

    function test_CreateProposal() public {
        vm.prank(signer1);
        uint256 id = multisig.createProposal(target, 0, "", "test proposal");
        assertEq(id, 1);
    }

    function test_NonSignerCannotPropose() public {
        vm.prank(address(0xBAD));
        vm.expectRevert("Not a signer");
        multisig.createProposal(target, 0, "", "test");
    }

    function test_ApproveAndExecute() public {
        vm.prank(signer1);
        uint256 id = multisig.createProposal(target, 0, "", "test");

        vm.prank(signer1);
        multisig.approve(id);

        AIGovernanceMultisig.Proposal memory p1 = multisig.getProposal(id);
        assertEq(p1.approvals, 1);
        assertFalse(p1.executed);

        vm.prank(signer2);
        multisig.approve(id);

        AIGovernanceMultisig.Proposal memory p2 = multisig.getProposal(id);
        assertTrue(p2.executed);
    }

    function test_CannotApproveTwice() public {
        vm.prank(signer1);
        uint256 id = multisig.createProposal(target, 0, "", "test");

        vm.startPrank(signer1);
        multisig.approve(id);
        vm.expectRevert("Already approved");
        multisig.approve(id);
        vm.stopPrank();
    }

    function test_CancelProposal() public {
        vm.prank(signer1);
        uint256 id = multisig.createProposal(target, 0, "", "test");

        vm.prank(signer1);
        multisig.cancelProposal(id);

        AIGovernanceMultisig.Proposal memory p = multisig.getProposal(id);
        assertTrue(p.cancelled);
    }

    function test_CannotApproveCancelled() public {
        vm.prank(signer1);
        uint256 id = multisig.createProposal(target, 0, "", "test");

        vm.prank(signer1);
        multisig.cancelProposal(id);

        vm.prank(signer2);
        vm.expectRevert("Cancelled");
        multisig.approve(id);
    }

    function test_ExpiredProposal() public {
        vm.prank(signer1);
        uint256 id = multisig.createProposal(target, 0, "", "test");

        vm.warp(block.timestamp + 8 days);

        vm.prank(signer2);
        vm.expectRevert("Expired");
        multisig.approve(id);
    }

    function test_AddSigner() public {
        vm.prank(owner);
        multisig.addSigner(address(0x4E57));
        assertEq(multisig.signerCount(), 4);
        assertTrue(multisig.isSigner(address(0x4E57)));
    }

    function test_RemoveSigner() public {
        vm.prank(owner);
        multisig.removeSigner(signer3);
        assertEq(multisig.signerCount(), 2);
        assertFalse(multisig.isSigner(signer3));
    }

    function test_SetThreshold() public {
        vm.prank(owner);
        multisig.setThreshold(3);
        assertEq(multisig.threshold(), 3);
    }

    function test_CannotSetInvalidThreshold() public {
        vm.prank(owner);
        vm.expectRevert("Invalid threshold");
        multisig.setThreshold(10);
    }
}
