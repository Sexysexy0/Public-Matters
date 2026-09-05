// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/ChildProtectionFund.sol";

contract ChildProtectionFundTest is Test {
    ChildProtectionFund fund;

    function setUp() public {
        fund = new ChildProtectionFund(address(this));
    }

    function testAllocateFunds() public {
        fund.allocate(address(0xBEEF), 100 ether);
        uint256 allocated = fund.allocations(address(0xBEEF));
        assertEq(allocated, 100 ether);
    }

    function testOnlyGovernanceCanAllocate() public {
        vm.prank(address(0xCAFE));
        vm.expectRevert("Only governance");
        fund.allocate(address(0xBEEF), 50 ether);
    }
}
