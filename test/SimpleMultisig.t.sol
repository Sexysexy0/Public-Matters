// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/SimpleMultisig.sol";

contract SimpleMultisigTest is Test {
    SimpleMultisig multisig;
    address ownerA = address(0xA11CE);
    address ownerB = address(0xB0B);
    address ownerC = address(0xC0DE);
    address recipient = address(0xD00D);

    function setUp() public {
        address[] memory owners = new address[](3);
        owners[0] = ownerA;
        owners[1] = ownerB;
        owners[2] = ownerC;

        // deploy multisig (constructor will register owners)
        vm.prank(ownerA);
        multisig = new SimpleMultisig(owners, 2);

        // fund multisig so it can send value in tests
        vm.deal(address(multisig), 1 ether);

        // ensure recipient has zero starting balance for assertions
        vm.deal(recipient, 0);
    }

    function testSubmitApproveExecute() public {
        // ownerA submits a transaction to send 0.1 ETH to recipient
        vm.prank(ownerA);
        uint256 txId = multisig.submit(recipient, 0.1 ether, "");

        // two distinct owners approve (threshold = 2)
        vm.prank(ownerB);
        multisig.approve(txId);

        vm.prank(ownerA);
        multisig.approve(txId);

        // execute after approvals
        vm.prank(ownerA);
        multisig.execute(txId);

        // recipient balance should reflect the transfer
        assertEq(address(recipient).balance, 0.1 ether);
    }

    function testCannotExecuteWithoutThreshold() public {
        // submit a tx but only one approval provided -> execute should revert
        vm.prank(ownerA);
        uint256 txId = multisig.submit(recipient, 0.05 ether, "");

        vm.prank(ownerA);
        multisig.approve(txId);

        vm.expectRevert(); // insufficient approvals
        multisig.execute(txId);
    }

    function testOnlyOwnerCanSubmitApprove() public {
        // non-owner cannot submit
        vm.prank(address(0xBAD));
        vm.expectRevert();
        multisig.submit(recipient, 0, "");

        // non-owner cannot approve
        vm.prank(address(0xBAD));
        vm.expectRevert();
        multisig.approve(0);
    }
}
