// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/SimpleMultisig.sol";
import "../contracts/SimpleTimelock.sol";

contract IntegrationMultisigTimelockTest is Test {
    SimpleMultisig multisig;
    SimpleTimelock timelock;

    address ownerA = address(0xA11CE);
    address ownerB = address(0xB0B);
    address ownerC = address(0xC0DE);
    address recipient = address(0xD00D);

    uint256 constant DELAY = 2 hours;

    function setUp() public {
        // deploy timelock with delay and fund it
        timelock = new SimpleTimelock(DELAY);
        vm.deal(address(timelock), 1 ether);

        // deploy multisig with 3 owners, threshold 2
        address[] memory owners = new address[](3);
        owners[0] = ownerA;
        owners[1] = ownerB;
        owners[2] = ownerC;
        vm.prank(ownerA);
        multisig = new SimpleMultisig(owners, 2);
    }

    function testMultisigQueuesTimelockAndTimelockExecutes() public {
        // prepare timelock queue parameters
        bytes memory data = ""; // no calldata for direct ETH transfer
        uint256 salt = 0xBEEF;
        uint256 valueToSend = 0.1 ether;

        // Build calldata for timelock.queue(target, value, data, salt)
        bytes memory queueCalldata = abi.encodeWithSelector(timelock.queue.selector, recipient, valueToSend, data, salt);

        // Multisig submits a transaction that calls timelock.queue(...)
        vm.prank(ownerA);
        uint256 txId = multisig.submit(address(timelock), 0, queueCalldata);

        // Approvals by two owners (threshold = 2)
        vm.prank(ownerB);
        multisig.approve(txId);
        vm.prank(ownerA);
        multisig.approve(txId);

        // Execute multisig tx -> this will call timelock.queue(...) and schedule the transfer
        vm.prank(ownerA);
        multisig.execute(txId);

        // Attempt to execute the queued timelock action immediately -> should revert
        vm.expectRevert();
        timelock.execute(recipient, valueToSend, data, salt);

        // Advance time beyond delay
        vm.warp(block.timestamp + DELAY + 1);

        // Now execute the timelock queued transaction; timelock holds funds so transfer should succeed
        timelock.execute(recipient, valueToSend, data, salt);

        // Assert recipient received funds
        assertEq(address(recipient).balance, valueToSend);
    }
}
