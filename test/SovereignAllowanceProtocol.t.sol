// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import {Test} from "forge-std/Test.sol";
import { } from "../contracts/SovereignAllowanceProtocol.sol";

contract SovereignAllowanceProtocolTest is Test {
    SovereignAllowanceProtocol public protocol;
    address public guardianWallet = address(0x1111);
    address public auditorWallet = address(0x2222);

    function setUp() public {
        vm.prank(guardianWallet);
        protocol = new SovereignAllowanceProtocol();
        payable(address(protocol)).transfer(10 ether);
    }

    function test_ConfigureAndClaimAllowance() public {
        vm.prank(guardianWallet);
        protocol.configureAllowance(auditorWallet, 1 ether);
        uint256 initialBalance = auditorWallet.balance;
        vm.prank(auditorWallet);
        protocol.claimAllowance();
        assertEq(auditorWallet.balance, initialBalance + 1 ether);
    }

    function test_TimelockEnforcement() public {
        vm.prank(guardianWallet);
        protocol.configureAllowance(auditorWallet, 1 ether);
        vm.startPrank(auditorWallet);
        protocol.claimAllowance();
        vm.expectRevert("Error: Cycle timelock active.");
        protocol.claimAllowance();
        vm.warp(block.timestamp + 7 days + 1 seconds);
        protocol.claimAllowance();
        vm.stopPrank();
    }
}
