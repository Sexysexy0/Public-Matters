// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/SovereignAllowanceProtocol.sol";

contract SovereignAllowanceProtocolTest is Test {
    SovereignAllowanceProtocol protocol;

    function setUp() public {
        protocol = new SovereignAllowanceProtocol();
        // Fix: use call instead of transfer
        (bool success,) = payable(address(protocol)).call{value: 10 ether}("");
        require(success, "Funding failed");
    }

    function test_ConfigureAndClaimAllowance() public {
        vm.prank(address(0x1111));
        protocol.configureAllowance(address(0x2222), 1 ether);

        vm.startPrank(address(0x2222));
        protocol.claimAllowance();
        vm.stopPrank();
    }

    function test_TimelockEnforcement() public {
        vm.prank(address(0x1111));
        protocol.configureAllowance(address(0x2222), 1 ether);

        vm.startPrank(address(0x2222));
        protocol.claimAllowance();

        // Advance time by 1 day to satisfy timelock
        vm.warp(block.timestamp + 1 days);

        vm.expectRevert(bytes("Cycle timelock active."));
        protocol.claimAllowance();
        vm.stopPrank();
    }
}
